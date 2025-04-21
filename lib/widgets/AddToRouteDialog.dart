import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/models/RouteItem.dart';
import 'package:rota_erzincan/pages/RouteDetailPage/new_route_modal_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/services/database_helper.dart';
import 'package:rota_erzincan/pages/DetailsPage/details_page_view_model.dart';
import 'package:rota_erzincan/widgets/NewRouteModal.dart';

class AddToRouteDialog extends StatefulWidget {
  const AddToRouteDialog({super.key});

  @override
  State<AddToRouteDialog> createState() => _AddToRouteDialogState();
}

class _AddToRouteDialogState extends State<AddToRouteDialog>
    with SingleTickerProviderStateMixin {
  List<RouteItem> _routes = [];
  Set<String> _selectedRouteIds = {};
  bool _isLoading = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animasyon kontrolcüsü
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _loadRoutes();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadRoutes() async {
    final db = await DatabaseHelper.instance.database;
    final routeData = await db.query('routes');
    final viewModel = Provider.of<DetailsPageViewModel>(context, listen: false);
    final stopId = viewModel.contentItem.id;

    print("🔍 contentItem.id: $stopId");

    List<RouteItem> loadedRoutes = routeData.map((map) {
      return RouteItem(
        id: map['id'] as String,
        title: map['title'] as String,
        subtitle: map['subtitle'] as String,
        imageUrl: map['imageUrl'] as String,
        icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
        distanceKm: map['distanceKm'] as double,
        duration: Duration(minutes: map['durationMinutes'] as int),
        isUserAdded: (map['isUserAdded'] as int) == 1,
        stops: [],
      );
    }).toList();

    Set<String> newlySelected = {};

    for (var route in loadedRoutes) {
      final existing = await db.query(
        'route_stops',
        where: 'routeId = ?',
        whereArgs: [route.id],
      );

      print("📦 route '${route.title}' (id: ${route.id}) içerikleri:");
      for (var stop in existing) {
        print(" → stop.id: ${stop['id']} (tip: ${stop['id'].runtimeType})");
      }

      final matched =
          existing.any((e) => e['id'].toString() == stopId.toString());

      if (matched) {
        newlySelected.add(route.id);
        print("✅ EŞLEŞME: '${route.title}' rotasında contentItem var.");
      } else {
        print("❌ EŞLEŞME YOK: '${route.title}' rotasında contentItem YOK.");
      }
    }

    setState(() {
      _routes = loadedRoutes;
      _selectedRouteIds = newlySelected;
      _isLoading = false;
    });

    _animationController.forward();
  }

  Future<void> _toggleContentInRoute(RouteItem route) async {
    final isSelected = _selectedRouteIds.contains(route.id);
    setState(() {
      if (isSelected) {
        _selectedRouteIds.remove(route.id);
      } else {
        _selectedRouteIds.add(route.id);
      }
    });
  }

  void _showNewRouteModal() {
    Navigator.pop(context);

    final viewModel = Provider.of<DetailsPageViewModel>(context, listen: false);
    final contentItem = viewModel.contentItem;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => NewRouteModalViewModel(initialItem: contentItem),
        child: const NewRouteModal(), // 👈 burası da güncellendi
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header ile başlık
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              decoration: BoxDecoration(
                color: themeProvider.buttonColor.withOpacity(0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.route,
                    color: themeProvider.buttonColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Rotalarım",
                    style: TextStyle(
                      color: themeProvider.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: themeProvider.textColor.withOpacity(0.7),
                      size: 22,
                    ),
                    onPressed: () => Navigator.pop(context),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),

            // Rota listesi veya yükleniyor göstergesi
            _isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(),
                  )
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: _routes.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 40, horizontal: 24),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.route_outlined,
                                  size: 48,
                                  color:
                                      themeProvider.textColor.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Henüz rota oluşturmadınız.",
                                  style: TextStyle(
                                    color: themeProvider.textColor,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.4,
                            ),
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: themeProvider.cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: _routes.length,
                              itemBuilder: (context, index) {
                                final route = _routes[index];
                                final isSelected =
                                    _selectedRouteIds.contains(route.id);

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () => _toggleContentInRoute(route),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? themeProvider.buttonColor
                                                  .withOpacity(0.1)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: themeProvider.buttonColor
                                                    .withOpacity(0.15),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                route.icon,
                                                color:
                                                    themeProvider.buttonColor,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                route.title,
                                                style: TextStyle(
                                                  color:
                                                      themeProvider.textColor,
                                                  fontWeight: isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isSelected
                                                    ? themeProvider.buttonColor
                                                    : themeProvider.cardColor,
                                                border: Border.all(
                                                  color: isSelected
                                                      ? themeProvider
                                                          .buttonColor
                                                      : Colors.grey.shade400,
                                                  width: 2,
                                                ),
                                              ),
                                              padding: const EdgeInsets.all(2),
                                              child: Opacity(
                                                opacity: isSelected ? 1.0 : 0.0,
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 16,
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
                          ),
                  ),

            // Butonlar yan yana düzenlendi
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Kaydet butonu
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveSelectedRoutes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            themeProvider.buttonColor.withOpacity(0.9),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.save_alt_rounded, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Kaydet",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Yeni rota oluştur butonu
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showNewRouteModal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeProvider.buttonColor,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_circle_outline, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Yeni Rota",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSelectedRoutes() async {
    final db = await DatabaseHelper.instance.database;
    final viewModel = Provider.of<DetailsPageViewModel>(context, listen: false);
    final content = viewModel.contentItem;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    for (var route in _routes) {
      final wasSelected = _selectedRouteIds.contains(route.id);

      final existing = await db.query(
        'route_stops',
        where: 'routeId = ? AND id = ?',
        whereArgs: [route.id, content.id],
      );

      final isAlreadyInDb = existing.isNotEmpty;

      if (wasSelected && !isAlreadyInDb) {
        // ✅ EKLEME işlemi
        await db.insert('route_stops', {
          'id': content.id,
          'routeId': route.id,
          'latitude': content.latitude,
          'longitude': content.longitude,
          'title': content.title,
          'description': content.description,
          'stopOrder': 0,
        });

        await _updateRouteDistanceAndDuration(route.id);

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
                "Durak '${content.title}' '${route.title}' rotasına eklendi."),
            action: SnackBarAction(
              label: 'Geri Al',
              onPressed: () async {
                await db.delete(
                  'route_stops',
                  where: 'routeId = ? AND id = ?',
                  whereArgs: [route.id, content.id],
                );
                await _updateRouteDistanceAndDuration(route.id);
              },
            ),
          ),
        );
      } else if (!wasSelected && isAlreadyInDb) {
        // ❌ SİLME işlemi
        await db.delete(
          'route_stops',
          where: 'routeId = ? AND id = ?',
          whereArgs: [route.id, content.id],
        );

        await _updateRouteDistanceAndDuration(route.id);

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
                "Durak '${content.title}' '${route.title}' rotasından çıkarıldı."),
            action: SnackBarAction(
              label: 'Geri Al',
              onPressed: () async {
                await db.insert('route_stops', {
                  'id': content.id,
                  'routeId': route.id,
                  'latitude': content.latitude,
                  'longitude': content.longitude,
                  'title': content.title,
                  'description': content.description,
                  'stopOrder': 0,
                });
                await _updateRouteDistanceAndDuration(route.id);
              },
            ),
          ),
        );
      } else if (wasSelected && isAlreadyInDb) {
        // 🛠️ Zaten ekli olanı güncelle
        await db.update(
          'route_stops',
          {
            'latitude': content.latitude,
            'longitude': content.longitude,
            'title': content.title,
            'description': content.description,
          },
          where: 'routeId = ? AND id = ?',
          whereArgs: [route.id, content.id],
        );
      }
    }

    Navigator.pop(context); // modalı kapat
  }

  Future<void> _updateRouteDistanceAndDuration(String routeId) async {
    final db = await DatabaseHelper.instance.database;

    final stops = await db.query(
      'route_stops',
      where: 'routeId = ?',
      whereArgs: [routeId],
      orderBy: 'stopOrder ASC',
    );

    double totalDistance = 0.0;

    for (int i = 0; i < stops.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        stops[i]['latitude'] as double,
        stops[i]['longitude'] as double,
        stops[i + 1]['latitude'] as double,
        stops[i + 1]['longitude'] as double,
      );
    }

    final totalDistanceKm = totalDistance / 1000;
    final estimatedDuration =
        Duration(minutes: (totalDistanceKm / 50 * 60).round());

    await db.update(
      'routes',
      {
        'distanceKm': double.parse(totalDistanceKm.toStringAsFixed(2)),
        'durationMinutes': estimatedDuration.inMinutes,
      },
      where: 'id = ?',
      whereArgs: [routeId],
    );
  }
}
