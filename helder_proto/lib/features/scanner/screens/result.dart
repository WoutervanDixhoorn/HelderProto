import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:helder_proto/features/result/scanresult_screen.dart';
import 'package:helder_proto/navigation_menu.dart';
import 'package:helder_proto/common/widgets/info_card.dart';
import 'package:helder_proto/models/helder_invoice.dart';
import 'package:helder_proto/providers/verhelder_provider.dart';

class ResultScreen extends StatefulWidget {
  final String letterContent;

  const ResultScreen({
    super.key, 
    this.letterContent = ''
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  @override
  void initState() {
    final provider = Provider.of<VerhelderProvider>(context, listen: false);
    if(widget.letterContent.isNotEmpty){
      provider.processLetterWithProxy(widget.letterContent);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VerhelderProvider>(context);
    return provider.isLoading 
      ? getLoadingUI() 
      : provider.error.isNotEmpty 
        ? getErrorUI(provider.error) 
        : getBodyUI(provider.helderData);
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

  void nextStep(BuildContext context) {
    final verhelderProvider = Provider.of<VerhelderProvider>(context, listen: false);
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    navigationProvider.setPaymentScreen(verhelderProvider.helderData);
  }

}