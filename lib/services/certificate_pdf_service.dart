import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/certificate_model.dart';

class CertificatePdfService {
  /// Generates a vector PDF representing the prestigious PyPocket certificate
  static Future<Uint8List> buildPdf(Certificate certificate) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('MMMM yyyy');
    final formattedDate = dateFormat.format(certificate.issueDate);

    // Color definitions
    const navyPrimary = PdfColor.fromInt(0xFF0F1E36);
    const slateMuted = PdfColor.fromInt(0xFF5A6A85);
    const slateLight = PdfColor.fromInt(0xFF7E8BA0);
    const textDark = PdfColor.fromInt(0xFF2D3748);
    const greenVerified = PdfColor.fromInt(0xFF10B981);
    const borderGray = PdfColor.fromInt(0xFFE2E8F0);

    // 1. Load Images
    pw.MemoryImage? appLogoImage;
    pw.MemoryImage? signatureImage;
    pw.MemoryImage? sealImage;
    pw.MemoryImage? qrImage;

    try {
      final b = await rootBundle.load('assets/images/app_logo.png');
      appLogoImage = pw.MemoryImage(b.buffer.asUint8List());
    } catch (_) {}

    try {
      final b = await rootBundle.load('assets/images/founder_signature.png');
      signatureImage = pw.MemoryImage(b.buffer.asUint8List());
    } catch (_) {}

    try {
      final b = await rootBundle.load('assets/images/pypocket_seal.png');
      sealImage = pw.MemoryImage(b.buffer.asUint8List());
    } catch (_) {}

    try {
      final b = await rootBundle.load('assets/images/certificate_qr.png');
      qrImage = pw.MemoryImage(b.buffer.asUint8List());
    } catch (_) {}

    // 2. Load Fonts
    pw.Font? cinzelFont;
    pw.Font? playfairFont;
    pw.Font? interRegular;
    pw.Font? interBold;

    try {
      final f = await rootBundle.load('assets/fonts/Cinzel-Bold.ttf');
      cinzelFont = pw.Font.ttf(f);
    } catch (_) {
      cinzelFont = pw.Font.helveticaBold();
    }

    try {
      final f = await rootBundle.load('assets/fonts/PlayfairDisplay-Bold.ttf');
      playfairFont = pw.Font.ttf(f);
    } catch (_) {
      playfairFont = pw.Font.timesBold();
    }

    try {
      final f = await rootBundle.load('assets/fonts/Inter-Regular.ttf');
      interRegular = pw.Font.ttf(f);
    } catch (_) {
      interRegular = pw.Font.helvetica();
    }

    try {
      final f = await rootBundle.load('assets/fonts/Inter-Bold.ttf');
      interBold = pw.Font.ttf(f);
    } catch (_) {
      interBold = pw.Font.helveticaBold();
    }

    final themeData = pw.ThemeData.withFont(
      base: interRegular,
      bold: interBold,
      italic: interRegular,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(18),
        theme: themeData,
        build: (pw.Context context) {
          return pw.Container(
            width: double.infinity,
            height: double.infinity,
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              border: pw.Border.all(color: navyPrimary, width: 2.5),
            ),
            padding: const pw.EdgeInsets.all(5),
            child: pw.Container(
              width: double.infinity,
              height: double.infinity,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: navyPrimary, width: 1.0),
              ),
              child: pw.Stack(
                fit: pw.StackFit.expand,
                children: [
                  // Corner Percent Ornaments
                  pw.Positioned(top: 2, left: 2, child: _buildCornerOrnament(navyPrimary, 1, 1)),
                  pw.Positioned(top: 2, right: 2, child: _buildCornerOrnament(navyPrimary, -1, 1)),
                  pw.Positioned(bottom: 2, left: 2, child: _buildCornerOrnament(navyPrimary, 1, -1)),
                  pw.Positioned(bottom: 2, right: 2, child: _buildCornerOrnament(navyPrimary, -1, -1)),

                  // Center Faint Watermark
                  pw.Center(
                    child: pw.Opacity(
                      opacity: 0.04,
                      child: pw.Text(
                        'PyPocket',
                        style: pw.TextStyle(
                          color: navyPrimary,
                          font: cinzelFont,
                          fontSize: 64,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Main Content Column
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        // 1. TOP ROW: Institution Logo & Credential UID
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            // Top-Left: Logo & Academy
                            pw.Row(
                              children: [
                                if (appLogoImage != null)
                                  pw.Container(
                                    width: 34,
                                    height: 34,
                                    margin: const pw.EdgeInsets.only(right: 8),
                                    decoration: pw.BoxDecoration(
                                      borderRadius: pw.BorderRadius.circular(8),
                                      border: pw.Border.all(color: borderGray),
                                    ),
                                    child: pw.Image(appLogoImage),
                                  ),
                                pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'PYPOCKET',
                                      style: pw.TextStyle(
                                        color: navyPrimary,
                                        fontSize: 12,
                                        fontWeight: pw.FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    pw.Text(
                                      'PYTHON ENGINEERING ACADEMY · BALOTRA',
                                      style: pw.TextStyle(
                                        color: slateMuted,
                                        fontSize: 6.5,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Top-Right: Credential UID
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text(
                                  'CREDENTIAL UID:',
                                  style: pw.TextStyle(
                                    color: slateLight,
                                    fontSize: 5.5,
                                  ),
                                ),
                                pw.Text(
                                  certificate.id,
                                  style: pw.TextStyle(
                                    color: navyPrimary,
                                    fontSize: 8,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  'STUDENT ID: STU877956',
                                  style: pw.TextStyle(
                                    color: slateLight,
                                    fontSize: 5.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // 2. DIPLOMA HEADLINE & HONORS
                        pw.Column(
                          children: [
                            pw.Text(
                              'OFFICIAL RECOGNITION OF ACADEMIC EXCELLENCE',
                              style: pw.TextStyle(
                                color: slateMuted,
                                fontSize: 7,
                                letterSpacing: 1.5,
                              ),
                            ),
                            pw.SizedBox(height: 3),
                            pw.Text(
                              'CERTIFICATE OF COMPLETION',
                              style: pw.TextStyle(
                                color: navyPrimary,
                                font: cinzelFont,
                                fontSize: 24,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 1.4,
                              ),
                            ),
                            pw.SizedBox(height: 4),

                            // Honors Pill
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 2.5),
                              decoration: pw.BoxDecoration(
                                borderRadius: pw.BorderRadius.circular(14),
                                border: pw.Border.all(color: navyPrimary, width: 1.2),
                              ),
                              child: pw.Text(
                                '★  HONORS WITH DISTINCTION  ★',
                                style: pw.TextStyle(
                                  color: navyPrimary,
                                  fontSize: 7,
                                  fontWeight: pw.FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            pw.SizedBox(height: 5),

                            pw.Text(
                              'THIS CERTIFIES THAT',
                              style: pw.TextStyle(
                                color: slateMuted,
                                fontSize: 9,
                                fontStyle: pw.FontStyle.italic,
                                letterSpacing: 1.5,
                              ),
                            ),
                            pw.SizedBox(height: 2),

                            // Recipient Name
                            pw.Text(
                              certificate.userName.toUpperCase(),
                              style: pw.TextStyle(
                                color: navyPrimary,
                                font: playfairFont,
                                fontSize: 28,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 1.8,
                              ),
                            ),
                          ],
                        ),

                        // 3. CURRICULUM DESCRIPTION & COURSE
                        pw.Column(
                          children: [
                            pw.Text(
                              'has demonstrated technical proficiency, creative excellence, and dedication in successfully completing the practical\nrequirements of the advanced professional curriculum on',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                color: textDark,
                                fontSize: 7,
                                lineSpacing: 1.3,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              certificate.title.toUpperCase(),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                color: navyPrimary,
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              '"Demonstrated technical proficiency, creative excellence, and dedication in successfully completing the practical requirements of the curriculum."',
                              style: pw.TextStyle(
                                color: slateMuted,
                                fontSize: 6.5,
                                fontStyle: pw.FontStyle.italic,
                              ),
                            ),
                            pw.SizedBox(height: 5),

                            // 4 Skill Badges
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                _buildPdfPill('✓ Core Python 3 & OOP', navyPrimary, borderGray),
                                pw.SizedBox(width: 8),
                                _buildPdfPill('✓ Data Structures & Algorithms', navyPrimary, borderGray),
                                pw.SizedBox(width: 8),
                                _buildPdfPill('✓ AsyncIO & High-Scale APIs', navyPrimary, borderGray),
                                pw.SizedBox(width: 8),
                                _buildPdfPill('✓ Cloud Deployment & Docker', navyPrimary, borderGray),
                              ],
                            ),
                          ],
                        ),

                        // 4. BOTTOM ANCHORS
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            // Left: Signature
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                if (signatureImage != null)
                                  pw.Container(
                                    width: 85,
                                    height: 32,
                                    child: pw.Image(signatureImage),
                                  ),
                                pw.Container(
                                  width: 100,
                                  height: 1.0,
                                  margin: const pw.EdgeInsets.only(top: 2, bottom: 2),
                                  color: const PdfColor.fromInt(0xFFCBD5E1),
                                ),
                                pw.Text(
                                  'Piyush Assudani',
                                  style: pw.TextStyle(
                                    color: navyPrimary,
                                    fontSize: 8.5,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  'FOUNDER & LEAD INSTRUCTOR',
                                  style: pw.TextStyle(
                                    color: slateMuted,
                                    fontSize: 5.5,
                                  ),
                                ),
                              ],
                            ),

                            // Center: PyPocket Stamped Seal
                            if (sealImage != null)
                              pw.Container(
                                width: 55,
                                height: 55,
                                child: pw.Image(sealImage),
                              ),

                            // Right: Official Verification Card
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Container(
                                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  decoration: pw.BoxDecoration(
                                    borderRadius: pw.BorderRadius.circular(6),
                                    border: pw.Border.all(color: borderGray),
                                    color: PdfColors.white,
                                  ),
                                  child: pw.Row(
                                    mainAxisSize: pw.MainAxisSize.min,
                                    children: [
                                      if (qrImage != null)
                                        pw.Container(
                                          width: 28,
                                          height: 28,
                                          margin: const pw.EdgeInsets.only(right: 6),
                                          child: pw.Image(qrImage),
                                        ),
                                      pw.Column(
                                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text(
                                            'SECURE VERIFY',
                                            style: pw.TextStyle(
                                              color: navyPrimary,
                                              fontSize: 6,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                          pw.Text(
                                            'Date: $formattedDate',
                                            style: pw.TextStyle(
                                              color: slateMuted,
                                              fontSize: 5,
                                            ),
                                          ),
                                          pw.Row(
                                            children: [
                                              pw.Container(
                                                width: 3.5,
                                                height: 3.5,
                                                margin: const pw.EdgeInsets.only(right: 2.5),
                                                decoration: pw.BoxDecoration(
                                                  color: greenVerified,
                                                  shape: pw.BoxShape.circle,
                                                ),
                                              ),
                                              pw.Text(
                                                'Status: VERIFIED',
                                                style: pw.TextStyle(
                                                  color: greenVerified,
                                                  fontSize: 5,
                                                  fontWeight: pw.FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                pw.SizedBox(height: 2),
                                pw.Text(
                                  'BALOTRA, RAJASTHAN · INDIA',
                                  style: pw.TextStyle(
                                    color: slateMuted,
                                    fontSize: 5,
                                    letterSpacing: 0.5,
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
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildPdfPill(String title, PdfColor navy, PdfColor borderGray) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFF8FAFC),
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: borderGray, width: 0.8),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          color: navy,
          fontSize: 6,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _buildCornerOrnament(PdfColor color, double dx, double dy) {
    return pw.CustomPaint(
      size: const PdfPoint(16, 16),
      painter: (PdfGraphics canvas, PdfPoint size) {
        final startX = dx > 0 ? 0.0 : size.x;
        final startY = dy > 0 ? 0.0 : size.y;

        canvas.setColor(color);
        canvas.setLineWidth(1.4);
        canvas.drawLine(startX + dx * size.x, startY, startX, startY + dy * size.y);
        canvas.strokePath();

        canvas.drawEllipse(startX + dx * size.x * 0.35, startY + dy * size.y * 0.35, 1.5, 1.5);
        canvas.fillPath();

        canvas.drawEllipse(startX + dx * size.x * 0.85, startY + dy * size.y * 0.85, 1.5, 1.5);
        canvas.fillPath();
      },
    );
  }

  /// Downloads and shares the PDF certificate or saves directly to storage
  static Future<File?> downloadCertificatePdf(BuildContext context, Certificate certificate) async {
    try {
      final pdfBytes = await buildPdf(certificate);
      final sanitizedName = certificate.userName.trim().replaceAll(RegExp(r'\s+'), '_');
      final fileName = 'PyPocket_Certificate_$sanitizedName.pdf';

      Directory? saveDir;
      try {
        saveDir = await getDownloadsDirectory();
      } catch (_) {}
      saveDir ??= await getApplicationDocumentsDirectory();

      final file = File('${saveDir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);

      // Trigger standard system Print / Share modal
      await Printing.sharePdf(bytes: pdfBytes, filename: fileName);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Certificate downloaded successfully: $fileName'),
            backgroundColor: const Color(0xFF10B981),
            duration: const Duration(seconds: 4),
          ),
        );
      }
      return file;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download PDF: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
      return null;
    }
  }
}
