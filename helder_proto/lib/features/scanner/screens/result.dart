import 'package:flutter/material.dart';
import 'package:helder_proto/features/scanner/controllers/api_controller.dart';
import 'package:helder_proto/features/templates/header_page.dart';

class ResultScreen extends StatefulWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

  @override
  State<ResultScreen> createState() => _ResultState();
}

class _ResultState extends State<ResultScreen> {
  String? _processedText; // To store the processed text
  bool _isLoading = true; // To keep track of loading state

  @override
  void initState() {
    _fetchProcessedText();
    super.initState();
  }

  Future<void> _fetchProcessedText() async {
    String processedText = await ApiController.processLetter(widget.text);
    setState(() {
      _processedText = processedText;
      _isLoading = false; // Loading is done
    });
  }

  @override
  Widget build(BuildContext context) {
    return HeaderPageNav(
      currentIndex: 1,
        child: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator while loading
          : SingleChildScrollView(child: Text(_processedText ?? ''))
    );
  }
}