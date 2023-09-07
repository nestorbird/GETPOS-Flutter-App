import '../models/hub_manager.dart';
import 'db_constants.dart';

import 'package:hive_flutter/hive_flutter.dart';

class DbHubManager {
  late Box box;

  Future<void> addManager(HubManager manager) async {
    box = await Hive.openBox<HubManager>(HUB_MANAGER_BOX);
    box.add(manager);
  }

  Future<HubManager?> getManager() async {
    box = await Hive.openBox<HubManager>(HUB_MANAGER_BOX);
    if (box.length > 0) {
      return box.getAt(0);
    }
    return null;
  }
  
updateCashBalance(double orderAmount) async {
    box = await Hive.openBox<HubManager>(HUB_MANAGER_BOX);
    HubManager manager = box.get(0) as HubManager;
    manager.cashBalance = manager.cashBalance + orderAmount;
    await manager.save();
  }

  Future<int> delete() async {
    box = await Hive.openBox<HubManager>(HUB_MANAGER_BOX);
    return box.clear();
  }
}
