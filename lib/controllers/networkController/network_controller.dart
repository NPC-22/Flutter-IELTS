import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter/material.dart';
class NetworkController extends GetxController {
  final Connectivity connectivity = Connectivity();
  bool isDialogOpen = false;

  @override
  void onInit() {
    super.onInit();

    // Check if connectivity is not null before subscribing to the stream
    if (connectivity != null) {
      // Check if onConnectivityChanged is not null before listening to it
      if (connectivity.onConnectivityChanged != null) {
        connectivity.onConnectivityChanged.listen(updateConnectionStatus);
      } else {
        print("onConnectivityChanged stream is null");
      }
    } else {
      print("Connectivity object is null");
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void updateConnectionStatus(ConnectivityResult connectivityResult) {
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      if (!isDialogOpen) {
        showCupertinoDialog(
          context: Get.context!,
          builder: (context) => CupertinoAlertDialog(
            title: Text("No Internet Connection"),
            content: Text("Please connect to the internet."),
            actions: [
              CupertinoDialogAction(
                onPressed: ()async  {
                  // Check the current connection status
                  if (await isConnectionAvailable()) {
                    Navigator.pop(context);
                    isDialogOpen = false;
                  } else {
                    // Optionally, you can show a message or take other actions
                    print("Still no internet connection");
                  }
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
        isDialogOpen = true;
      }
    } else {
      if (isDialogOpen) {
        Navigator.pop(Get.context!);
        isDialogOpen = false;
      }
    }
  }

  Future<bool> isConnectionAvailable() async {
    var result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
