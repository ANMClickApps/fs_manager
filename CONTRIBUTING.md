# Contributing to FS Manager

Thank you for your interest in contributing to FS Manager! 🎉

## 🤝 How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/ANMClickApps/fs_manager/issues)
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots (if applicable)
   - Device and OS version

### Suggesting Features

1. Check existing feature requests
2. Create a new issue with `enhancement` label
3. Describe the feature and its benefits
4. Provide use cases

### Code Contributions

#### Setup Development Environment

1. Fork the repository
2. Clone your fork:
```bash
git clone https://github.com/your-username/fs_manager.git
cd fs_manager
```

3. Add upstream remote:
```bash
git remote add upstream https://github.com/ANMClickApps/fs_manager.git
```

4. Create a branch:
```bash
git checkout -b feature/your-feature-name
```

5. Set up Firebase (see README.md)

#### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `dart format` before committing
- Run `flutter analyze` to check for issues
- Comment out debug print statements in production code

#### Commit Guidelines

- Use clear, descriptive commit messages
- Start with a verb: "Add", "Fix", "Update", "Remove"
- Examples:
  - `Add trash restoration feature`
  - `Fix encryption key generation bug`
  - `Update README with setup instructions`

#### Pull Request Process

1. Update your fork:
```bash
git fetch upstream
git rebase upstream/main
```

2. Push your branch:
```bash
git push origin feature/your-feature-name
```

3. Create a Pull Request with:
   - Clear description of changes
   - Link to related issues
   - Screenshots/videos (if UI changes)
   - Test results

4. Respond to review feedback
5. Once approved, it will be merged

### Testing

- Test on both Android and iOS (if possible)
- Verify encryption/decryption works correctly
- Check Firebase operations
- Test edge cases (empty fields, special characters)

## 🛠️ Development Guidelines

### Security

- Never commit Firebase configuration files
- Use AES encryption for sensitive data
- Follow security best practices
- Report security issues privately

### Code Organization

- Keep components small and focused
- Use meaningful variable names
- Extract reusable widgets
- Follow project structure

### UI/UX

- Maintain consistent design language
- Use brand colors from `brand_color.dart`
- Ensure responsive layouts
- Add loading states
- Handle errors gracefully

## 📝 Documentation

- Update README.md if needed
- Add comments for complex logic
- Document new features
- Update CHANGELOG.md

## 🔍 Code Review

All submissions require review. We look for:

- ✅ Clean, readable code
- ✅ Proper error handling
- ✅ No security vulnerabilities
- ✅ Following project conventions
- ✅ Tests (when applicable)
- ✅ Documentation

## 🎯 Priority Areas

We especially welcome contributions in:

- 🔐 Enhanced security features
- 🌍 Internationalization (i18n)
- 🎨 UI/UX improvements
- 📱 iOS support enhancements
- 🧪 Test coverage
- 📚 Documentation

## ❓ Questions?

- Open a discussion on GitHub
- Email: anmclick@gmail.com
- Check existing issues and PRs

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing! 🙌
