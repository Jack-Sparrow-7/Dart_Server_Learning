extension EmailExtension on String {
  String get normalizedEmail => trim().toLowerCase();

  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(this);
  }
}
