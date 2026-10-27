import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:pypocket_app/models/certificate_model.dart';
import 'package:pypocket_app/services/certificate_pdf_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Generates official verified PDF certificate for Founder Piyush Assudani', () async {
    final certificate = Certificate(
      id: 'CZL-2026-CERT-7956',
      userName: 'Piyush Assudani',
      title: 'Python 3 Full-Stack & System Architecture',
      track: 'advanced_python_engineering',
      score: 98.5,
      grade: 'Distinction (Honors)',
      issueDate: DateTime(2026, 10, 22),
      verificationHash: '877956A9F21B4C',
    );

    // Generate vector PDF bytes using CertificatePdfService
    final pdfBytes = await CertificatePdfService.buildPdf(certificate);

    expect(pdfBytes, isNotNull);
    expect(pdfBytes.length, greaterThan(1000));

    // Save sample PDF to store_assets for user review
    final outputDir = Directory('store_assets');
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    final pdfFile = File('store_assets/PyPocket_Certificate_Piyush_Assudani.pdf');
    await pdfFile.writeAsBytes(pdfBytes);

    expect(pdfFile.existsSync(), isTrue);
  });
}
