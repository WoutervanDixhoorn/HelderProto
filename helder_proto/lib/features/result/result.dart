import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:helder_proto/providers/navigation_provider.dart';
import 'package:helder_proto/providers/scanner_provider.dart';
import 'package:provider/provider.dart';

import 'package:helder_proto/features/result/scanresult_screen.dart';
import 'package:helder_proto/common/widgets/info_card.dart';
import 'package:helder_proto/models/helder_invoice.dart';
import 'package:helder_proto/providers/verhelder_provider.dart';

class ResultScreen extends StatefulWidget {
  final XFile pictureFile;

  const ResultScreen({
    super.key, 
    required this.pictureFile
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  

  @override
  void initState() {
    final scannerProvider = Provider.of<ScannerProvider>(context, listen: false);
    scannerProvider.scanImage(context, widget.pictureFile);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scannerProvider = Provider.of<ScannerProvider>(context, listen: false);
    final verhelderProvider = Provider.of<VerhelderProvider>(context);
    final navigationProvider = Provider.of<NavigationProvider>(context);

    bool areLoading = scannerProvider.isLoading | verhelderProvider.isLoading;
    String error = handleError(scannerProvider.error, verhelderProvider.error);

    //TODO: Handle this properly with a correct page
    if (verhelderProvider.isDuplicate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigationProvider.resetProviders(context);
        navigationProvider.setAccountsScreen(false); 
      });
    }

    return areLoading
      ? getLoadingUI() 
      : error.isNotEmpty 
        ? getErrorUI(error) 
        : getBodyUI(verhelderProvider.helderData);
  }

  getLoadingUI() {
    return const Center(
      child: CircularProgressIndicator()
    );
  }

  getErrorUI(String error) {
    return Center(
      child: InfoCard(
        text: error,
      ),
    );
  }

  getBodyUI(HelderInvoice data) {
    return ScanResultScreen(invoice: data);
  }

  String handleError(String scannerError, String verhelderError) {
    return [scannerError, verhelderError]
        .where((e) => e.isNotEmpty)
        .join('\n');
  }
  
}