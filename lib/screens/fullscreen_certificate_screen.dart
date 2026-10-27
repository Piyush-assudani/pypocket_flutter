import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/certificate_model.dart';
import '../services/certificate_pdf_service.dart';
import '../widgets/certificate_view.dart';

class FullScreenCertificateScreen extends StatelessWidget {
  final Certificate certificate;

  const FullScreenCertificateScreen({
    super.key,
    required this.certificate,
  });

  Future<void> _shareCertificate(BuildContext context) async {
    final text = '''PyPocket Verified Engineering Certificate
Awarded to: ${certificate.userName}
Title: ${certificate.title}
Grade: ${certificate.grade} (${certificate.score.toInt()}%)
Certificate ID: ${certificate.id}
Security Hash: ${certificate.verificationHash}
Issuing Authority: PyPocket Global Academy • Piyush Assudani, Founder Assudani Group
Verification Portal: https://assudanigroup.online''';

    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Certificate credential & verification details copied to clipboard!'),
          backgroundColor: Color(0xFF10B981),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _openVerificationSite(BuildContext context) async {
    final uri = Uri.parse('https://assudanigroup.online');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: 'https://assudanigroup.online'));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Portal link copied: https://assudanigroup.online')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgCanvas = isDark ? const Color(0xFF07090E) : const Color(0xFFF1F5F9);
    final barBg = isDark ? const Color(0xFF0F131C) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final buttonContainerBg = isDark ? const Color(0xFF161B24) : const Color(0xFFE2E8F0);
    final buttonBorder = isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFCBD5E1);

    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgCanvas,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: buttonContainerBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: buttonBorder),
              ),
              child: Icon(
                Icons.close_rounded,
                size: 20,
                color: textPrimary,
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Official Verified Credential',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            Text(
              'Pinch to zoom • Official Issuance Record',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Download PDF',
            icon: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFC89B58), size: 22),
            onPressed: () => CertificatePdfService.downloadCertificatePdf(context, certificate),
          ),
          IconButton(
            tooltip: 'Share Certificate',
            icon: const Icon(Icons.share_rounded, color: Color(0xFFC89B58), size: 20),
            onPressed: () => _shareCertificate(context),
          ),
          IconButton(
            tooltip: 'Copy ID',
            icon: Icon(Icons.copy_rounded, color: textSecondary, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: certificate.id));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Certificate ID copied to clipboard!')),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Interactive Zoomable Certificate Container
            Expanded(
              child: InteractiveViewer(
                minScale: 0.85,
                maxScale: 3.0,
                boundaryMargin: const EdgeInsets.all(24),
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: CertificateView(
                        certificate: certificate,
                        isInteractive: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Luxury Action Floating Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: barBg,
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Prominent Download PDF Button
                  Expanded(
                    flex: 5,
                    child: ElevatedButton.icon(
                      onPressed: () => CertificatePdfService.downloadCertificatePdf(context, certificate),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F1E36),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: Color(0xFFC89B58), width: 1.2),
                        ),
                      ),
                      icon: const Icon(Icons.download_rounded, size: 19, color: Color(0xFFC89B58)),
                      label: Text(
                        'Download PDF',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Share Button
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _shareCertificate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1B2230) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.share_rounded, size: 16, color: isDark ? Colors.white70 : const Color(0xFF334155)),
                          const SizedBox(width: 5),
                          Text(
                            'Share',
                            style: GoogleFonts.outfit(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F1E36),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Verify Portal Link Button
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _openVerificationSite(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1B2230) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_user_rounded, size: 16, color: Color(0xFF1D4ED8)),
                          const SizedBox(width: 5),
                          Text(
                            'Verify',
                            style: GoogleFonts.outfit(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F1E36),
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
}
