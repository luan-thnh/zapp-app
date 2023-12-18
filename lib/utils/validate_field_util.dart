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

  static String? validateRePassword(String? value, String? password) {
    if (value != password) {
      return 'Password do not match. Please try again.';
    } else {
      return null;
    }
  }

  static String? validateFirstName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your first name.';
    } else {
      return null;
    }
  }

  static String? validateLastName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your last name.';
    } else {
      return null;
    }
  }

  static String? validateBirthday(String? birth) {
    try {
      List<String> parts = birth!.split('/');

      int? day = int.parse(parts[0]);
      int? month = int.parse(parts[1]);
      int? year = int.parse(parts[2]);

      DateTime birthDate = DateTime(year, month, day);

      if (birthDate.year + 7 > DateTime.now().year) {
        return 'Invalid date of birth.';
      } else {
        return null;
      }
    } catch (e) {
      return 'Invalid date format.';
    }
  }
}
