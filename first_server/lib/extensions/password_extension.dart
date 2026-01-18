extension PasswordExtension on String {
  bool get isStrongPassword {
    return length >= 8;
  }
}
