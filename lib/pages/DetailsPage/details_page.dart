import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/pages/DetailsPage/details_page_view_model.dart';
import 'package:rota_erzincan/pages/FullScreenGallery/full_screen_gallery_page.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/BuildCircularButton.dart';
import 'package:rota_erzincan/widgets/BuildInfoItem.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  late DetailsPageViewModel viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<DetailsPageViewModel>(context, listen: false);
    viewModel.init(vsync: this);
  }

  @override
  void dispose() {
    viewModel.stopSpeaking(); // Ses varsa durdur
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final viewModel = Provider.of<DetailsPageViewModel>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: themeProvider.textColor),
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            expandedHeight: 350,
            toolbarHeight: 110,
            floating: false,
            pinned: true,
            backgroundColor: themeProvider.transparentColor,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                double opacity = (constraints.maxHeight < 180) ? 1.0 : 0.0;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: FadeInImage.assetNetwork(
                        placeholder: ImageConstants
                            .loading, // Yüklenirken gösterilecek resim
                        image:
                            "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/terzibaba.jpg?alt=media&token=3d5dbf8c-7919-42f2-8b9c-be386be509cc", // Ağ üzerinden yüklenecek resim
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: MediaQuery.of(context).padding.top + 10,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: opacity,
                        child: Center(
                          child: Text(
                            'Terzibaba Mezarlığı ve Türbesi',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: viewModel.controller,
                      builder: (context, child) {
                        return Positioned(
                          left: 0,
                          right: 0,
                          bottom: 20,
                          child: Opacity(
                            opacity: viewModel.fadeAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: themeProvider.textColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      themeProvider.textColor.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  BuildInfoItem(
                                      icon: Icons.access_time,
                                      text: '09:00 - 18:00'),
                                  BuildInfoItem(
                                      icon: Icons.location_on,
                                      text: 'Erzincan'),
                                  BuildInfoItem(icon: Icons.star, text: '4.8'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: viewModel.fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: themeProvider.cardColor,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: themeProvider.buttonColor.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Terzibaba Mezarlığı ve Türbesi",
                                    style: GoogleFonts.poppins(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.textColor,
                                      letterSpacing: 0.5,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0, // Üste sabitler
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    BuildCircularButton(
                                        icon: Icons.add,
                                        onTap: () {},
                                        bgColor: themeProvider
                                            .buttonColor, // Turuncu ton
                                        iconColor: Colors.white),
                                    BuildCircularButton(
                                        icon: Icons.location_on,
                                        onTap: () {},
                                        bgColor: const Color.fromARGB(
                                            255, 211, 84, 0), // Koyu turuncu
                                        iconColor: const Color.fromARGB(255,
                                            245, 183, 70)), // Açık turuncu tonu
                                    BuildCircularButton(
                                        onTap: () async {
                                          await viewModel.toggleSpeaking();
                                        },
                                        icon: viewModel.isSpeaking
                                            ? Icons.stop
                                            : Icons.play_arrow,
                                        isGlowing: viewModel.isSpeaking,
                                        bgColor: const Color.fromARGB(
                                            255, 211, 84, 0), // Koyu turuncu
                                        iconColor: const Color.fromARGB(255,
                                            245, 183, 70)), // Açık turuncu tonu
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  themeProvider.cardColor,
                                  themeProvider.infoItemColor,
                                  themeProvider.cardColor,
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            viewModel.isExpanded
                                ? viewModel.fullText
                                : '${viewModel.fullText.substring(0, 300)}...',
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              color: themeProvider.textColor.withOpacity(0.9),
                              height: 1.6,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    themeProvider.buttonColor.withOpacity(0.8),
                                    themeProvider.buttonColor.withOpacity(0.4),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: themeProvider.buttonColor
                                      .withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeProvider.buttonColor
                                        .withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      themeProvider.transparentColor,
                                  shadowColor: themeProvider.transparentColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                ),
                                onPressed: () {
                                  viewModel.toggleExpanded();
                                },
                                child: Text(
                                  viewModel.isExpanded
                                      ? 'Daha Az Göster'
                                      : 'Devamını Oku',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: themeProvider.cardColor,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: themeProvider.buttonColor.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: themeProvider.buttonColor
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.photo_library,
                                  color: themeProvider.infoItemColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Galeri',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 170,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: viewModel.imageUrls.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FullscreenGallery(
                                            images: viewModel.imageUrls,
                                            initialIndex: index,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Hero(
                                      tag: 'image$index',
                                      child: Container(
                                        width: 200,
                                        height: double
                                            .infinity, // **Burası önemli!**
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 6),
                                            ),
                                            BoxShadow(
                                              color: themeProvider.buttonColor
                                                  .withOpacity(0.1),
                                              blurRadius: 15,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              FadeInImage.assetNetwork(
                                                placeholder:
                                                    ImageConstants.loading,
                                                image:
                                                    viewModel.imageUrls[index],
                                                fit: BoxFit.cover,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      themeProvider
                                                          .transparentColor,
                                                      Colors.black
                                                          .withOpacity(0.7),
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 12,
                                                right: 12,
                                                bottom: 12,
                                                child: Text(
                                                  'Fotoğraf ${index + 1}',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
