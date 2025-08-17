import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/pages/HomePage/home_page.dart';
import 'package:rota_erzincan/theme_provider.dart';

class LanguageSwitcher extends StatefulWidget {
  final bool isDarkMode;

  const LanguageSwitcher({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  late String _selectedLang;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Uygulama açıldığında geçerli dili oku
    _selectedLang = context.locale.languageCode;
  }

  void _changeLanguage(BuildContext context, String languageCode) async {
    // Desteklenen diller listesi
    final supportedLocales = context.supportedLocales;

    // Seçilen locale
    final newLocale = supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => context.fallbackLocale ?? const Locale('tr'),
    );

    // Locale değiştir
    await context.setLocale(newLocale);

    // Sayfayı yeniden başlat
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            const HomePage(), // Ana sayfan neyse onu yaz
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: themeProvider.textColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: themeProvider.textColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLang,
          icon: Icon(Icons.arrow_drop_down, color: themeProvider.textColor),
          dropdownColor: widget.isDarkMode
              ? const Color(0xFF2C2C2E)
              : const Color(0xFFE5E8E8),
          borderRadius: BorderRadius.circular(30),
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: themeProvider.textColor,
          ),
          isDense: true,
          isExpanded: true,
          items: [
            DropdownMenuItem(
              value: 'tr',
              child: Row(
                children: [
                  const Text('🇹🇷', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text('Türkçe',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: themeProvider.textColor)),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'en',
              child: Row(
                children: [
                  const Text('🇬🇧', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text('English',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: themeProvider.textColor)),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'pl',
              child: Row(
                children: [
                  const Text('🇵🇱', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text('Polski',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: themeProvider.textColor)),
                ],
              ),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              _changeLanguage(context, value);
              setState(() => _selectedLang = value);
            }
          },
        ),
      ),
    );
  }
}
