import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/color_constants.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/models/RouteItem.dart';
import 'package:rota_erzincan/pages/RouteDetailPage/new_route_modal_view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';

class NewRouteModal extends StatefulWidget {
  final RouteItem? editingRoute; // 👈 yeni eklendi
  const NewRouteModal({super.key, this.editingRoute});

  @override
  State<NewRouteModal> createState() => _NewRouteModalState();
}

class _NewRouteModalState extends State<NewRouteModal> {
  late NewRouteModalViewModel vm;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vm = Provider.of<NewRouteModalViewModel>(context);
  }

  @override
  void dispose() {
    vm.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Yeni Rota Oluştur",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.textColor,
                        ),
                      ),
                      Text(
                        "Kendi özel rotanızı oluşturun ve keşfedin",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: themeProvider.textColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: vm.nameController,
              cursorColor: themeProvider.buttonColor,
              style: TextStyle(color: themeProvider.textColor),
              decoration: InputDecoration(
                labelText: 'Rota Adı',
                labelStyle: TextStyle(color: themeProvider.buttonColor),
                hintText: 'Ör: Erzincan Keşfi',
                hintStyle: TextStyle(
                  color: themeProvider.textColor.withOpacity(0.5),
                ),
                filled: true,
                fillColor: themeProvider.isDarkMode
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF5F5F5),
                prefixIcon: Icon(Icons.route, color: themeProvider.buttonColor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: themeProvider.buttonColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: themeProvider.buttonColor.withOpacity(0.5)),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: vm.descController,
              cursorColor: themeProvider.buttonColor,
              style: TextStyle(color: themeProvider.textColor),
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'Rota Açıklaması',
                labelStyle: TextStyle(color: themeProvider.buttonColor),
                hintText: 'Rotanızı kısaca tanımlayın...',
                hintStyle:
                    TextStyle(color: themeProvider.textColor.withOpacity(0.5)),
                filled: true,
                fillColor: themeProvider.isDarkMode
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF5F5F5),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: themeProvider.buttonColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: themeProvider.buttonColor.withOpacity(0.5)),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.place, color: themeProvider.buttonColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Duraklar",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.textColor,
                  ),
                ),
                const Spacer(),
                Text(
                  "${vm.selectedIds.length} seçildi",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: themeProvider.buttonColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: themeProvider.isDarkMode
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: Scrollbar(
                thickness: 4,
                radius: const Radius.circular(10),
                child: ListView.builder(
                  padding: const EdgeInsets.only(right: 12),
                  shrinkWrap: true,
                  itemCount: vm.allItems.length,
                  itemBuilder: (context, index) {
                    final item = vm.allItems[index];
                    final isSelected = vm.selectedIds.contains(item.id);

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? themeProvider.buttonColor.withOpacity(0.1)
                            : themeProvider.isDarkMode
                                ? const Color(0xFF333333)
                                : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(
                                color: themeProvider.buttonColor, width: 1.5)
                            : null,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FadeInImage.assetNetwork(
                            placeholder: ImageConstants.loading,
                            image: item.imageUrl,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: themeProvider.textColor,
                          ),
                        ),
                        subtitle: Text(
                          item.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: themeProvider.textColor.withOpacity(0.7),
                          ),
                        ),
                        trailing: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? themeProvider.buttonColor
                                : themeProvider.isDarkMode
                                    ? const Color(0xFF444444)
                                    : const Color(0xFFEEEEEE),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isSelected ? Icons.check : Icons.add,
                            color: isSelected
                                ? Colors.white
                                : themeProvider.textColor.withOpacity(0.7),
                            size: 16,
                          ),
                        ),
                        onTap: () => vm.toggleSelection(item.id),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (!vm.isFormValid) {
                  Fluttertoast.cancel();
                  Fluttertoast.showToast(
                    msg:
                        "Lütfen rota adı, açıklama girin ve en az 1 durak seçin.",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    textColor: Colors.white,
                    fontSize: 14,
                  );
                  return;
                }

                if (widget.editingRoute != null) {
                  await vm.updateRoute(widget.editingRoute!.id);
                  Fluttertoast.cancel();
                  Fluttertoast.showToast(
                    msg: "Rota Başarıyla Kaydedildi",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: ColorConstants.cardColor,
                    textColor: Colors.white,
                    fontSize: 14,
                  );
                } else {
                  await vm.createRoute();
                  Fluttertoast.cancel();
                  Fluttertoast.showToast(
                    msg: "Rota Başarıyla Kaydedildi",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: ColorConstants.cardColor,
                    textColor: Colors.white,
                    fontSize: 14,
                  );
                }

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.buttonColor,
                disabledBackgroundColor:
                    themeProvider.buttonColor.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                minimumSize: const Size.fromHeight(56),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmark_add, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    widget.editingRoute != null
                        ? "Rotayı Güncelle"
                        : "Rotayı Kaydet",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
