import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const _apiKey = 'goog_ZsANzcLJlnDCFaEUGlrZaaILpzA';

  static Future init() async {
    print('init purchase api');
    await Purchases.setDebugLogsEnabled(true); // Optional: Enable debug logs
    await Purchases.setup(_apiKey);
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;

      return current == null ? [] : [current];
    } on PlatformException catch(e) {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);

      return true;
    } catch (e) {
      return false;
    }
  }
}