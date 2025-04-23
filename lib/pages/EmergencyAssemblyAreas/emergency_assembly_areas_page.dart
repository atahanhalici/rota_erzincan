import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/AppBar.dart';
import 'dart:math' as math;

class EmergencyAssemblyAreasPage extends StatefulWidget {
  const EmergencyAssemblyAreasPage({super.key});

  @override
  State<EmergencyAssemblyAreasPage> createState() =>
      _EmergencyAssemblyAreasPageState();
}

class _EmergencyAssemblyAreasPageState extends State<EmergencyAssemblyAreasPage>
    with TickerProviderStateMixin {
  LatLng? userLocation;
  LatLng? selectedPoint;
  final MapController _mapController = MapController();
  bool _isLoading = true;
  bool _showFloatingPanel = false;
  Map<String, dynamic>? _floatingPanelData;
  late AnimationController _animationController;
  String? _distanceToNearest;

  final List<Map<String, dynamic>> _assemblyPoints = [
    {
      'name': 'Fatih Mahallesi Parkı',
      'point': LatLng(39.7500, 39.4900),
      'capacity': 1200,
      'facilities': ['Su İkmal Noktası', 'İlk Yardım Çadırı'],
      'description':
          'Geniş açık alan, çocuk oyun parkı bölümü ve ağaçlık alan bulunmakta.',
      'contact': 'Mahalle Muhtarlığı: 0446 XXX XX XX'
    },
    {
      'name': 'Erzincan Merkez Stadyumu',
      'point': LatLng(39.7475, 39.4905),
      'capacity': 5000,
      'facilities': [
        'Tuvalet',
        'Su İkmal Noktası',
        'Mobil Sağlık Ünitesi',
        'Çadır Alanı'
      ],
      'description': 'Büyük kapasiteli alan, tribünlü ve geniş otopark.',
      'contact': 'Stadyum Yönetimi: 0446 XXX XX XX'
    },
    {
      'name': 'Cumhuriyet Meydanı',
      'point': LatLng(39.7489, 39.4922),
      'capacity': 3000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'İlk Yardım Merkezi'],
      'description': 'Şehir merkezindeki geniş meydan, ulaşımı kolay.',
      'contact': 'Belediye: 0446 XXX XX XX'
    },
    {
      'name': 'Atatürk Mahallesi Cami Önü',
      'point': LatLng(39.7460, 39.4870),
      'capacity': 800,
      'facilities': ['Su İkmal Noktası'],
      'description': 'Cami önündeki geniş avlu, merkezi konumda.',
      'contact': 'Cami İmamı: 0446 XXX XX XX'
    },
    {
      'name': 'Halitpaşa İlkokulu Bahçesi',
      'point': LatLng(39.7490, 39.4888),
      'capacity': 1500,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'Mobil Çadır'],
      'description':
          'Okul bahçesindeki geniş alan, etrafı çevrili güvenli bölge.',
      'contact': 'Okul Müdürlüğü: 0446 XXX XX XX'
    },
    {
      'name': 'Üniversite Kavşağı Parkı',
      'point': LatLng(39.7520, 39.4945),
      'capacity': 1000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'İlk Yardım İstasyonu'],
      'description': 'Üniversite kampüsü yakınında, ulaşımı kolay.',
      'contact': 'Üniversite Güvenlik: 0446 XXX XX XX'
    },
    {
      'name': 'Erzincan AVM Arkası',
      'point': LatLng(39.7502, 39.4930),
      'capacity': 2000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'Yemek Dağıtım Noktası'],
      'description':
          "AVM'nin geniş otopark alanı, kapalı ve açık alanları mevcut.",
      'contact': 'AVM Yönetimi: 0446 XXX XX XX'
    },
    {
      'name': 'Yeni Mahalle Pazar Yeri',
      'point': LatLng(39.7445, 39.4901),
      'capacity': 2500,
      'facilities': ['Su İkmal Noktası', 'Çadır Alanı'],
      'description': 'Haftalık pazar kurulan geniş alan, üstü açık.',
      'contact': 'Mahalle Muhtarlığı: 0446 XXX XX XX'
    },
    {
      'name': 'Belediye Önü Açık Alan',
      'point': LatLng(39.7466, 39.4932),
      'capacity': 1200,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'İdari Merkez'],
      'description':
          'Belediye binası önündeki meydan, koordinasyon merkezi olarak kullanılır.',
      'contact': 'Belediye Afet Koordinasyon: 0446 XXX XX XX'
    },
    {
      'name': 'Valilik Yanı Açık Alan',
      'point': LatLng(39.7472, 39.4940),
      'capacity': 1000,
      'facilities': ['Tuvalet', 'Su İkmal Noktası', 'AFAD Yönetim Merkezi'],
      'description':
          'Valilik binası yanındaki alan, resmi kurumlarla iletişimi kolay.',
      'contact': 'Valilik AFAD Birimi: 0446 XXX XX XX'
    },
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      Position? position = await Geolocator.getLastKnownPosition();

      // Eğer cache yoksa yeni konum al
      position ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, // daha hızlı, daha az pil
      );

      setState(() {
        userLocation = LatLng(position!.latitude, position.longitude);
        _isLoading = false;
        _mapController.move(userLocation!, 16);

        // Mesafe hesapla
        final nearest = getNearestPoint();
        if (nearest != null) {
          final distanceInMeters = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            nearest['point'].latitude,
            nearest['point'].longitude,
          );

          _distanceToNearest = distanceInMeters < 1000
              ? '${distanceInMeters.toStringAsFixed(0)} metre'
              : '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic>? getNearestPoint() {
    if (userLocation == null) return null;
    final Distance distance = Distance();
    return _assemblyPoints.reduce((a, b) =>
        distance(userLocation!, a['point']) <
                distance(userLocation!, b['point'])
            ? a
            : b);
  }

  void _showAssemblyPointDetails(Map<String, dynamic> point) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Kapatma çubuğu
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorConstants.buttonColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.location_on,
                        color: ColorConstants.buttonColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          point['name'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildStatusIndicator(
                              getNearestPoint()?['point'] == point['point'],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              getNearestPoint()?['point'] == point['point']
                                  ? 'En yakın toplanma alanı $_distanceToNearest'
                                  : 'Toplanma Alanı',
                              style: TextStyle(
                                color: themeProvider.textColor.withOpacity(0.7),
                                fontSize: 14,
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
            const Divider(height: 1),
            // Scrollable detaylar
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _buildInfoRow(Icons.people, 'Kapasite',
                      '${point['capacity']} Kişi', themeProvider),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.description, 'Açıklama',
                      point['description'], themeProvider),
                  const SizedBox(height: 16),
                  _buildFacilitiesSection(point['facilities'], themeProvider),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                      Icons.phone, 'İletişim', point['contact'], themeProvider),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _mapController.move(point['point'], 17);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.navigation),
                    label: const Text(
                      'Bu Alana Yönlendir',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      setState(() {
        selectedPoint = null;
      });
    });
  }

  Widget _buildStatusIndicator(bool isNearest) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isNearest ? Colors.green : Colors.orange,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String content,
      ThemeProvider themeProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: ColorConstants.buttonColor,
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: themeProvider.textColor.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFacilitiesSection(
      List<String> facilities, ThemeProvider themeProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.local_hospital,
          color: ColorConstants.buttonColor,
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mevcut İmkanlar',
                style: TextStyle(
                  color: themeProvider.textColor.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: facilities
                    .map((facility) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: ColorConstants.buttonColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  ColorConstants.buttonColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            facility,
                            style: TextStyle(
                              color: themeProvider.textColor,
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _toggleFloatingPanel(Map<String, dynamic>? pointData) {
    setState(() {
      if (pointData == null) {
        _showFloatingPanel = false;
        _animationController.reverse();
      } else {
        _floatingPanelData = pointData;
        _showFloatingPanel = true;
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final nearest = getNearestPoint();

    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: themeProvider.cardColor.withOpacity(0.85),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: themeProvider.isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Appbar(
            actionIcon: const Icon(
              Icons.my_location,
              size: 26,
              color: ColorConstants.buttonColor,
            ),
            onActionPressed: () {
              if (userLocation != null) {
                _mapController.move(userLocation!, 16);
                _toggleFloatingPanel(null);
              }
            },
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: ColorConstants.buttonColor,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Konumunuz Alınıyor...",
                    style: TextStyle(
                      color: themeProvider.textColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // Harita
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: userLocation,
                    zoom: 15,
                    onTap: (_, __) {
                      setState(() {
                        selectedPoint = null;
                        _toggleFloatingPanel(null);
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    // Yarıçap gösterimi (sizin konumunuz etrafında)
                    if (userLocation != null)
                      CircleLayer(
                        circles: [
                          CircleMarker(
                            point: userLocation!,
                            radius: 500,
                            color: Colors.blue.withOpacity(0.1),
                            borderColor: Colors.blue.withOpacity(0.7),
                            borderStrokeWidth: 2,
                          ),
                        ],
                      ),
                    MarkerLayer(
                      markers: [
                        // Kullanıcı lokasyonu
                        if (userLocation != null)
                          Marker(
                            point: userLocation!,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.person_pin_circle,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        // Tüm acil noktalar
                        ..._assemblyPoints.map((area) {
                          final isNearest = nearest != null &&
                              area['point'] == nearest['point'];
                          final isSelected = selectedPoint != null &&
                              area['point'] == selectedPoint;

                          return Marker(
                            width: isSelected ? 500 : 60,
                            height: isSelected ? 80 : 60,
                            point: area['point'],
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPoint = area['point'];
                                });
                                _toggleFloatingPanel(area);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                transform: Matrix4.identity()
                                  ..translate(0.0, isSelected ? -10.0 : 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.blue
                                            : (isNearest
                                                ? Colors.green
                                                : ColorConstants.buttonColor),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: (isSelected
                                                    ? Colors.blue
                                                    : (isNearest
                                                        ? Colors.green
                                                        : ColorConstants
                                                            .buttonColor))
                                                .withOpacity(0.5),
                                            blurRadius: isSelected ? 12 : 8,
                                            spreadRadius: isSelected ? 4 : 2,
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.emergency,
                                        color: Colors.white,
                                        size: isSelected ? 28 : 24,
                                      ),
                                    ),
                                    if (isSelected)
                                      Container(
                                        margin: const EdgeInsets.only(top: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        constraints: const BoxConstraints(
                                          minWidth: 40,
                                          maxWidth:
                                              500, // maksimum genişlik sınırı
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          area[
                                              'name'], // split kaldırıldı, tam isim gösterilir
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          softWrap: false,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),

                // En yakın alana git buton
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Buton 1: Yenile
                      Row(
                        children: [
                          // Acil numaralar için FloatingActionButton
                          FloatingActionButton(
                            heroTag: "emergencyCall",
                            mini: true,
                            backgroundColor: Colors.red,
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (_) => Container(
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20, bottom: 30, top: 10),
                                  decoration: BoxDecoration(
                                    color: themeProvider.cardColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 5,
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Text(
                                        "Acil Durum Telefonları",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: themeProvider.textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildEmergencyCallButton(
                                          "112 - Acil Çağrı Merkezi",
                                          "112",
                                          Colors.red),
                                      const SizedBox(height: 10),
                                      _buildEmergencyCallButton(
                                          "122 - AFAD", "122", Colors.orange),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: const Icon(Icons.phone, color: Colors.white),
                          ),

                          // Yenile butonu
                          FloatingActionButton(
                            heroTag: "refreshBtn",
                            mini: true,
                            backgroundColor: themeProvider.cardColor,
                            onPressed: _getUserLocation,
                            child: Icon(
                              Icons.refresh,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      // Buton 2: En yakın alana git
                      ElevatedButton.icon(
                        onPressed: () {
                          final nearestPoint = getNearestPoint();
                          if (nearestPoint != null) {
                            _mapController.move(nearestPoint['point'], 17);
                            _toggleFloatingPanel(nearestPoint);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.buttonColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                        ),
                        icon: Transform.rotate(
                          angle: -45 * math.pi / 180,
                          child:
                              const Icon(Icons.navigation, color: Colors.white),
                        ),
                        label: const Text(
                          "En Yakın Alana Git",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                // Floating info panel
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Positioned(
                      top: 20 + kToolbarHeight,
                      left: 20,
                      right: 20,
                      child: AnimatedOpacity(
                        opacity: _showFloatingPanel ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: _showFloatingPanel && _floatingPanelData != null
                            ? Transform.translate(
                                offset: Offset(
                                    0,
                                    _animationController.value * 0 -
                                        (1 - _animationController.value) * 50),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: themeProvider.cardColor,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              _floatingPanelData!['name'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider.textColor,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.people,
                                                  size: 16,
                                                  color: themeProvider.textColor
                                                      .withOpacity(0.7),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${_floatingPanelData!['capacity']} Kişi',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: themeProvider
                                                        .textColor
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Icon(
                                                  Icons.local_hospital,
                                                  size: 16,
                                                  color: themeProvider.textColor
                                                      .withOpacity(0.7),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${_floatingPanelData!['facilities'].length} İmkan',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: themeProvider
                                                        .textColor
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _toggleFloatingPanel(null);
                                          _showAssemblyPointDetails(
                                              _floatingPanelData!);
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          backgroundColor: ColorConstants
                                              .buttonColor
                                              .withOpacity(0.1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          'Detaylar',
                                          style: TextStyle(
                                            color: ColorConstants.buttonColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ),
                    );
                  },
                ),

                // Legend Panel
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: themeProvider.cardColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Gösterge',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeProvider.textColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Konumunuz',
                              style: TextStyle(
                                color: themeProvider.textColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: const BoxDecoration(
                                color: ColorConstants.buttonColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Toplanma Alanı',
                              style: TextStyle(
                                color: themeProvider.textColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'En Yakın Alan',
                              style: TextStyle(
                                color: themeProvider.textColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Kontrol paneli
                if (!_isLoading && userLocation == null)
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          margin: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: themeProvider.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.location_disabled,
                                color: Colors.red,
                                size: 50,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Konum Erişimi Gerekli",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "En yakın acil toplanma alanını bulabilmek için konum erişimine izin vermeniz gerekiyor.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                      themeProvider.textColor.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _getUserLocation,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstants.buttonColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.location_on),
                                label: const Text("Konuma İzin Ver"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Acil telefon numaraları
                Positioned(bottom: 20, right: 20, child: SizedBox()),
              ],
            ),
    );
  }

  Widget _buildEmergencyCallButton(String text, String number, Color color) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: TextButton.icon(
        onPressed: () {
          // Telefon uygulamasını açmak için URL scheme kullanılabilir
          // Gerçek uygulamada: launchUrl(Uri.parse('tel:$number'));
        },
        icon: Icon(
          Icons.phone,
          color: color,
        ),
        label: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
