import 'package:helder_proto/data/services/database_service.dart';
import 'package:helder_proto/models/helder_renderable_data.dart';
import 'package:helder_proto/providers/navigation_provider.dart';

class PaymentController {
  final DatabaseService databaseService = DatabaseService.instance;
  final HelderRenderableData helderData;

  PaymentController({
    required this.helderData
  });

  void onPayNow(NavigationProvider navigationProvider) async {
    await helderData.markAsPayed(databaseService);
    navigationProvider.setAccountsScreen(true);
  }

  void onPayLater(NavigationProvider navigationProvider) async {
    await helderData.markAsNotPayed(databaseService);
    navigationProvider.setAccountsScreen(false);
  }

  void onReviecvingOkay(NavigationProvider navigationProvider) async {
    if (helderData.isRecievingMoney()) {
      await helderData.insertOrUpdate(databaseService);
    }
    navigationProvider.setAccountsScreen(true);
  }

}