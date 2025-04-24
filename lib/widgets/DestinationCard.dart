import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rota_erzincan/constants/image_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rota_erzincan/pages/HomePage/home_page.view_model.dart';
import 'package:rota_erzincan/theme_provider.dart';

class DestinationCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final int id;
  final IconData icon;

  const DestinationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.id,
    required this.icon,
  });

  @override
  State<DestinationCard> createState() => _DestinationCardState();
}

class _DestinationCardState extends State<DestinationCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final _homeModel = Provider.of<HomePageViewModel>(context, listen: true);
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: () {
          if (widget.title.contains("Ergan")) {
            _homeModel.navigateToErgan(context);
          } else {
            _homeModel.navigateToCategoryDetail(
                widget.title, widget.subtitle, widget.imageUrl, widget.icon,widget.id);
          }
        },
        onTapDown: (_) {
          _controller.forward();
        },
        onTapUp: (_) {
          _controller.reverse();
        },
        onTapCancel: () {
          _controller.reverse();
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: themeProvider.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? themeProvider.buttonColor.withValues(alpha: 0.2)
                          : themeProvider.isDarkMode
                              ? Colors.black.withValues(alpha: 0.2)
                              : Colors.grey.withValues(alpha: 0.2),
                      blurRadius: _isHovered ? 15 : 8,
                      offset:
                          _isHovered ? const Offset(0, 8) : const Offset(0, 4),
                      spreadRadius: _isHovered ? 1 : 0,
                    ),
                  ],
                  border: _isHovered
                      ? Border.all(
                          color:
                              themeProvider.buttonColor.withValues(alpha: 0.3),
                          width: 2,
                        )
                      : null,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // 🔹 Arka plan
                        Positioned.fill(
                          child: Hero(
                            tag: 'destination_${widget.title}',
                            child: FadeInImage.assetNetwork(
                              placeholder: ImageConstants.loading,
                              image: widget.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // 🔹 Gradient
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.3),
                                  Colors.black.withValues(alpha: 0.7),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // 🔹 Yazı + ikon + keşfet - aynı hizalı
                        Positioned(
                          bottom: 20,
                          left: 24,
                          right: 24,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // İkon (Yazı bloğuna göre ortalanır)
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: themeProvider.buttonColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeProvider.buttonColor
                                          .withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  widget.icon,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Yazı + Keşfet bloğu
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      widget.title,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        shadows: const [
                                          Shadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 3,
                                            color: Colors.black45,
                                          ),
                                        ],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.subtitle,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white
                                                  .withValues(alpha: 0.9),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              shadows: const [
                                                Shadow(
                                                  offset: Offset(0, 1),
                                                  blurRadius: 2,
                                                  color: Colors.black38,
                                                ),
                                              ],
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'categoryCardExploreButton'
                                                    .tr(),
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
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
                      ],
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}
