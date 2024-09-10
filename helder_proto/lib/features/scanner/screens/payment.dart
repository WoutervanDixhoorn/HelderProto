import 'package:flutter/material.dart';
import 'package:helder_proto/models/helder_invoice.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.invoiceData});

  final HelderInvoice invoiceData;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  @override
  Widget build(BuildContext context) {
  
    return const Center(
      child: Text('Betaalscherm'),
    );
    
  }
}