import 'package:helder_proto/data/services/database_service.dart';
import 'package:helder_proto/models/helder_invoice.dart';
import 'package:helder_proto/providers/navigation_provider.dart';

class PaymentController {
  final DatabaseService databaseService = DatabaseService.instance;

  final HelderInvoice invoice;

  PaymentController({
    required this.invoice
  });

  void onPayNow(NavigationProvider navigationProvider) async
  {
    //Mark the HelderInvoice as payed and put it in the database
    HelderInvoice payedInvoice = invoice;
    payedInvoice.isPayed = true;

    await databaseService.addInvoice(payedInvoice);

    navigationProvider.setAccountsScreen(true);
  }

  void onPayLater(NavigationProvider navigationProvider) async
  {
    //Mark the HelderInvoice as not payed and put it in the database
    HelderInvoice payedInvoice = invoice;
    payedInvoice.isPayed = false;

    await databaseService.addInvoice(payedInvoice);

    navigationProvider.setAccountsScreen(false);
  }

}