import 'package:flutter/material.dart';
import 'package:rota_erzincan/constants/string_constants.dart';
import 'package:rota_erzincan/widgets/InfoRow.dart';

class ShowPhotoDetails extends StatelessWidget {
  final Color cardColor;
  final Color textColor;

  const ShowPhotoDetails({
    super.key,
    required this.cardColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            color: cardColor.withValues(alpha: 0.95),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: textColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                child: Text(
                  StringConstants.photoDetailsTitle,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const InfoRow(
                      icon: Icons.location_on_outlined,
                      title: StringConstants.locationLabel,
                      value: StringConstants.locationValue,
                    ),
                    const SizedBox(height: 16),
                    const InfoRow(
                      icon: Icons.calendar_today_outlined,
                      title: StringConstants.dateLabel,
                      value: StringConstants.dateValue,
                    ),
                    const SizedBox(height: 16),
                    const InfoRow(
                      icon: Icons.camera_alt_outlined,
                      title: StringConstants.photographerLabel,
                      value: StringConstants.photographerValue,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      StringConstants.photoDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
