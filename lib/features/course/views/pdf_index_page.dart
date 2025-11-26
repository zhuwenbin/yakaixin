import 'package:flutter/material.dart';

/// P4-7 PDF查看 - PDF预览
class PdfIndexPage extends StatelessWidget {
  final String? pdfUrl;
  
  const PdfIndexPage({super.key, this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF查看')),
      body: const Center(child: Text('PDF查看页面')),
    );
  }
}
