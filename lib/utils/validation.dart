class Validation{
  emailValidation(String? email) {
    if ((email ?? "").isEmpty) {
      return "Email Address cannot be empty";
    } else if (!RegExp(
      r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
    ).hasMatch(email!)) {
      return "Email Address is not Valid";
    }
  }

  passwordValidation(String? password) {
    if ((password ?? "").isEmpty) {
      return "Password Cannot be empty";
    } else if (password!.length < 8) {
      return "Password must be at least 8 characters long";
    }
  }

  confirmPasswordValidation(String? confirmPassword, String password) {
    if ((confirmPassword ?? "").isEmpty) {
      return "Confirm Password Cannot be empty";
    } else if (confirmPassword != password) {
      return 'Confirm password does not match';
    }
  }
  firstNameValidation(String? firstname) {
    if ((firstname ?? "").isEmpty) {
      return "Firstname Cannot be empty";
    }
  }
  lastNameValidation(String? lastname) {
    if ((lastname ?? "").isEmpty) {
      return "Lastname Cannot be empty";
    }
  }
  aboutMeValidation(String? lastname) {
    if ((lastname ?? "").isEmpty) {
      return "About Me Cannot be empty";
    }
  }
  mobileNumberValidation(String? number) {
    if ((number ?? "").isEmpty) {
      return "Mobile number Cannot be empty";
    } else if (number!.length != 10) {
      return "Mobile Number must be of 10 digit";
    }
  }
}