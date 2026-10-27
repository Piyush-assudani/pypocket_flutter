import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/certificate_model.dart';

class CertificateView extends StatelessWidget {
  final Certificate certificate;
  final bool isInteractive;

  const CertificateView({
    super.key,
    required this.certificate,
    this.isInteractive = true,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMMM yyyy');
    final formattedDate = dateFormat.format(certificate.issueDate);

    // Deep rich navy & slate palette matching official reference certificate
    const navyPrimary = Color(0xFF0F1E36);
    const slateMuted = Color(0xFF5A6A85);
    const slateLight = Color(0xFF7E8BA0);
    const textDark = Color(0xFF2D3748);
    const greenVerified = Color(0xFF10B981);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 560;
        final scale = isCompact ? (constraints.maxWidth / 620).clamp(0.65, 1.0) : 1.0;

        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 780),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: navyPrimary.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AspectRatio(
              aspectRatio: 1.414, // Exact A4 landscape ratio
              child: Container(
                padding: EdgeInsets.all(isCompact ? 8 * scale : 12),
                decoration: BoxDecoration(
                  border: Border.all(color: navyPrimary, width: 2.5),
                ),
                child: Container(
                  padding: EdgeInsets.all(isCompact ? 4 * scale : 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: navyPrimary, width: 1.0),
                  ),
                  child: Stack(
                    children: [
                      // 4 Corner Percent-Style Ornaments
                      Positioned(
                        top: 2,
                        left: 2,
                        child: _buildCornerOrnament(scale, navyPrimary, 1, 1),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: _buildCornerOrnament(scale, navyPrimary, -1, 1),
                      ),
                      Positioned(
                        bottom: 2,
                        left: 2,
                        child: _buildCornerOrnament(scale, navyPrimary, 1, -1),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: _buildCornerOrnament(scale, navyPrimary, -1, -1),
                      ),

                      // Center Faint Watermark
                      Center(
                        child: Opacity(
                          opacity: 0.035,
                          child: Text(
                            'PyPocket',
                            style: GoogleFonts.cinzel(
                              fontSize: 55 * scale,
                              fontWeight: FontWeight.w900,
                              color: navyPrimary,
                            ),
                          ),
                        ),
                      ),

                      // Main Certificate Body Layout
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 12 * scale : 18,
                          vertical: isCompact ? 8 * scale : 12,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 1. TOP ROW: Institution Logo & Credential UID
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top-Left: Logo & Academy Name
                                Row(
                                  children: [
                                    Container(
                                      width: 32 * scale,
                                      height: 32 * scale,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8 * scale),
                                        border: Border.all(color: const Color(0xFFE2E8F0)),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        'assets/images/app_logo.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(width: 8 * scale),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'PYPOCKET',
                                          style: GoogleFonts.inter(
                                            fontSize: 12 * scale,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.5,
                                            color: navyPrimary,
                                          ),
                                        ),
                                        Text(
                                          'PYTHON ENGINEERING ACADEMY · BALOTRA',
                                          style: GoogleFonts.inter(
                                            fontSize: 6 * scale,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.8,
                                            color: slateMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Top-Right: Credential UID
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'CREDENTIAL UID:',
                                      style: GoogleFonts.inter(
                                        fontSize: 5.5 * scale,
                                        fontWeight: FontWeight.w600,
                                        color: slateLight,
                                      ),
                                    ),
                                    Text(
                                      certificate.id,
                                      style: GoogleFonts.inter(
                                        fontSize: 7.5 * scale,
                                        fontWeight: FontWeight.w800,
                                        color: navyPrimary,
                                      ),
                                    ),
                                    Text(
                                      'STUDENT ID: STU877956',
                                      style: GoogleFonts.inter(
                                        fontSize: 5.5 * scale,
                                        fontWeight: FontWeight.w600,
                                        color: slateLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // 2. MIDDLE SECTION: Certificate Headline & Honors
                            Column(
                              children: [
                                Text(
                                  'OFFICIAL RECOGNITION OF ACADEMIC EXCELLENCE',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 6.8 * scale,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.4,
                                    color: slateMuted,
                                  ),
                                ),
                                SizedBox(height: 2 * scale),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'CERTIFICATE OF COMPLETION',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.cinzel(
                                      fontSize: 18 * scale,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                      color: navyPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3 * scale),

                                // Honors Pill
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14 * scale,
                                    vertical: 2 * scale,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: navyPrimary, width: 1.2),
                                  ),
                                  child: Text(
                                    '★  HONORS WITH DISTINCTION  ★',
                                    style: GoogleFonts.inter(
                                      fontSize: 6.5 * scale,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                      color: navyPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4 * scale),

                                Text(
                                  'THIS CERTIFIES THAT',
                                  style: GoogleFonts.cormorantGaramond(
                                    fontSize: 9.5 * scale,
                                    fontStyle: FontStyle.italic,
                                    letterSpacing: 1.5,
                                    color: slateMuted,
                                  ),
                                ),
                                SizedBox(height: 1 * scale),

                                // Recipient Name
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    certificate.userName.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 22 * scale,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                      color: navyPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // 3. CURRICULUM DESCRIPTION & COURSE
                            Column(
                              children: [
                                Text(
                                  'has demonstrated technical proficiency, creative excellence, and dedication in successfully completing the practical\nrequirements of the advanced professional curriculum on',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 6.2 * scale,
                                    height: 1.3,
                                    color: textDark,
                                  ),
                                ),
                                SizedBox(height: 3 * scale),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    certificate.title.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 10 * scale,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                      color: navyPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2 * scale),
                                Text(
                                  '"Demonstrated technical proficiency, creative excellence, and dedication in successfully completing the practical requirements of the curriculum."',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 5.5 * scale,
                                    fontStyle: FontStyle.italic,
                                    color: slateMuted,
                                  ),
                                ),
                                SizedBox(height: 4 * scale),

                                // 4 Skill Badges
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 6 * scale,
                                  runSpacing: 3 * scale,
                                  children: [
                                    _buildPill('✓ Core Python 3 & OOP', scale, navyPrimary),
                                    _buildPill('✓ Data Structures & Algorithms', scale, navyPrimary),
                                    _buildPill('✓ AsyncIO & High-Scale APIs', scale, navyPrimary),
                                    _buildPill('✓ Cloud Deployment & Docker', scale, navyPrimary),
                                  ],
                                ),
                              ],
                            ),

                            // 4. BOTTOM ANCHORS: Signature, PyPocket Stamp, Verification Card
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Left: Founder Signature
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 75 * scale,
                                      height: 28 * scale,
                                      child: Image.asset(
                                        'assets/images/founder_signature.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Container(
                                      width: 95 * scale,
                                      height: 1.0,
                                      margin: EdgeInsets.only(top: 2 * scale, bottom: 2 * scale),
                                      color: const Color(0xFFCBD5E1),
                                    ),
                                    Text(
                                      'Piyush Assudani',
                                      style: GoogleFonts.inter(
                                        fontSize: 7.5 * scale,
                                        fontWeight: FontWeight.w800,
                                        color: navyPrimary,
                                      ),
                                    ),
                                    Text(
                                      'FOUNDER & LEAD INSTRUCTOR',
                                      style: GoogleFonts.inter(
                                        fontSize: 5 * scale,
                                        fontWeight: FontWeight.w700,
                                        color: slateMuted,
                                      ),
                                    ),
                                  ],
                                ),

                                // Center: PyPocket Stamped Seal
                                SizedBox(
                                  width: 48 * scale,
                                  height: 48 * scale,
                                  child: Image.asset(
                                    'assets/images/pypocket_seal.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),

                                // Right: Verification Box
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6 * scale,
                                        vertical: 4 * scale,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6 * scale),
                                        border: Border.all(color: const Color(0xFFE2E8F0)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 24 * scale,
                                            height: 24 * scale,
                                            child: Image.asset(
                                              'assets/images/certificate_qr.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          SizedBox(width: 5 * scale),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'SECURE VERIFY',
                                                style: GoogleFonts.inter(
                                                  fontSize: 5 * scale,
                                                  fontWeight: FontWeight.w800,
                                                  color: navyPrimary,
                                                ),
                                              ),
                                              Text(
                                                'Date: $formattedDate',
                                                style: GoogleFonts.inter(
                                                  fontSize: 4.5 * scale,
                                                  color: slateMuted,
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 3 * scale,
                                                    height: 3 * scale,
                                                    decoration: const BoxDecoration(
                                                      color: greenVerified,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  SizedBox(width: 2 * scale),
                                                  Text(
                                                    'Status: VERIFIED',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 4.5 * scale,
                                                      fontWeight: FontWeight.w700,
                                                      color: greenVerified,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 2 * scale),
                                    Text(
                                      'BALOTRA, RAJASTHAN · INDIA',
                                      style: GoogleFonts.inter(
                                        fontSize: 4.5 * scale,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                        color: slateMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
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
    );
  }

  Widget _buildPill(String title, double scale, Color navy) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6 * scale, vertical: 2 * scale),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 0.8),
      ),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 5.5 * scale,
          fontWeight: FontWeight.w700,
          color: navy,
        ),
      ),
    );
  }

  Widget _buildCornerOrnament(double scale, Color color, double dx, double dy) {
    return SizedBox(
      width: 16 * scale,
      height: 16 * scale,
      child: CustomPaint(
        painter: CornerSlashDotPainter(color: color, dx: dx, dy: dy),
      ),
    );
  }
}

/// Paints the diagonal slash with two dots matching reference
class CornerSlashDotPainter extends CustomPainter {
  final Color color;
  final double dx;
  final double dy;

  CornerSlashDotPainter({
    required this.color,
    required this.dx,
    required this.dy,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final startX = dx > 0 ? 0.0 : size.width;
    final startY = dy > 0 ? 0.0 : size.height;

    // Diagonal line
    canvas.drawLine(
      Offset(startX + dx * size.width, startY),
      Offset(startX, startY + dy * size.height),
      paint,
    );

    // Inner dot
    canvas.drawCircle(
      Offset(startX + dx * size.width * 0.35, startY + dy * size.height * 0.35),
      1.5,
      dotPaint,
    );

    // Outer dot
    canvas.drawCircle(
      Offset(startX + dx * size.width * 0.85, startY + dy * size.height * 0.85),
      1.5,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
