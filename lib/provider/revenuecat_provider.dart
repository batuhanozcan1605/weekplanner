import 'package:flutter/cupertino.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../model/entitlement.dart';

class RevenueCatProvider extends ChangeNotifier {
  RevenueCatProvider() {
    init();
  }

  Entitlement _entitlement = Entitlement.ads;
  Entitlement get entitlement => _entitlement;

  Future init() async {
    Purchases.addCustomerInfoUpdateListener((purchaserInfo) async {
      updatePurchaseStatus();
    });
  }

  Future updatePurchaseStatus() async {
    final customerInfo = await Purchases.getCustomerInfo();
    final entitlements = customerInfo.entitlements.active.values.toList();
    _entitlement = entitlements.isEmpty ? Entitlement.ads : Entitlement.adsRemoved;
    notifyListeners();
  }

}