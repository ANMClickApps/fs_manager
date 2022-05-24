class AccountLogo {
  final int id;
  final String title;
  final String accountImage;
  AccountLogo({
    required this.id,
    required this.title,
    required this.accountImage,
  });
}

final List<AccountLogo> accountsList = [
  AccountLogo(
    id: 1,
    title: 'Google',
    accountImage: 'assets/icons/google.svg',
  ),
  AccountLogo(
    id: 2,
    title: 'Apple',
    accountImage: 'assets/icons/apple.svg',
  ),
  AccountLogo(
    id: 3,
    title: 'GitHub',
    accountImage: 'assets/icons/github.svg',
  ),
  AccountLogo(
    id: 4,
    title: 'Instagram',
    accountImage: 'assets/icons/instagram.svg',
  ),
];
