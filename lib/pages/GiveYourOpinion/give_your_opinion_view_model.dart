// lib/pages/GiveYourOpinion/give_your_opinion_view_model.dart
import 'package:flutter/material.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';

class GiveYourOpinionViewModel extends ChangeNotifier with BaseViewModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isSubmitting = false;

  void submitForm(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    isSubmitting = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 800), () {
      isSubmitting = false;
      nameController.clear();
      emailController.clear();
      commentController.clear();
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text(StringConstants.opinionSuccessMessage),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  void navigateToSearch() {
    navigationService.navigateToSearchPage();
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringConstants.nameValidationEmpty;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringConstants.emailValidationEmpty;
    }
    bool emailValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    if (!emailValid) {
      return StringConstants.emailValidationInvalid;
    }
    return null;
  }

  String? validateComment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringConstants.commentValidationEmpty;
    }
    if (value.length < 10) {
      return StringConstants.commentValidationTooShort;
    }
    return null;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    commentController.dispose();
    super.dispose();
  }
}
