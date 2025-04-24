import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/AppBar.dart';
import 'dart:ui';
import 'give_your_opinion_view_model.dart';

class GiveYourOpinionPage extends StatefulWidget {
  const GiveYourOpinionPage({super.key});

  @override
  State<GiveYourOpinionPage> createState() => _GiveYourOpinionPageState();
}

class _GiveYourOpinionPageState extends State<GiveYourOpinionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _headerAnimation;
  late Animation<double> _formAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _headerAnimation = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _formAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.9, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final viewModel = Provider.of<GiveYourOpinionViewModel>(context);
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus(); // Farkı burada!
      },
      child: Scaffold(
        backgroundColor: themeProvider.backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: themeProvider.cardColor.withValues(alpha: 0.75),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeProvider.isDarkMode
                          ? Colors.black.withValues(alpha: 0.4)
                          : Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Appbar(
                  actionIcon: const Icon(
                    Icons.search,
                    size: 28,
                    color: ColorConstants.buttonColor,
                  ),
                  onActionPressed: () {
                    viewModel.navigateToSearch();
                  },
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: -120,
              right: -100,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1500),
                opacity: 0.08,
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeProvider.buttonColor,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -60,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1500),
                opacity: 0.05,
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeProvider.isDarkMode
                        ? Colors.blueAccent
                        : Colors.deepOrange,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      AnimatedBuilder(
                        animation: _headerAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _headerAnimation.value),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        themeProvider.buttonColor,
                                        themeProvider.buttonColor
                                            .withValues(alpha: 0.6),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ShaderMask(
                                  shaderCallback: (bounds) {
                                    return LinearGradient(
                                      colors: themeProvider.isDarkMode
                                          ? [
                                              Colors.white,
                                              Colors.white
                                                  .withValues(alpha: 0.85)
                                            ]
                                          : [
                                              themeProvider.textColor,
                                              themeProvider.textColor
                                                  .withValues(alpha: 0.85)
                                            ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds);
                                  },
                                  child: Text(
                                    StringConstants.opinionPageTitle,
                                    style: GoogleFonts.poppins(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _controller.value,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 18, top: 8, bottom: 24),
                              child: Text(
                                StringConstants.opinionPageSubtitle,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: themeProvider.textColor
                                      .withValues(alpha: 0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _formAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - _formAnimation.value)),
                            child: Opacity(
                              opacity: _formAnimation.value,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: themeProvider.cardColor.withValues(
                                      alpha: themeProvider.isDarkMode
                                          ? 0.2
                                          : 0.06),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: themeProvider.textColor
                                        .withValues(alpha: 0.1),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeProvider.isDarkMode
                                          ? Colors.black.withValues(alpha: 0.2)
                                          : Colors.grey.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: viewModel.formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildAnimatedTextField(
                                        controller: viewModel.nameController,
                                        label: StringConstants.nameLabel,
                                        hint: StringConstants.nameHint,
                                        icon: Icons.person_outline,
                                        themeProvider: themeProvider,
                                        validator: viewModel.validateName,
                                        animation: _formAnimation,
                                        delay: 0,
                                      ),
                                      const SizedBox(height: 18),
                                      _buildAnimatedTextField(
                                        controller: viewModel.emailController,
                                        label: StringConstants.emailLabel,
                                        hint: StringConstants.emailHint,
                                        icon: Icons.email_outlined,
                                        themeProvider: themeProvider,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: viewModel.validateEmail,
                                        animation: _formAnimation,
                                        delay: 0.1,
                                      ),
                                      const SizedBox(height: 18),
                                      _buildAnimatedTextField(
                                        controller: viewModel.commentController,
                                        label: StringConstants.commentLabel,
                                        hint: StringConstants.commentHint,
                                        icon: Icons.comment_outlined,
                                        themeProvider: themeProvider,
                                        maxLines: 4,
                                        validator: viewModel.validateComment,
                                        animation: _formAnimation,
                                        delay: 0.2,
                                      ),
                                      const SizedBox(height: 30),
                                      Transform.translate(
                                        offset: Offset(
                                            0, 10 * (1 - _formAnimation.value)),
                                        child: Opacity(
                                          opacity: _formAnimation.value,
                                          child: SizedBox(
                                            width: size.width,
                                            height: 54,
                                            child: ElevatedButton(
                                              onPressed: viewModel.isSubmitting
                                                  ? null
                                                  : () => viewModel
                                                      .submitForm(context),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    themeProvider.buttonColor,
                                                foregroundColor: Colors.white,
                                                elevation: 8,
                                                shadowColor: themeProvider
                                                    .buttonColor
                                                    .withValues(alpha: 0.4),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                              ),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  AnimatedOpacity(
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    opacity:
                                                        viewModel.isSubmitting
                                                            ? 0.0
                                                            : 1.0,
                                                    child: const Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(Icons.send_rounded,
                                                            color: Colors.white,
                                                            size: 20),
                                                        SizedBox(width: 12),
                                                        Text(
                                                            StringConstants
                                                                .submitButtonText,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                      ],
                                                    ),
                                                  ),
                                                  AnimatedOpacity(
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    opacity:
                                                        viewModel.isSubmitting
                                                            ? 1.0
                                                            : 0.0,
                                                    child: const SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 3,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: themeProvider.backgroundColor.withValues(alpha: 0.7),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          ImageConstants.logo,
                          height: 45,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          StringConstants.footerCopyright,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color:
                                themeProvider.textColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ThemeProvider themeProvider,
    required Animation<double> animation,
    required double delay,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        double value = animation.value;
        if (animation.value < delay) {
          value = 0;
        } else {
          value = (animation.value - delay) / (1 - delay);
          if (value > 1) value = 1;
        }

        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2, bottom: 8),
                  child: Row(
                    children: [
                      Icon(icon,
                          size: 18,
                          color:
                              themeProvider.buttonColor.withValues(alpha: 0.8)),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: themeProvider.textColor.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  validator: validator,
                  style: GoogleFonts.poppins(
                    color: themeProvider.textColor,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.poppins(
                      color: themeProvider.textColor.withValues(alpha: 0.4),
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: themeProvider.isDarkMode
                        ? Colors.black.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.6),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: maxLines > 1 ? 16 : 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: themeProvider.textColor.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: themeProvider.textColor.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: themeProvider.buttonColor,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.red.shade300,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.red.shade400,
                        width: 1.5,
                      ),
                    ),
                    errorStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
