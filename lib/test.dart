import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isExpanded = false;
  final String fullText =
      "Terzibaba Camii ve Külliyesi, Erzincan’da bulunan ve şehrin en önemli dini ve kültürel yapılarından biridir. Caminin adı, halk arasında büyük bir manevi şahsiyet olarak kabul edilen Terzibaba’ya ithafen verilmiştir. 1980’li yıllarda inşa edilen cami, mimarisiyle hem modern hem de geleneksel unsurları bir araya getirir. Büyük ve gösterişli kubbesi, geniş iç hacmi ve dikkat çekici süslemeleriyle bölgenin en büyük ibadet merkezlerinden biri olarak kabul edilir. Caminin iç mekânında kalem işi süslemeler ve hat sanatı örnekleri yer alırken, avlusu da geniş bir kullanım alanına sahiptir."
      "Külliye, sadece bir ibadet alanı olmanın ötesinde, eğitim ve sosyal faaliyetlerin de gerçekleştirildiği bir merkez olarak tasarlanmıştır. Burada Kur'an kursları, dini sohbetler ve çeşitli kültürel etkinlikler düzenlenmektedir. Caminin yanında yer alan yapılar, ziyaretçilerin ve ibadet edenlerin ihtiyaçlarını karşılamak için çeşitli hizmetler sunmaktadır. Aynı zamanda, Terzibaba Camii, özellikle Cuma ve bayram namazlarında yoğun bir ziyaretçi akınına uğrar. Erzincan halkı için manevi bir merkez olmasının yanı sıra, şehir dışından gelen ziyaretçiler için de önemli bir cazibe noktasıdır."
      "Cami, Erzincan’ın şehir siluetinde önemli bir yer tutarken, özellikle akşam saatlerinde aydınlatmasıyla da ayrı bir görsel şölen sunar. İslam sanatının zarif detaylarını barındıran mimarisiyle, ziyaret edenlere huzurlu bir atmosfer sunar. Erzincan’ın kültürel ve dini mirasının bir parçası olan Terzibaba Camii ve Külliyesi, geçmişten günümüze kadar bölge halkının manevi hayatında büyük bir yer edinmiştir.";
  final List<String> imageUrls = List.generate(
      3, (index) => 'https://picsum.photos/800/500?random=$index');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 4, 15),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: const Color.fromARGB(255, 6, 4, 15),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                double opacity = (constraints.maxHeight < 120) ? 1.0 : 0.0;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: Image.network(
                        "https://firebasestorage.googleapis.com/v0/b/karga-303a6.appspot.com/o/spodek.jpg?alt=media&token=d4498059-0877-442a-a672-909a130fb2ba", //'https://picsum.photos/800/500',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.6),
                            Colors.black.withValues(alpha: 0.1),
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
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Expanded(
                        child: Text(
                          "Terzibaba Mezarlığı ve Türbesi",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildCircularButton(
                              Icons.add,
                              const Color.fromARGB(255, 8, 109, 91),
                              Colors.white),
                          _buildCircularButton(
                              Icons.location_on,
                              const Color.fromARGB(255, 10, 30, 44),
                              const Color.fromARGB(255, 71, 214, 187)),
                          _buildCircularButton(
                              Icons.play_arrow,
                              const Color.fromARGB(255, 10, 30, 44),
                              const Color.fromARGB(255, 71, 214, 187)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Color.fromARGB(255, 34, 34, 34)),
                  const SizedBox(height: 10),
                  Text(
                    isExpanded ? fullText : '${fullText.substring(0, 300)}...',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 20, 26, 51),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Text(
                        isExpanded ? 'Daha Az Göster' : 'Devamını Oku',
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 71, 214, 187),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Color.fromARGB(255, 34, 34, 34)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullscreenGallery(
                                    images: imageUrls,
                                    initialIndex: index,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'image$index',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  imageUrls[index],
                                  fit: BoxFit.cover,
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
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, Color bgColor, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: bgColor,
        child: Icon(icon, color: iconColor, size: 28),
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
        backgroundColor: const Color.fromARGB(255, 6, 4, 15),
        title: Text(
          'Terzibaba Mezarlığı ve Türbesi',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
                    child: Image.network(
                      widget.images[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${_currentPageIndex + 1}/${widget.images.length}",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
