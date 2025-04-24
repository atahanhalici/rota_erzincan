// lib/pages/GiveYourOpinion/give_your_opinion_view_model.dart
import 'package:flutter/material.dart';

class GiveYourOpinionViewModel extends ChangeNotifier {
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
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text("Görüşünüz alındı, teşekkür ederiz!"),
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

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Lütfen adınızı giriniz';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Lütfen e-posta adresinizi giriniz';
    }
    bool emailValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    if (!emailValid) {
      return 'Geçerli bir e-posta adresi giriniz';
    }
    return null;
  }

  String? validateComment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Lütfen görüşünüzü giriniz';
    }
    if (value.length < 10) {
      return 'Görüşünüz en az 10 karakter olmalıdır';
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
