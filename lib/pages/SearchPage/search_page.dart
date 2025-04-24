import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearchQuery = false;
  final List<String> _recentSearches = [];
  final List<CategoryContentItem> contentItems = [
    CategoryContentItem(
      id: '1',
      title: 'Terzi Baba Türbesi',
      description: 'Erzincan merkezde bulunan tarihi türbe.',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
      latitude: 39.7509,
      longitude: 39.4958,
    ),
    CategoryContentItem(
      id: '2',
      title: 'Girlevik Şelalesi',
      description: 'Erzincan\'ın doğal güzelliklerinden biri olan şelale.',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
      latitude: 39.6290,
      longitude: 39.6412,
    ),
    CategoryContentItem(
      id: '3',
      title: 'Ergan Dağı Kayak Merkezi',
      description: 'Erzincan\'da kış turizmi için ideal kayak merkezi.',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
      latitude: 39.6133,
      longitude: 39.5061,
    ),
    CategoryContentItem(
      id: '4',
      title: 'Kemaliye (Eğin)',
      description: 'Tarihi evleri ve doğal güzellikleriyle ünlü ilçe.',
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc',
      latitude: 39.2614,
      longitude: 38.4911,
    ),
  ];
  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedSearches = prefs.getStringList('recentSearches');
    if (savedSearches != null) {
      setState(() {
        _recentSearches.clear();
        _recentSearches.addAll(savedSearches);
      });
    }
  }

  Future<void> _saveRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recentSearches', _recentSearches);
  }

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
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addToRecentSearches(String query) {
    query = query.trim();
    if (query.isEmpty) return;

    setState(() {
      _recentSearches.remove(query); // varsa çıkar
      _recentSearches.insert(0, query); // en başa ekle
    });
    _saveRecentSearches(); // burası eklendi
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
                      hintText: 'Ne arıyorsunuz?',
                      hintStyle: GoogleFonts.poppins(
                        color: themeProvider.textColor.withOpacity(0.5),
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
                                color: themeProvider.textColor.withOpacity(0.5),
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
                      _addToRecentSearches(value);
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(
                      'Popüler Aramalar',
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
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const SizedBox(width: 6), // Listenin başında boşluk
                        ...[
                          'Terzi Baba',
                          'Girlevik Şelalesi',
                          'Ergan Dağı',
                          'Kemaliye',
                          'Refahiye',
                          'Kemah Kalesi'
                        ]
                            .map((label) => Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: _buildSearchChip(
                                      context, label, themeProvider),
                                ))
                            .toList(),
                        const SizedBox(width: 6), // Listenin sonunda boşluk
                      ],
                    ),
                  )
                ],
              ),
            ),

          // Arama sonuçları
          Expanded(
            child: _hasSearchQuery
                ? _buildSearchResults(themeProvider, size, contentItems)
                : _buildRecentSearches(themeProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChip(
      BuildContext context, String label, ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: () {
        _searchController.text = label;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: themeProvider.buttonColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: themeProvider.buttonColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: themeProvider.buttonColor,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearches(ThemeProvider themeProvider) {
    if (_recentSearches.isEmpty) {
      return Center(
        child: Text(
          'Henüz arama yapılmadı.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: themeProvider.textColor.withOpacity(0.5),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Son Aramalar',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.textColor,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('recentSearches');
                    setState(() {
                      _recentSearches.clear();
                    });
                  },
                  child: Text(
                    'Temizle',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: themeProvider.buttonColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ..._recentSearches
              .map((search) => _buildRecentSearchItem(search, themeProvider))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(String text, ThemeProvider themeProvider) {
    return Dismissible(
      key: Key(text),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _recentSearches.remove(text);
        });
        _saveRecentSearches(); // SharedPreferences'tan da silinsin
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: () {
            _searchController.text = text;
          },
          child: Row(
            children: [
              Icon(
                Icons.history,
                color: themeProvider.textColor.withOpacity(0.6),
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: themeProvider.textColor,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.north_west,
                color: themeProvider.textColor.withOpacity(0.4),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(
      ThemeProvider themeProvider, Size size, List<CategoryContentItem> items) {
    final query = _searchController.text.toLowerCase();

    final filteredItems = items.where((item) {
      final name = item.title.toLowerCase();
      return name.contains(query);
    }).toList();

    if (filteredItems.isEmpty) {
      return Center(
        child: Text(
          'Sonuç bulunamadı.',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: themeProvider.textColor.withOpacity(0.6),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final place = filteredItems[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 500 + index * 100),
          tween: Tween(begin: 0, end: 1),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: child,
              ),
            );
          },
          child: _buildPlaceCardFromModel(place, themeProvider),
        );
      },
    );
  }

  Widget _buildPlaceCardFromModel(
      CategoryContentItem place, ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: () {
        _addToRecentSearches(place.title);
        _searchController.text = "";
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: themeProvider.isDarkMode
                  ? Colors.black.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: FadeInImage.assetNetwork(
                placeholder: ImageConstants.loading,
                image: place.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: themeProvider.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    place.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: themeProvider.textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: themeProvider.buttonColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.map_outlined,
                                  color: themeProvider.buttonColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Haritada Gör',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: themeProvider.buttonColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: themeProvider.buttonColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
