import 'package:equran_app/core/theme/app_dimens.dart';
import 'package:equran_app/core/theme/app_typography.dart';
import 'package:equran_app/features/surat_detail/domain/entities/surat_detail.dart';
import 'package:equran_app/features/surat_detail/presentation/theme/share_templates_theme.dart';
import 'package:flutter/material.dart';

/// Widget yang di-render menjadi gambar untuk dibagikan.
/// Dibungkus [RepaintBoundary] oleh parent (ShareAyatSheet).
class AyatShareCard extends StatelessWidget {
  const AyatShareCard({
    required this.ayat,
    required this.namaLatin,
    required this.suratNomor,
    this.style = ShareTemplateStyle.classicEmerald,
    super.key,
  });

  final Ayat ayat;
  final String namaLatin;
  final int suratNomor;
  final ShareTemplateStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: style.backgroundColors,
          stops: style.stops,
        ),
        boxShadow: [
          BoxShadow(
            color: style.shadowColor,
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        child: Stack(
          children: [
            // Ornamen circle besar kanan atas
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: style.bigCircleColor,
                ),
              ),
            ),
            // Ornamen circle kecil kanan atas
            Positioned(
              right: 20,
              top: -30,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: style.smallCircleColor,
                ),
              ),
            ),
            // Ornamen circle kiri bawah
            Positioned(
              left: -30,
              bottom: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: style.bottomCircleColor,
                ),
              ),
            ),

            // Luminous border top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: style.topBorderColors,
                  ),
                ),
              ),
            ),

            // Luminous border bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      style.bottomBorderColor,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, AppDimens.spaceLG),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header — app branding
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nomor ayat badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: style.badgeBgColor,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: style.badgeBorderColor,
                          ),
                        ),
                        child: Text(
                          'Ayat ${ayat.nomorAyat}',
                          style: TextStyle(
                            color: style.badgeTextColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      // App name
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            color: style.brandingIconColor,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'eQuran',
                            style: AppTypography.serifHeadingSmall.copyWith(
                              color: style.brandingTextColor,
                              fontSize: 13,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimens.spaceLG),

                  // Teks Arab
                  Text(
                    ayat.teksArab,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 30,
                      color: style.arabicTextColor,
                      height: 2.2,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Divider ornamental
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                style.dividerLineColors[1],
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: style.dividerCircleColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                style.dividerLineColors[1],
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Teks terjemahan
                  Text(
                    '"${ayat.teksIndonesia}"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: style.translationTextColor,
                      height: 1.75,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sumber — pill style
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: style.sourceBgColor,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: style.sourceBorderColor,
                        ),
                      ),
                      child: Text(
                        'Q.S. $namaLatin ($suratNomor) : ${ayat.nomorAyat}',
                        style: TextStyle(
                          fontSize: 11,
                          color: style.sourceTextColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
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
}
