#!/usr/bin/env dart

import 'dart:io';

void main() async {
  // Colors
  const green = '\x1B[32m';
  const yellow = '\x1B[33m';
  const blue = '\x1B[34m';
  const red = '\x1B[31m';
  const reset = '\x1B[0m';

  print('');
  print('${green}╔════════════════════════════════════════╗$reset');
  print('${green}║   Flutter Release Build Script        ║$reset');
  print('${green}╚════════════════════════════════════════╝$reset');
  print('');
  print('${blue}ℹ$reset This script will build a signed release App Bundle for Google Play');
  print('');

  // Step 1: Get password file
  print('${blue}═══ Step 1/6: Password File ═══$reset');
  print('${blue}ℹ$reset The password file should contain your keystore credentials:');
  print('${yellow}storePassword=YOUR_PASSWORD$reset');
  print('${yellow}keyPassword=YOUR_PASSWORD$reset');
  print('${yellow}keyAlias=upload$reset');
  print('');

  final passwordFile = await promptForFile(
    'Enter the path to your password file (pass.env):',
    'Password file',
  );

  // Step 2: Load credentials
  print('');
  print('${blue}═══ Step 2/6: Load Credentials ═══$reset');
  print('${blue}ℹ$reset Loading credentials from password file...');

  final credentials = await loadCredentials(passwordFile);
  if (credentials == null) {
    print('${red}✗$reset Missing required credentials in password file');
    print('');
    print('Your password file must contain:');
    print('  storePassword=YOUR_PASSWORD');
    print('  keyPassword=YOUR_PASSWORD');
    print('  keyAlias=upload');
    exit(1);
  }

  print('${green}✓$reset Credentials loaded successfully');

  // Step 3: Get keystore file
  print('');
  print('${blue}═══ Step 3/6: Keystore File ═══$reset');
  print('${blue}ℹ$reset Your keystore file should be a .jks or .keystore file');
  print('');

  final keystoreFile = await promptForFile(
    'Enter the path to your keystore file:',
    'Keystore',
  );

  // Step 4: Create key.properties
  print('');
  print('${blue}═══ Step 4/6: Configure Signing ═══$reset');
  print('${blue}ℹ$reset Creating temporary key.properties file...');

  final keyPropertiesFile = File('android/key.properties');
  await keyPropertiesFile.writeAsString('''
storePassword=${credentials['storePassword']}
keyPassword=${credentials['keyPassword']}
keyAlias=${credentials['keyAlias']}
storeFile=$keystoreFile
''');

  print('${green}✓$reset Signing configuration created');

  // Step 5: Clean and prepare
  print('');
  print('${blue}═══ Step 5/6: Prepare Build ═══$reset');

  print('${blue}ℹ$reset Cleaning previous builds...');
  await runCommand('flutter', ['clean']);
  print('${green}✓$reset Clean complete');

  print('');
  print('${blue}ℹ$reset Getting dependencies...');
  await runCommand('flutter', ['pub', 'get']);
  print('${green}✓$reset Dependencies resolved');

  // Step 6: Build release
  print('');
  print('${blue}═══ Step 6/6: Build Release ═══$reset');
  print('${blue}ℹ$reset Building signed release App Bundle...');
  print('');

  final buildSuccess = await runCommand('flutter', ['build', 'appbundle', '--release']);

  print('');
  if (buildSuccess) {
    print('${green}╔════════════════════════════════════════╗$reset');
    print('${green}║       BUILD SUCCESSFUL! ✓              ║$reset');
    print('${green}╚════════════════════════════════════════╝$reset');
    print('');
    print('${green}✓$reset Your signed App Bundle is ready!');
    print('');
    print('${yellow}📦 Output location:$reset');
    print('   build/app/outputs/bundle/release/app-release.aab');
    print('');
    print('${yellow}📋 Next steps:$reset');
    print('   1. Test the release build: flutter install --release');
    print('   2. Upload to Google Play Console');
    print('   3. Add release notes and publish');
    print('');
  } else {
    print('${red}╔════════════════════════════════════════╗$reset');
    print('${red}║         BUILD FAILED ✗                 ║$reset');
    print('${red}╚════════════════════════════════════════╝$reset');
    print('');
    print('${red}✗$reset Build failed. Check the error messages above.');
    print('');
  }

  // Cleanup
  print('${blue}ℹ$reset Cleaning up temporary files...');
  if (await keyPropertiesFile.exists()) {
    await keyPropertiesFile.delete();
  }
  print('${green}✓$reset Cleanup complete');
  print('');

  exit(buildSuccess ? 0 : 1);
}

Future<String> promptForFile(String message, String description) async {
  while (true) {
    print('');
    print('\x1B[34mℹ\x1B[0m $message');
    print('\x1B[33mTip: You can drag and drop the file into terminal\x1B[0m');
    print('');
    stdout.write('Path: ');
    
    var path = stdin.readLineSync() ?? '';
    
    // Expand tilde
    if (path.startsWith('~')) {
      path = path.replaceFirst('~', Platform.environment['HOME'] ?? '');
    }
    
    // Remove quotes
    path = path.replaceAll('"', '').replaceAll("'", '').trim();
    
    final file = File(path);
    if (await file.exists()) {
      print('\x1B[32m✓\x1B[0m $description found: $path');
      return path;
    } else {
      print('\x1B[31m✗\x1B[0m File not found: $path');
      print('\x1B[33m⚠\x1B[0m Please enter a valid file path.');
    }
  }
}

Future<Map<String, String>?> loadCredentials(String filePath) async {
  try {
    final file = File(filePath);
    final lines = await file.readAsLines();
    
    final credentials = <String, String>{};
    for (final line in lines) {
      if (line.contains('=')) {
        final parts = line.split('=');
        if (parts.length == 2) {
          credentials[parts[0].trim()] = parts[1].trim();
        }
      }
    }
    
    if (credentials.containsKey('storePassword') &&
        credentials.containsKey('keyPassword') &&
        credentials.containsKey('keyAlias')) {
      return credentials;
    }
    
    return null;
  } catch (e) {
    return null;
  }
}

Future<bool> runCommand(String command, List<String> args) async {
  final process = await Process.start(command, args);
  
  process.stdout.listen((data) {
    stdout.add(data);
  });
  
  process.stderr.listen((data) {
    stderr.add(data);
  });
  
  final exitCode = await process.exitCode;
  return exitCode == 0;
}
