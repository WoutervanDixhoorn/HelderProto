import 'package:flutter/material.dart';

import 'package:helder_proto/data/services/database_service.dart';
import 'package:helder_proto/models/helder_invoice_data.dart';
import 'package:helder_proto/models/helder_allowance_data.dart';
import 'package:helder_proto/models/helder_renderable_data.dart';
import 'package:helder_proto/models/helder_tax_data.dart';

class AccountsList extends StatelessWidget {
  final bool payedAccounts;

  const AccountsList({
    super.key,

    this.payedAccounts = false
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPaymentCards(), 
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return snapshot.data!.elementAt(index);
                  },
                );
        } else {
          return const Center(child: Text('No data available'));
        }

      },
    );
  }

  Future<List<Widget>> getPaymentCards() async {
    DatabaseService databaseService = DatabaseService.instance;
    
    List<Widget> paymentCards = [
      const SizedBox(height: 94,),
    ];

    List<HelderInvoice> invoices = await databaseService.getInvoices();
    List<HelderAllowance> allowances = await databaseService.getAllowances();
    List<HelderTax> taxes = await databaseService.getTaxes();
    
    List<HelderRenderableData> allData = [...invoices,...allowances,...taxes];

    for (var data in allData) {
      
      if (data.isRecievingMoney()) {
        if (!payedAccounts) continue;
      }

      if ((data is HelderInvoice && data.isPayed != payedAccounts) ||
          (data is HelderTax && data.isPayed != payedAccounts)) {
        continue;
      }

      paymentCards.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: data.toPaymentCard(),
        ),
      );
    } 	

    return paymentCards;
  }

}