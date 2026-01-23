import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter/foundation.dart';

class NetworkService extends GetxService {
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _startListening();
  }

  void _startListening() {
    InternetConnection().onStatusChange.listen((status) {
      final connected = status == InternetStatus.connected;

      debugPrint('🌐 Internet status -> $connected');

      isConnected.value = connected;
    });
  }

  /// Manually check connection once (for Try Again button)
  Future<void> checkNow() async {
    try {
      final connected = await InternetConnection().hasInternetAccess;

      debugPrint('🔄 Manual internet check -> $connected');

      isConnected.value = connected;
    } catch (e) {
      debugPrint('❌ Manual internet check error: $e');
      isConnected.value = false;
    }
  }
}
