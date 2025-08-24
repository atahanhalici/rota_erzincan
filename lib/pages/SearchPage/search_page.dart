import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/pages/SearchPage/search_page_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/PlaceCardWidget.dart';
import 'package:rota_erzincan/widgets/RecentSearchesWidget.dart';
import 'package:rota_erzincan/widgets/SearchChipWidget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late SearchPageViewModel _viewModel;
  late AnimationController _controller;
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearchQuery = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..forward();

    _searchController.addListener(() {
      setState(() {
        _hasSearchQuery = _searchController.text.isNotEmpty;
      });
    });
    // ViewModel bağlantısı
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<SearchPageViewModel>(context, listen: false);
      _viewModel.loadRecentSearches(); // Kaydedilen aramaları getir
      _viewModel.fetchPlaces();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    _viewModel = Provider.of<SearchPageViewModel>(context,
        listen: true); // dinamik güncellemeler için

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus(); // Farkı burada!
      },
      child: Scaffold(
        backgroundColor: themeProvider.backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: themeProvider.cardColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(top: 10, left: 4, right: 4),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: themeProvider.buttonColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: GoogleFonts.poppins(
                        color: themeProvider.textColor,
                        fontSize: 15,
                      ),
                      cursorColor: themeProvider.buttonColor,
                      decoration: InputDecoration(
                        hintText: 'searchHintText'.tr(),
                        hintStyle: GoogleFonts.poppins(
                          color: themeProvider.textColor.withValues(alpha: 0.5),
                          fontSize: 15,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: themeProvider.buttonColor,
                        ),
                        suffixIcon: _hasSearchQuery
                            ? GestureDetector(
                                onTap: () => _searchController.clear(),
                                child: Icon(
                                  Icons.close,
                                  color: themeProvider.textColor
                                      .withValues(alpha: 0.5),
                                  size: 20,
                                ),
                              )
                            : null,
                        filled: true,
                        fillColor: themeProvider.backgroundColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (value) {
                        _viewModel.addToRecentSearches(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // Popüler aramalar
            if (!_hasSearchQuery)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Text(
                        'popularSearchesTitle'.tr(),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: themeProvider.textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          const SizedBox(width: 6), // Listenin başında boşluk
                          ..._viewModel.keys.map(
                            (key) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SearchChipWidget(
                                label: key.tr(),
                                controller: _searchController,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6), // Listenin sonunda boşluk
                        ],
                      ),
                    )
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_hasSearchQuery) ...[
                      RecentSearchesWidget(controller: _searchController),
                      const SizedBox(height: 24),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!_hasSearchQuery) ...[
                            Text(
                              'allContentTitle'.tr(),
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: themeProvider.textColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          ...(_hasSearchQuery
                                  ? _viewModel.items
                                      .where((item) => item.title
                                          .toLowerCase()
                                          .contains(_searchController.text
                                              .toLowerCase()))
                                      .toList()
                                  : _viewModel.items)
                              .map((item) => PlaceCardWidget(
                                    place: item,
                                    controller: _searchController,
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
