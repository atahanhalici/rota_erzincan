import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 71, 214, 187),
        scaffoldBackgroundColor: const Color.fromARGB(255, 6, 4, 15),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(), // Boş alan
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text("HomePage'e Git"),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
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
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 4, 15),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: const IconThemeData(color: Colors.white),
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
            backgroundColor: Colors.transparent,
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
                        placeholder:
                            'assets/loading.jpg', // Yüklenirken gösterilecek resim
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
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildInfoItem(
                                      Icons.access_time, '09:00 - 18:00'),
                                  _buildInfoItem(Icons.location_on, 'Erzincan'),
                                  _buildInfoItem(Icons.star, '4.8'),
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
                        color: const Color.fromARGB(255, 20, 26, 51),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: const Color.fromARGB(255, 71, 214, 187)
                                .withOpacity(0.1),
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
                                      color: Colors.white,
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
                                    _buildCircularButton(
                                        Icons.add,
                                        Color.fromARGB(
                                            255, 230, 126, 34), // Turuncu ton
                                        Colors.white),
                                    _buildCircularButton(
                                        Icons.location_on,
                                        Color.fromARGB(
                                            255, 211, 84, 0), // Koyu turuncu
                                        Color.fromARGB(255, 245, 183,
                                            70)), // Açık turuncu tonu
                                    _buildCircularButton(
                                        Icons.play_arrow,
                                        Color.fromARGB(
                                            255, 211, 84, 0), // Koyu turuncu
                                        Color.fromARGB(255, 245, 183,
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
                                  Colors.transparent,
                                  Color.fromARGB(255, 245, 183, 70),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            isExpanded
                                ? fullText
                                : fullText.substring(0, 300) + '...',
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              color: Colors.white.withOpacity(0.9),
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
                                    Color.fromARGB(255, 230, 126, 34)
                                        .withOpacity(0.2),
                                    const Color.fromARGB(255, 230, 126, 34)
                                        .withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Color.fromARGB(255, 230, 126, 34)
                                      .withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 230, 126, 34)
                                        .withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
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
                                    color: Color.fromARGB(255, 245, 183, 70),
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
                        color: const Color.fromARGB(255, 20, 26, 51),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Color.fromARGB(255, 230, 126, 34)
                                .withOpacity(0.1),
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
                                  color: const Color.fromARGB(255, 230, 126, 34)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.photo_library,
                                  color: Color.fromARGB(255, 245, 183, 70),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Galeri',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
                                              color: const Color.fromARGB(
                                                      255, 230, 126, 34)
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
                                                    'assets/loading.jpg',
                                                image: imageUrls[index],
                                                fit: BoxFit.cover,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
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

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularButton(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: bgColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: bgColor,
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }
}

class FullscreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullscreenGallery(
      {super.key, required this.images, required this.initialIndex});

  @override
  _FullscreenGalleryState createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<FullscreenGallery> {
  late PageController _pageController;
  late int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex)
      ..addListener(() {
        final page = _pageController.page?.round() ?? 0;
        if (_currentPageIndex != page) {
          setState(() {
            _currentPageIndex = page;
          });
        }
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
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
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Hero(
                    tag: 'image$index',
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 25,
                            offset: const Offset(0, 12),
                          ),
                          BoxShadow(
                            color: const Color.fromARGB(255, 230, 126, 34)
                                .withOpacity(0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          widget.images[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo_library,
                        color: Colors.white.withOpacity(0.8),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${_currentPageIndex + 1}/${widget.images.length}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
