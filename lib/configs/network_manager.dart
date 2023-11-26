import 'package:get/get.dart';
import 'package:nb_posx/configs/network_connection.dart';

class NetworkManager {
  static void init() {
    Get.put<NetworkConnection>(NetworkConnection(), permanent: true);
  }
}
