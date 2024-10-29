import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:onboarding_app/network/models/userprofile_model.dart';
import 'package:onboarding_app/network/repository/auth/auth_repo.dart';
import 'package:onboarding_app/presentation/login/login_screen.dart';
//import 'package:onboarding_app/presentation/progressReport/progressReport_screen.dart';
import 'package:onboarding_app/presentation/signup/signup_screen.dart';


import '../controllers/drawer_navigation-controller.dart';
import '../widgets/custom_drawer.dart';
import 'dashboard/dashboard_screen.dart';
import 'deepAnalysis/deep_analysis_screen.dart';


class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final DrawerNavigationController _controller = Get.put(DrawerNavigationController());
  Future _showLogoutConfirmationDialog() {
  return   Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      confirm: ElevatedButton(
        onPressed: () {
          //_controller.changeItem(3); // Logout action
          Get.back();// Close the dialog
          UserRepo().logout();
        },
        child: Text('Logout'),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back(); // Close the dialog
        },
        child: Text('Cancel'),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Builder(
      builder: (context) =>
          Scaffold(
            key: _scaffoldState,
            drawer: CustomDrawer( userProfile: _controller.userProfile),
            body: Obx(() {
              switch (_controller.selectedIndex.value) {
                case 0:
                  return DashboardScreen();
                case 1:
                  return DashboardScreen();
                case 2:
                  return DashboardScreen();
                case 3:
                 // return _showLogoutConfirmationDialog();

                default:
                  return Container();
              }
            }),
          ),
    );
  }
}

