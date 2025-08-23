// lib/pages/GiveYourOpinion/give_your_opinion_view_model.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/core/base/base_view_model.dart';
import 'package:rota_erzincan/services/api_service.dart';

class GiveYourOpinionViewModel extends ChangeNotifier with BaseViewModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isSubmitting = false;

  final ApiService _apiService = ApiService();

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    isSubmitting = true;
    notifyListeners();

    try {
      final result = await _apiService.submitFeedback(
        senderName: nameController.text.trim(),
        senderEmail: emailController.text.trim(),
        message: commentController.text.trim(),
      );

      isSubmitting = false;
      notifyListeners();

      if (result["success"] == true) {
        // Formu temizle
        nameController.clear();
        emailController.clear();
        commentController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Text('opinionSuccessMessage'.tr()),
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
      } else {
        _showErrorSnack(context, result["error"] ?? "unknownError".tr());
      }
    } catch (e) {
      isSubmitting = false;
      notifyListeners();
      _showErrorSnack(context, e.toString());
    }
  }

  void _showErrorSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void navigateToSearch() {
    navigationService.navigateToSearchPage();
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'nameValidationEmpty'.tr();
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'emailValidationEmpty'.tr();
    }
    bool emailValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    if (!emailValid) {
      return 'emailValidationInvalid'.tr();
    }
    return null;
  }

  String? validateComment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'commentValidationEmpty'.tr();
    }
    if (value.length < 10) {
      return 'commentValidationTooShort'.tr();
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
