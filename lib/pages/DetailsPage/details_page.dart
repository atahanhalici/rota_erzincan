import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:rota_erzincan/models/CategoryContentItem.dart';
import 'package:rota_erzincan/pages/DetailPhotoView/detail_photo_view_page_view_model.dart';
import 'package:rota_erzincan/pages/DetailsPage/details_page_view_model.dart';
import 'package:rota_erzincan/pages/DetailPhotoView/detail_photo_view_page.dart';
import 'package:rota_erzincan/theme_provider.dart';
import 'package:rota_erzincan/widgets/AddToRouteDialog.dart';
import 'package:rota_erzincan/widgets/BuildCircularButton.dart';
import 'package:rota_erzincan/widgets/BuildInfoItem.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _headerAnimation;
  late Animation<double> _galleryAnimation;
  late Animation<double> _buttonsAnimation;

  bool _hasShownMapError = false;
  bool _isInitialized = false;
  late VoidCallback _viewModelListener;
  late DetailsPageViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<DetailsPageViewModel>(context, listen: false);

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
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _headerAnimation = Tween<double>(begin: -30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _galleryAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
      ),
    );

    _buttonsAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _viewModelListener = () {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      // zaten yukarıda alındı
      final errorMessage = viewModel.mapErrorMessage;
      if (errorMessage != null &&
          errorMessage.isNotEmpty &&
          !_hasShownMapError) {
        showErrorSnackBar(errorMessage, themeProvider);
        _hasShownMapError = true;
        Future.delayed(const Duration(seconds: 5), () {
          _hasShownMapError = false;
        });
      }
    };

    viewModel = Provider.of<DetailsPageViewModel>(context, listen: false);
    viewModel.addListener(_viewModelListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args =
          ModalRoute.of(context)!.settings.arguments as CategoryContentItem;
      final viewModel =
          Provider.of<DetailsPageViewModel>(context, listen: false);
      viewModel.init(item: args);
      _controller.forward();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    // context güvenli değil, viewModel referansını önceden saklayarak kullan
    viewModel.stopSpeaking();
    viewModel.removeListener(_viewModelListener);
    _controller.dispose();
    super.dispose();
  }

  void showErrorSnackBar(String message, ThemeProvider themeProvider) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // İçeriği dinamik hale getiriyoruz
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final viewModel = Provider.of<DetailsPageViewModel>(context);
    final localeCode = context.locale.languageCode;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: themeProvider.textColor),
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
            expandedHeight: 350,
            toolbarHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: themeProvider.transparentColor,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                double opacity = (constraints.maxHeight < 200) ? 1.0 : 0.0;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Hero Widget wrapped around the image
                    Hero(
                      tag: 'content_${viewModel.contentItem.id}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: FadeInImage.assetNetwork(
                          placeholder: ImageConstants.loading,
                          image: viewModel.contentItem.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.8),
                              Colors.black.withValues(alpha: 0.4),
                              Colors.black.withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: MediaQuery.of(context).padding.top + 10,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: opacity * _fadeAnimation.value,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 50, right: 20),
                              child: Center(
                                child: Transform.translate(
                                  offset: Offset(0, _headerAnimation.value),
                                  child: Text(
                                    viewModel.contentItem.title,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.5),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
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
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final rating = viewModel.contentItem.rating;
                        final hours = viewModel.todayHours;
                        final shortAddress = viewModel.contentItem.shortAddress;

                        // Eğer hepsi null veya boşsa widget'ı hiç gösterme
                        if ((rating == null || rating.toString().isEmpty) &&
                            (hours == null || hours.toString().isEmpty) &&
                            (shortAddress == null ||
                                shortAddress.toString().isEmpty)) {
                          return const SizedBox.shrink();
                        }

                        // Gösterilecek öğeleri listele
                        List<Widget> infoItems = [];
                        if (hours != null && hours.toString().isNotEmpty) {
                          infoItems.add(BuildInfoItem(
                              icon: Icons.access_time, text: hours.toString()));
                        }
                        if (shortAddress != null &&
                            shortAddress.toString().isNotEmpty) {
                          infoItems.add(BuildInfoItem(
                              icon: Icons.location_on,
                              text: shortAddress.toString()));
                        }
                        if (rating != null && rating.toString().isNotEmpty) {
                          infoItems.add(BuildInfoItem(
                              icon: Icons.star, text: rating.toString()));
                        }

                        return Positioned(
                          left: 0,
                          right: 0,
                          bottom: 20,
                          child: Transform.translate(
                            offset: Offset(0, (1 - _fadeAnimation.value) * 30),
                            child: Opacity(
                              opacity: _fadeAnimation.value,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: themeProvider.textColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: themeProvider.textColor
                                        .withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Wrap(
                                  alignment: WrapAlignment.spaceEvenly,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 16, // Yatay boşluk
                                  runSpacing:
                                      8, // Dikey boşluk (satırlar arası)
                                  children: infoItems,
                                ),
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
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedBuilder(
                          animation: _slideAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: themeProvider.cardColor,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                    BoxShadow(
                                      color: themeProvider.buttonColor
                                          .withValues(alpha: 0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Yazı kısmı
                                        Expanded(
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              final textStyle =
                                                  GoogleFonts.poppins(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider.textColor,
                                                letterSpacing: 0.5,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black
                                                        .withValues(alpha: 0.3),
                                                    offset: const Offset(0, 2),
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                              );

                                              final text =
                                                  viewModel.contentItem.title;

                                              final span = TextSpan(
                                                  text: text, style: textStyle);
                                              final tp = TextPainter(
                                                text: span,
                                                maxLines: null,
                                                textDirection:
                                                    ui.TextDirection.ltr,
                                              )..layout(
                                                  maxWidth:
                                                      constraints.maxWidth);

                                              final lines =
                                                  tp.computeLineMetrics();
                                              final isSingleLine =
                                                  lines.length == 1;

                                              if (isSingleLine) {
                                                final textWidth = tp.width;
                                                const buttonWidthEstimate = 40.0 *
                                                        3 +
                                                    8.0 *
                                                        2; // 3 buton + spacing
                                                final fitsInOneLine = (textWidth +
                                                        buttonWidthEstimate) <
                                                    constraints.maxWidth;

                                                if (fitsInOneLine) {
                                                  // Hepsi aynı satıra sığıyorsa
                                                  return Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: AnimatedBuilder(
                                                          animation:
                                                              _headerAnimation,
                                                          builder:
                                                              (context, child) {
                                                            return Transform
                                                                .translate(
                                                              offset: Offset(
                                                                  _headerAnimation
                                                                      .value,
                                                                  0),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            15.0),
                                                                child: Text(
                                                                  text,
                                                                  style:
                                                                      textStyle,
                                                                  softWrap:
                                                                      false,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      _buildButtonsRow(
                                                          themeProvider,
                                                          localeCode),
                                                    ],
                                                  );
                                                } else {
                                                  // Butonlar tek satıra sığmıyorsa: alta sağa yasla
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AnimatedBuilder(
                                                        animation:
                                                            _headerAnimation,
                                                        builder:
                                                            (context, child) {
                                                          return Transform
                                                              .translate(
                                                            offset: Offset(
                                                                _headerAnimation
                                                                    .value,
                                                                0),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          5.0),
                                                              child: Text(
                                                                text,
                                                                style:
                                                                    textStyle,
                                                                softWrap: true,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 6.0),
                                                          child:
                                                              _buildButtonsRow(
                                                                  themeProvider,
                                                                  localeCode),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              } else {
                                                // Çok satırlıysa: son satıra butonları koy
                                                final lastLine = lines.last;
                                                final lastOffset = Offset(
                                                    lastLine.left,
                                                    lastLine.baseline);
                                                final lastPosition = tp
                                                    .getPositionForOffset(
                                                        lastOffset)
                                                    .offset
                                                    .clamp(0, text.length);

                                                final firstPart = text
                                                    .substring(0, lastPosition);
                                                final lastPart = text
                                                    .substring(lastPosition);

                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AnimatedBuilder(
                                                      animation:
                                                          _headerAnimation,
                                                      builder:
                                                          (context, child) {
                                                        return Transform
                                                            .translate(
                                                          offset: Offset(
                                                              _headerAnimation
                                                                  .value,
                                                              0),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom:
                                                                        5.0),
                                                            child: Text(
                                                              firstPart,
                                                              style: textStyle,
                                                              softWrap: true,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            lastPart,
                                                            style: textStyle,
                                                            softWrap: true,
                                                          ),
                                                        ),
                                                        _buildButtonsRow(
                                                            themeProvider,
                                                            localeCode),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
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
                                          ? viewModel.contentItem.description
                                          : (viewModel.contentItem.description
                                                      .length >
                                                  300
                                              ? '${viewModel.contentItem.description.substring(0, 300)}...'
                                              : viewModel
                                                  .contentItem.description),
                                      textAlign: TextAlign.justify,
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        color: themeProvider.textColor
                                            .withValues(alpha: 0.9),
                                        height: 1.6,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    if (viewModel
                                            .contentItem.description.length >
                                        300)
                                      const SizedBox(height: 20),
                                    if (viewModel
                                            .contentItem.description.length >
                                        300)
                                      Center(
                                        child: AnimatedBuilder(
                                          animation: _buttonsAnimation,
                                          builder: (context, child) {
                                            return Transform.translate(
                                              offset: Offset(
                                                  0, _buttonsAnimation.value),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      themeProvider.buttonColor
                                                          .withValues(
                                                              alpha: 0.8),
                                                      themeProvider.buttonColor
                                                          .withValues(
                                                              alpha: 0.4),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                    color: themeProvider
                                                        .buttonColor
                                                        .withValues(alpha: 0.3),
                                                    width: 1,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: themeProvider
                                                          .buttonColor
                                                          .withValues(
                                                              alpha: 0.2),
                                                      blurRadius: 10,
                                                      offset:
                                                          const Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        themeProvider
                                                            .transparentColor,
                                                    shadowColor: themeProvider
                                                        .transparentColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 32,
                                                        vertical: 16),
                                                  ),
                                                  onPressed: () {
                                                    viewModel.toggleExpanded();
                                                  },
                                                  child: Text(
                                                    viewModel.isExpanded
                                                        ? 'showLessText'.tr()
                                                        : 'readMoreText'.tr(),
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.5,
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
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        if (viewModel.contentItem.extraImages != null &&
                            viewModel.contentItem.extraImages!.isNotEmpty)
                          AnimatedBuilder(
                            animation: _galleryAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                    0, 30 * (1 - _galleryAnimation.value)),
                                child: Opacity(
                                  opacity: _galleryAnimation.value,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: themeProvider.cardColor,
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                        BoxShadow(
                                          color: themeProvider.buttonColor
                                              .withValues(alpha: 0.1),
                                          blurRadius: 20,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: themeProvider.buttonColor
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                Icons.photo_library,
                                                color:
                                                    themeProvider.infoItemColor,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'galleryTitle'.tr(),
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
                                            itemCount: viewModel.contentItem
                                                .extraImages!.length,
                                            itemBuilder: (context, index) {
                                              // Create staggered animation for each gallery item
                                              final delay = 0.5 + (index * 0.1);
                                              final itemAnimation =
                                                  Tween<double>(
                                                          begin: 0.0, end: 1.0)
                                                      .animate(
                                                CurvedAnimation(
                                                  parent: _controller,
                                                  curve: Interval(
                                                    delay < 1.0 ? delay : 0.9,
                                                    (delay + 0.2) < 1.0
                                                        ? (delay + 0.2)
                                                        : 1.0,
                                                    curve: Curves.easeOutQuart,
                                                  ),
                                                ),
                                              );

                                              return AnimatedBuilder(
                                                animation: itemAnimation,
                                                builder: (context, child) {
                                                  return Transform.translate(
                                                    offset: Offset(
                                                        30 *
                                                            (1 -
                                                                itemAnimation
                                                                    .value),
                                                        0),
                                                    child: Opacity(
                                                      opacity:
                                                          itemAnimation.value,
                                                      child: child,
                                                    ),
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 12),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              ChangeNotifierProvider(
                                                            create: (_) =>
                                                                DetailPhotoViewPageViewModel(
                                                                    index),
                                                            child:
                                                                DetailPhotoView(
                                                              imageUrl: viewModel
                                                                      .contentItem
                                                                      .extraImages![
                                                                  index],
                                                              heroTag:
                                                                  'image$index',
                                                              galleryImages: viewModel
                                                                  .contentItem
                                                                  .extraImages!,
                                                              initialIndex:
                                                                  index,
                                                              title: viewModel
                                                                  .contentItem
                                                                  .title,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Hero(
                                                      tag: 'image$index',
                                                      child: Container(
                                                        width: 200,
                                                        height: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withValues(
                                                                      alpha:
                                                                          0.3),
                                                              blurRadius: 12,
                                                              offset:
                                                                  const Offset(
                                                                      0, 6),
                                                            ),
                                                            BoxShadow(
                                                              color: themeProvider
                                                                  .buttonColor
                                                                  .withValues(
                                                                      alpha:
                                                                          0.1),
                                                              blurRadius: 15,
                                                              offset:
                                                                  const Offset(
                                                                      0, 0),
                                                            ),
                                                          ],
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: Stack(
                                                            fit:
                                                                StackFit.expand,
                                                            children: [
                                                              FadeInImage
                                                                  .assetNetwork(
                                                                placeholder:
                                                                    ImageConstants
                                                                        .loading,
                                                                image: viewModel
                                                                    .contentItem
                                                                    .extraImages![index],
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  gradient:
                                                                      LinearGradient(
                                                                    colors: [
                                                                      themeProvider
                                                                          .transparentColor,
                                                                      Colors
                                                                          .black
                                                                          .withValues(
                                                                              alpha: 0.7),
                                                                    ],
                                                                    begin: Alignment
                                                                        .topCenter,
                                                                    end: Alignment
                                                                        .bottomCenter,
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                left: 12,
                                                                right: 12,
                                                                bottom: 12,
                                                                child: Text(
                                                                  '${'photoPrefix'.tr()} ${index + 1}',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
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
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsRow(ThemeProvider themeProvider, String localeCode) {
    final hasLocation = viewModel.contentItem.latitude != null &&
        viewModel.contentItem.longitude != null;

    return AnimatedBuilder(
      animation: _buttonsAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _buttonsAnimation.value),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasLocation) ...[
                BuildCircularButton(
                  icon: Icons.add,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => ChangeNotifierProvider.value(
                        value: Provider.of<DetailsPageViewModel>(context,
                            listen: false),
                        child: const AddToRouteDialog(),
                      ),
                    );
                  },
                  bgColor: themeProvider.buttonColor,
                  iconColor: Colors.white,
                ),
                const SizedBox(width: 8),
                BuildCircularButton(
                  icon: Icons.location_on,
                  onTap: () => viewModel.openMapApp(context, themeProvider),
                  bgColor: const Color.fromARGB(255, 211, 84, 0),
                  iconColor: const Color.fromARGB(255, 245, 183, 70),
                ),
                const SizedBox(width: 8),
              ],

              // Her zaman gösterilecek TTS butonu
              BuildCircularButton(
                onTap: () => viewModel.toggleSpeaking(localeCode),
                icon: viewModel.isSpeaking ? Icons.stop : Icons.play_arrow,
                isGlowing: viewModel.isSpeaking,
                bgColor: const Color.fromARGB(255, 211, 84, 0),
                iconColor: const Color.fromARGB(255, 245, 183, 70),
              ),
            ],
          ),
        );
      },
    );
  }
}
