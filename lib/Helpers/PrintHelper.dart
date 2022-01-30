import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintHelper {
  static Future<Uint8List> generatePdf(
      PdfPageFormat format, String content, String name) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  // child: pw.Text(title, style: pw.TextStyle(font: font)),
                  // child: pw.Text(
                  //   pw.Barcode.qrCode().toSvg(
                  //     content,
                  //     width: 40,
                  //     height: 40,
                  //   ),
                  // ),
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: content,
                    width: 10,
                    height: 10,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Flexible(
                child: pw.Text(
                  name,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 30,
                  ),
                ),
              ),
              pw.Flexible(
                child: pw.Text(
                  "Dellrain's Store Borrower",
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 10,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}