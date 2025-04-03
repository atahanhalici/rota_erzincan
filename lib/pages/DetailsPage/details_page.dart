import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
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
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final String fullText =
      "Terzibaba Camii ve Külliyesi, Erzincan'da bulunan ve şehrin en önemli dini ve kültürel yapılarından biridir. Caminin adı, halk arasında büyük bir manevi şahsiyet olarak kabul edilen Terzibaba'ya ithafen verilmiştir. 1980'li yıllarda inşa edilen cami, mimarisiyle hem modern hem de geleneksel unsurları bir araya getirir. Büyük ve gösterişli kubbesi, geniş iç hacmi ve dikkat çekici süslemeleriyle bölgenin en büyük ibadet merkezlerinden biri olarak kabul edilir. Caminin iç mekânında kalem işi süslemeler ve hat sanatı örnekleri yer alırken, avlusu da geniş bir kullanım alanına sahiptir."
      "Külliye, sadece bir ibadet alanı olmanın ötesinde, eğitim ve sosyal faaliyetlerin de gerçekleştirildiği bir merkez olarak tasarlanmıştır. Burada Kur'an kursları, dini sohbetler ve çeşitli kültürel etkinlikler düzenlenmektedir. Caminin yanında yer alan yapılar, ziyaretçilerin ve ibadet edenlerin ihtiyaçlarını karşılamak için çeşitli hizmetler sunmaktadır. Aynı zamanda, Terzibaba Camii, özellikle Cuma ve bayram namazlarında yoğun bir ziyaretçi akınına uğrar. Erzincan halkı için manevi bir merkez olmasının yanı sıra, şehir dışından gelen ziyaretçiler için de önemli bir cazibe noktasıdır."
      "Cami, Erzincan'ın şehir siluetinde önemli bir yer tutarken, özellikle akşam saatlerinde aydınlatmasıyla da ayrı bir görsel şölen sunar. İslam sanatının zarif detaylarını barındıran mimarisiyle, ziyaret edenlere huzurlu bir atmosfer sunar. Erzincan'ın kültürel ve dini mirasının bir parçası olan Terzibaba Camii ve Külliyesi, geçmişten günümüze kadar bölge halkının manevi hayatında büyük bir yer edinmiştir.";
  final List<String> imageUrls = List.generate(
      3, (index) => 'https://picsum.photos/800/500?random=$index');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                      animation: _controller,
                      builder: (context, child) {
                        return Positioned(
                          left: 0,
                          right: 0,
                          bottom: 20,
                          child: Opacity(
                            opacity: _fadeAnimation.value,
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
              opacity: _fadeAnimation,
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
                                        bgColor: themeProvider
                                            .buttonColor, // Turuncu ton
                                        iconColor: Colors.white),
                                    const BuildCircularButton(
                                        icon: Icons.location_on,
                                        bgColor: Color.fromARGB(
                                            255, 211, 84, 0), // Koyu turuncu
                                        iconColor: Color.fromARGB(255, 245, 183,
                                            70)), // Açık turuncu tonu
                                    const BuildCircularButton(
                                        icon: Icons.play_arrow,
                                        bgColor: Color.fromARGB(
                                            255, 211, 84, 0), // Koyu turuncu
                                        iconColor: Color.fromARGB(255, 245, 183,
                                            70)), // Açık turuncu tonu
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
                                  themeProvider.transparentColor,
                                  themeProvider.infoItemColor,
                                  themeProvider.transparentColor,
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            isExpanded
                                ? fullText
                                : '${fullText.substring(0, 300)}...',
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
                                    themeProvider.buttonColor.withOpacity(0.2),
                                    themeProvider.buttonColor.withOpacity(0.1),
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
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                child: Text(
                                  isExpanded
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
                              itemCount: imageUrls.length,
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
                                            images: imageUrls,
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
                                                image: imageUrls[index],
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
