import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:onboarding_app/controllers/GuideController/guide-controller.dart';

import '../../controllers/DashboardController/dashboard_controller.dart';
import '../../controllers/bottom_navigation-controller.dart';
import '../../network/models/HttpReposonceHandler.dart';
import '../../network/repository/auth/auth_repo.dart';
import '../../widgets/custom_drawer.dart';
import '../SampleVideos/SampleVideos.dart';
import '../guide/guide.dart';
import '../home/home.dart';
import '../yourVideos/your_videos.dart';

class DashboardScreen extends GetView<DashBoardController> {
  DashboardScreen({Key? key}) : super(key: key);
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  final GuideController _guideController = Get.put(GuideController());
  final BottomNavController bottomNavController =
      Get.put(BottomNavController());
  final UserRepo _userRepo = UserRepo();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double gridItemWidth = (screenWidth - 60) / 2;
    double gridItemHeight = screenWidth > 600
        ? 300.0
        : 250.0; // Adjusted height for smaller screens

    return Scaffold(
      key: _scaffoldState,
      drawer: CustomDrawer(),
      bottomNavigationBar: GNav(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        onTabChange: (index) {
          bottomNavController.changeTabIndex(index);
        },
        tabBackgroundColor: Colors.white10,
        backgroundColor: Colors.deepOrange,
        gap: 0.0,
        tabs: const [
          GButton(
            icon: Icons.dashboard,
            text: 'Dashboard',
            textColor: Colors.white,
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5.0),
          ),
          GButton(
            icon: Icons.home,
            text: 'Home',
            textColor: Colors.white,
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5.0),
          ),
          GButton(
            icon: Icons.g_mobiledata,
            text: 'Guide',
            textColor: Colors.white,
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5.0),
          ),
          GButton(
            icon: Icons.video_library_sharp,
            text: 'Your Videos',
            textColor: Colors.white,
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5.0),
          ),
        ],
      ),
      body: Obx(() {
        switch (bottomNavController.currentIndex.value) {
          case 0:
            return buildDashboardScreen(context, gridItemWidth, gridItemHeight);
          /* String? token = box.read("token");
            print("Token " + token!);
            if (token == null) {
              // Token is null, navigate to login page
              Get.offAllNamed(Routes.LOGIN);
              Get.lazyPut<LoginController>(() => LoginController());
              return LoginScreen(); // Exit the function early
            } else {
              // showFESessionExpired();

              return buildDashboardScreen(
                  context, gridItemWidth, gridItemHeight);
              // Get.lazyPut<LoginController>(() => LoginController());
              // return LoginScreen();
              //  return DashboardScreen();
            }*/
          case 1:
            return const Home();
          case 2:
            return Guide();
          case 3:
            return YourVideos();
          default:
            return YourVideos();
        }
      }),
    );
  }

  Widget buildDashboardScreen(
      BuildContext context, double gridItemWidth, double gridItemHeight) {
    return Padding(
      padding: EdgeInsets.only(top: 44, left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  _scaffoldState.currentState!.openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  size: 25,
                ),
              ),
              Text(
                "Dashboard",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              Container(),
            ],
          ),
          SizedBox(height: 20),
          const Center(
            child: Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: [
                  buildGridItem(context, 'assets/images/your_videos.gif',
                      'Your Videos', gridItemWidth, gridItemHeight),
                  buildGridItem(context, 'assets/images/sample_videos.gif',
                      'Sample Videos', gridItemWidth, gridItemHeight),
                  buildGridItem(context, 'assets/images/Tips&Tricks.gif',
                      'Tips & Tricks', gridItemWidth, gridItemHeight),
                  buildGridItem(context, 'assets/images/try_your_interview.gif',
                      'Try Your Interview', gridItemWidth, gridItemHeight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridItem(BuildContext context, String gifPath, String label,
      double width, double height) {
    return GestureDetector(
      onTap: () {
        navigateToPage(context, label);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                gifPath,
                fit: BoxFit.cover,
                height: 150.0,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToPage(BuildContext context, String label) {
    // Define the routes for each label
    Map<String, Widget> routes = {
      'Your Videos': YourVideos(),
      'Sample Videos': SampleVideos(),
      // Replace with the actual page for Sample Videos
      'Tips & Tricks': Guide(),
      // Replace with the actual page for Tips & Tricks
      'Try Your Interview': Guide(),
      // Replace with the actual page for Try Your Interview
    };

    // Get the corresponding page for the label
    Widget page =
        routes[label] ?? YourVideos(); // Default to Your Videos if no match

    // Navigate to the page
    Get.to(() => page);
  }

  void checkResponse(HttpResponse response) {
    if (response.statusCode == 401) {
      UserRepo().logout();
    } else if (response.statusCode == 422) {}
  }
}

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:onboarding_app/presentation/guide/guidepage/guidepage.dart';
import 'package:onboarding_app/presentation/guide/guidepage2/guidepage2.dart';
import '../../controllers/DashboardController/dashboard_controller.dart';
import '../../controllers/bottom_navigation-controller.dart';
import '../../widgets/custom_drawer.dart';
import '../home/home.dart';
import '../guide/guide.dart';
import '../yourVideos/your_videos.dart';
import '../SampleVideos/SampleVideos.dart';

class DashboardScreen extends GetView<DashBoardController> {
  DashboardScreen({Key? key}) : super(key: key);
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  final BottomNavController bottomNavController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double gridItemWidth = (screenWidth - 60) / 2;
    double gridItemHeight = screenWidth > 600 ? 300.0 : 250.0; // Adjusted height for smaller screens

    return Scaffold(
      key: _scaffoldState,
      drawer: CustomDrawer(),
      bottomNavigationBar: GNav(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        onTabChange: (index) {
          bottomNavController.changeTabIndex(index);
        },
        tabBackgroundColor: Colors.white10,
        backgroundColor: Colors.deepOrange,
        gap: 0.0,
        tabs: const [
          GButton(
            icon: Icons.dashboard,
            text: 'Dashboard',
            textColor: Colors.white,
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5.0),
          ),
          GButton(
            icon: Icons.home,
            text: 'Home',
            textColor: Colors.white,
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5.0),
          ),
          GButton(
            icon: Icons.g_mobiledata,
            text: 'Guide',
            textColor: Colors.white,
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5.0),
          ),
          GButton(
            icon: Icons.video_library_sharp,
            text: 'Your Videos',
            textColor: Colors.white,
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5.0),
          ),
        ],
      ),
      body: Obx(() {
        switch (bottomNavController.currentIndex.value) {
          case 0:
            return buildDashboardScreen(context, gridItemWidth, gridItemHeight);
          case 1:
            return const Home();
          case 2:
            return Guide();
          case 3:
            return YourVideos();
          default:
            return YourVideos();
        }
      }),
    );
  }

  Widget buildDashboardScreen(BuildContext context, double gridItemWidth, double gridItemHeight) {
    return Padding(
      padding: EdgeInsets.only(top: 44, left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  _scaffoldState.currentState!.openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  size: 25,
                ),
              ),
              Text(
                "Dashboard",
                style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(),
            ],
          ),
          SizedBox(height: 20),
          const Center(
            child: Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: [
                  buildGridItem(context, 'assets/images/your_videos.gif', 'Your Videos', gridItemWidth, gridItemHeight),
                  buildGridItem(context, 'assets/images/sample_videos.gif', 'Sample Videos', gridItemWidth, gridItemHeight),
                  buildGridItem(context, 'assets/images/Tips&Tricks.gif', 'Tips & Tricks', gridItemWidth, gridItemHeight),
                  buildGridItem(context, 'assets/images/try_your_interview.gif', 'Try Your Interview', gridItemWidth, gridItemHeight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridItem(BuildContext context, String gifPath, String label, double width, double height) {
    return GestureDetector(
      onTap: () {
        navigateToPage(context, label);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                gifPath,
                fit: BoxFit.cover,
                height: 150.0,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToPage(BuildContext context, String label) {
    // Define the routes for each label
    Map<String, Widget> routes = {
      'Your Videos': YourVideos(),
      'Sample Videos': VideoDemo(), // Replace with the actual page for Sample Videos
      'Tips & Tricks': Guide(), // Replace with the actual page for Tips & Tricks
      'Try Your Interview': guidepage2(), // Replace with the actual page for Try Your Interview
    };

    // Get the corresponding page for the label
    Widget page = routes[label] ?? YourVideos(); // Default to Your Videos if no match

    // Navigate to the page
    Get.to(() => page);
  }
}


 */

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../controllers/DashboardController/dashboard_controller.dart';
import '../../controllers/bottom_navigation-controller.dart';
import '../../widgets/custom_drawer.dart';
import '../guide/guidepage2/guidepage2.dart';
import '../home/home.dart';
import '../guide/guide.dart';
import '../yourVideos/your_videos.dart';
import '../SampleVideos/SampleVideos.dart';

class DashboardScreen extends GetView<DashBoardController> {
  DashboardScreen({Key? key}) : super(key: key);
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  final BottomNavController bottomNavController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double gridItemWidth = (screenWidth - 60) / 2;
    double gridItemHeight = screenWidth > 600 ? 300.0 : 250.0; // Adjusted height for smaller screens

    return Scaffold(
      key: _scaffoldState,
      drawer: CustomDrawer(),
      bottomNavigationBar: GNav(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        onTabChange: (index) {
          bottomNavController.changeTabIndex(index);
        },
        tabBackgroundColor: Colors.white10,
        backgroundColor: Colors.yellow, // Set a default background color or use Colors.transparent
        gap: 0.0,
        tabs: [
          GButton(
            icon: Icons.dashboard,
            text: 'Dashboard',
            textColor: Colors.white,
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5.0),
            backgroundColor: Colors.deepOrange, // Set the background color for Dashboard tab
          ),
          GButton(
            icon: Icons.home,
            text: 'Home',
            textColor: Colors.white,
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5.0),
            backgroundColor: Colors.blue, // Set the background color for Home tab
          ),
          GButton(
            icon: Icons.g_mobiledata,
            text: 'Guide',
            textColor: Colors.white,
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5.0),
            backgroundColor: Colors.green, // Set the background color for Guide tab
          ),
          GButton(
            icon: Icons.video_library_sharp,
            text: 'Your Videos',
            textColor: Colors.white,
            iconColor: Colors.white,
            iconActiveColor: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5.0),
            backgroundColor: Colors.red, // Set the background color for Your Videos tab
          ),
        ],
      ),
      body: Obx(() {
        switch (bottomNavController.currentIndex.value) {
          case 0:
            return buildDashboardScreen(context, gridItemWidth, gridItemHeight);
          case 1:
            return const Home();
          case 2:
            return Guide();
          case 3:
            return YourVideos();
          default:
            return YourVideos();
        }
      }),
    );
  }

  Widget buildDashboardScreen(BuildContext context, double gridItemWidth, double gridItemHeight) {
    return Padding(
      padding: EdgeInsets.only(top: 44, left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  _scaffoldState.currentState!.openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  size: 25,
                ),
              ),
              Text(
                "Dashboard",
                style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(),
            ],
          ),
          SizedBox(height: 20),
          const Center(
            child: Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: [
                  buildGridItem(context, 'assets/images/your_videos.gif', 'Your Videos', gridItemWidth, gridItemHeight),
                  buildGridItem(context, 'assets/images/sample_videos.gif', 'Sample Videos', gridItemWidth, gridItemHeight),
                  buildGridItem(context, 'assets/images/Tips&Tricks.gif', 'Tips & Tricks', gridItemWidth, gridItemHeight),
                  buildGridItem(context, 'assets/images/try_your_interview.gif', 'Try Your Interview', gridItemWidth, gridItemHeight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridItem(BuildContext context, String gifPath, String label, double width, double height) {
    return GestureDetector(
      onTap: () {
        navigateToPage(context, label);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                gifPath,
                fit: BoxFit.cover,
                height: 150.0,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToPage(BuildContext context, String label) {
    // Define the routes for each label
    Map<String, Widget> routes = {
      'Your Videos': YourVideos(),
      'Sample Videos': const SampleVideos(), // Replace with the actual page for Sample Videos
      'Tips & Tricks': Guide(), // Replace with the actual page for Tips & Tricks
      'Try Your Interview': guidepage2(), // Replace with the actual page for Try Your Interview
    };

    // Get the corresponding page for the label
    Widget page = routes[label] ?? YourVideos(); // Default to Your Videos if no match

    // Navigate to the page
    Get.to(() => page);
  }
}


 */
