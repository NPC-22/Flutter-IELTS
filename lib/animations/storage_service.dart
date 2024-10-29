import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  GetStorage? box;

  @override
  void onInit() {
    // Initialize GetStorage in the service
    box = GetStorage();
    super.onInit();
  }

  void write(String key, dynamic value) {
    box!.write(key, value);
  }

  void read(String key) {
    box!.read(key);
  }

  void remove(String key) {
    box!.remove(key);
  }

  void clearStorage() {
    box!.erase();
  }
}
