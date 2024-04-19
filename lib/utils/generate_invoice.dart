import 'dart:typed_data';
import 'dart:convert';
import 'dart:html' as html;

import 'package:pdf/widgets.dart' as pw;

Future<String> generateInvoicePDF(
    {String? customerName,
    List<Map<String, dynamic>>? cartItems,
    double? total,
    String? paymentMethod,
    String? address,
    String? orderID}) async {
  customerName ??= '';
  cartItems ??= [];
  total ??= 0;
  paymentMethod ??= '';
  address ??= '';

  // Create a new PDF document
  final pdf = pw.Document();

  // Add page to the PDF
  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Foodies Heaven',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.Text('Invoice',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('Order #$orderID',
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),

            pw.SizedBox(height: 15),
            // Customer Info
            pw.Text('Customer Name: $customerName'),
            pw.Text('Address: $address'),
            pw.SizedBox(height: 10),

            // Invoice Items
            pw.Text('Items:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: cartItems!.map((item) {
                return pw.Text('- ${item['name']}: ${item['price']}');
              }).toList(),
            ),
            pw.SizedBox(height: 10),

            // Total
            pw.Text('Total: \$ $total',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),

            // Payment Method
            pw.Text('Payment Method: $paymentMethod'),
          ],
        );
      },
    ),
  );

  // Save the PDF as bytes
  final Uint8List pdfBytes = await pdf.save();

  // Convert PDF bytes to base64 string
  final String base64PDF = base64Encode(pdfBytes);

  // Convert PDF bytes to Blob
  final blob = html.Blob([pdfBytes]);

  // Create download link
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "invoice.pdf")
    ..click();

  // Cleanup
  html.Url.revokeObjectUrl(url);

  // Return base64 string
  return base64PDF;
}
