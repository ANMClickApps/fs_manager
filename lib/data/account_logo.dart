import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class AccountLogo {
  final int id;
  final String title;
  final IconData iconData;
  final Color color;
  
  AccountLogo({
    required this.id,
    required this.title,
    required this.iconData,
    required this.color,
  });
}

final List<AccountLogo> accountsList = [
  // Social Media
  AccountLogo(id: 1, title: 'Facebook', iconData: FontAwesomeIcons.facebook, color: const Color(0xFF1877F2)),
  AccountLogo(id: 2, title: 'Instagram', iconData: FontAwesomeIcons.instagram, color: const Color(0xFFE4405F)),
  AccountLogo(id: 3, title: 'Twitter/X', iconData: FontAwesomeIcons.xTwitter, color: const Color(0xFF000000)),
  AccountLogo(id: 4, title: 'LinkedIn', iconData: FontAwesomeIcons.linkedin, color: const Color(0xFF0A66C2)),
  AccountLogo(id: 5, title: 'TikTok', iconData: FontAwesomeIcons.tiktok, color: const Color(0xFF000000)),
  AccountLogo(id: 6, title: 'YouTube', iconData: FontAwesomeIcons.youtube, color: const Color(0xFFFF0000)),
  AccountLogo(id: 7, title: 'Reddit', iconData: FontAwesomeIcons.reddit, color: const Color(0xFFFF4500)),
  AccountLogo(id: 8, title: 'Discord', iconData: FontAwesomeIcons.discord, color: const Color(0xFF5865F2)),
  AccountLogo(id: 9, title: 'Telegram', iconData: FontAwesomeIcons.telegram, color: const Color(0xFF26A5E4)),
  AccountLogo(id: 10, title: 'WhatsApp', iconData: FontAwesomeIcons.whatsapp, color: const Color(0xFF25D366)),
  AccountLogo(id: 11, title: 'Snapchat', iconData: FontAwesomeIcons.snapchat, color: const Color.fromARGB(255, 221, 176, 13)),
  AccountLogo(id: 12, title: 'Pinterest', iconData: FontAwesomeIcons.pinterest, color: const Color(0xFFE60023)),
  
  // Tech & Email
  AccountLogo(id: 13, title: 'Google', iconData: FontAwesomeIcons.google, color: const Color(0xFF4285F4)),
  AccountLogo(id: 14, title: 'Apple', iconData: FontAwesomeIcons.apple, color: const Color(0xFF000000)),
  AccountLogo(id: 15, title: 'Microsoft', iconData: FontAwesomeIcons.microsoft, color: const Color(0xFF00A4EF)),
  AccountLogo(id: 16, title: 'GitHub', iconData: FontAwesomeIcons.github, color: const Color(0xFF181717)),
  AccountLogo(id: 17, title: 'GitLab', iconData: FontAwesomeIcons.gitlab, color: const Color(0xFFFC6D26)),
  AccountLogo(id: 18, title: 'Bitbucket', iconData: FontAwesomeIcons.bitbucket, color: const Color(0xFF0052CC)),
  AccountLogo(id: 19, title: 'Stack Overflow', iconData: FontAwesomeIcons.stackOverflow, color: const Color(0xFFF58025)),
  AccountLogo(id: 20, title: 'Gmail', iconData: FontAwesomeIcons.envelope, color: const Color(0xFFEA4335)),
  
  // Payment & Finance
  AccountLogo(id: 21, title: 'PayPal', iconData: FontAwesomeIcons.paypal, color: const Color(0xFF00457C)),
  AccountLogo(id: 22, title: 'Stripe', iconData: FontAwesomeIcons.stripe, color: const Color(0xFF635BFF)),
  AccountLogo(id: 23, title: 'Bitcoin', iconData: FontAwesomeIcons.bitcoin, color: const Color(0xFFF7931A)),
  AccountLogo(id: 24, title: 'Credit Card', iconData: FontAwesomeIcons.creditCard, color: const Color(0xFF1A1F71)),
  
  // Cloud & Storage
  AccountLogo(id: 25, title: 'Dropbox', iconData: FontAwesomeIcons.dropbox, color: const Color(0xFF0061FF)),
  AccountLogo(id: 26, title: 'Google Drive', iconData: FontAwesomeIcons.googleDrive, color: const Color(0xFF4285F4)),
  AccountLogo(id: 27, title: 'AWS', iconData: FontAwesomeIcons.aws, color: const Color(0xFFFF9900)),
  
  // Entertainment
  AccountLogo(id: 28, title: 'Spotify', iconData: FontAwesomeIcons.spotify, color: const Color(0xFF1DB954)),
  AccountLogo(id: 29, title: 'Netflix', iconData: FontAwesomeIcons.film, color: const Color(0xFFE50914)),
  AccountLogo(id: 30, title: 'Twitch', iconData: FontAwesomeIcons.twitch, color: const Color(0xFF9146FF)),
  AccountLogo(id: 31, title: 'Steam', iconData: FontAwesomeIcons.steam, color: const Color(0xFF000000)),
  
  // E-commerce
  AccountLogo(id: 32, title: 'Amazon', iconData: FontAwesomeIcons.amazon, color: const Color(0xFFFF9900)),
  AccountLogo(id: 33, title: 'eBay', iconData: FontAwesomeIcons.ebay, color: const Color(0xFFE53238)),
  AccountLogo(id: 34, title: 'Shopify', iconData: FontAwesomeIcons.shopify, color: const Color(0xFF96BF48)),
  
  // Work & Productivity
  AccountLogo(id: 35, title: 'Slack', iconData: FontAwesomeIcons.slack, color: const Color(0xFF4A154B)),
  AccountLogo(id: 36, title: 'Trello', iconData: FontAwesomeIcons.trello, color: const Color(0xFF0079BF)),
  AccountLogo(id: 37, title: 'Notion', iconData: FontAwesomeIcons.n, color: const Color(0xFF000000)),
  
  // Other
  AccountLogo(id: 38, title: 'WordPress', iconData: FontAwesomeIcons.wordpress, color: const Color(0xFF21759B)),
  AccountLogo(id: 39, title: 'Medium', iconData: FontAwesomeIcons.medium, color: const Color(0xFF000000)),
  AccountLogo(id: 40, title: 'Skype', iconData: FontAwesomeIcons.skype, color: const Color(0xFF00AFF0)),
  AccountLogo(id: 41, title: 'Zoom', iconData: FontAwesomeIcons.video, color: const Color(0xFF2D8CFF)),
  AccountLogo(id: 42, title: 'Custom', iconData: FontAwesomeIcons.key, color: const Color(0xFF6C757D)),
];
