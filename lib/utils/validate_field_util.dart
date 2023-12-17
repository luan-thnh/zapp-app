class ValidateFieldUtil {
  static String? validatePhoneNumberOrEmail(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return 'Phone number or email must be required';
    }

    RegExp emailRegex = RegExp(r'^[a-zA-Z0-9]+(?:\.[a-zA-Z0-9]+)*@[a-zA-Z0-9]+(?:\.[a-zA-Z0-9]+)*$');
    RegExp phoneNumberRegex = RegExp(r'^(\+\d{1,2}\s?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');

    if (emailRegex.hasMatch(value!.trim())) {
      return null;
    }

    if (phoneNumberRegex.hasMatch(value.trim())) {
      return null;
    }

    return 'Invalid phone number or email address';
  }

  static String? validatePassword(String? value) {
    RegExp regex = RegExp(r'^.{8,}$');
    if (value!.isEmpty) {
      return 'Password must be required';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password must at least 8 or more characters';
      } else {
        return null;
      }
    }
  }
}
