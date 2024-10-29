import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onboarding_app/presentation/chart/PieChartDisplay.dart';
import 'package:onboarding_app/presentation/chart/ProgressReportPage.dart';

import '../controllers/drawer_navigation-controller.dart';
import '../network/models/userprofile_model.dart';
import '../network/repository/auth/auth_repo.dart';
import '../presentation/Caccounts/Caccounts.dart';
import '../routes/app_pages.dart';

class CustomDrawer extends StatefulWidget {
  final UserProfile? userProfile;

  CustomDrawer({this.userProfile});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final DrawerNavigationController _controller =
      Get.put(DrawerNavigationController());
  final List<MenuItems> menuItems = [
    MenuItems(
        title: 'My Profile', icon: Icons.person, color: Colors.transparent),
    MenuItems(title: 'Dashboard', icon: Icons.home, color: Colors.transparent),
    MenuItems(
        title: 'Your Score',
        icon: Icons.pie_chart_sharp,
        color: Colors.transparent),
    MenuItems(
        title: 'Progress Bar',
        icon: Icons.bar_chart,
        color: Colors.transparent),
    MenuItems(title: 'Logout', icon: Icons.logout, color: Colors.transparent),
  ];

  late bool logoutInitiated; // Flag to track logout initiation

  @override
  void initState() {
    super.initState();
    logoutInitiated = false; // Initialize flag
    _checkNameData(); // Start checking for null name data
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: AnimatedContainer(
        duration: const Duration(minutes: 1),
        child: GetBuilder<DrawerNavigationController>(
          builder: (newController) => Drawer(
            backgroundColor: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 44, left: 18, right: 18),
                  child: FutureBuilder<String?>(
                    future: _getUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasData) {
                        return _buildWelcomeText(snapshot.data!);
                      } else {
                        // User profile is null, immediate logout
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          if (!logoutInitiated) {
                            _initiateLogout();
                          }
                        });
                        return Container();
                      }
                    },
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(width: 0.5, color: Colors.grey)),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => ListTile(
                          title: Text(
                            menuItems[index].title,
                            style: Theme.of(context)
                                .textTheme!
                                .headlineLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        _controller.selectedIndex.value == index
                                            ? Color(0xFFe93e33)
                                            : Colors.black,
                                    fontSize: 14),
                          ),
                          leading: Icon(
                            menuItems[index].icon,
                            color: _controller.selectedIndex.value == index
                                ? Color(0xFFe93e33)
                                : Colors.black,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 18,
                            color: Colors.black,
                          ),
                          tileColor: _controller.selectedIndex.value == index
                              ? menuItems[index].color
                              : null,
                          onTap: () {
                            if (index == 0) {
                              // Navigate to Profile page
                              Get.to(
                                  CAccounts(userProfile: widget.userProfile));
                            } else if (index == 1) {
                              getUserProfile();
                              Get.back();
                              // Navigator.pushReplacementNamed(context, '/dashboard');
                            } else if (index == 2) {
                              // Navigate to Pie chart page
                              Get.to(PieChartDisplay());
                            } else if (index == 3) {
                              // Navigate to Progress chart page
                              Get.to(ProgressReportPage());
                            } else if (index == 4) {
                              Get.defaultDialog(
                                radius: 12,
                                title: 'Confirm Logout',
                                titleStyle: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800),
                                middleText: 'Are you sure you want to logout?',
                                middleTextStyle: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _controller.selectedIndex.value = index;
                                      UserRepo().logout();
                                    },
                                    child: Text(
                                      'Logout',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                              fontSize: 14,
                                              color: Color(0xFFe93e33),
                                              fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                              fontSize: 14,
                                              color: Color(0xFFe93e33),
                                              fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 2,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showFESessionExpired() {
    Get.snackbar(
      "Session Expired...",
      "Session has expired. Please login again.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      duration: const Duration(seconds: 3),
    );
  }

  Future<String?> _getUserName() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 13));
    String? name = _controller.userProfile?.data?.name?.capitalizeFirst;
    if (name == null) {
      // Username is null, initiate logout
      _initiateLogout();
    }
    return name;
  }

  Widget _buildWelcomeText(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            RichText(
              text: TextSpan(
                text: 'Hi $name,\n',
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 26),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Welcome to the\n',
                    style: TextStyle(
                      height: 1.8,
                      fontSize: 26,
                    ),
                  ),
                  TextSpan(
                    text: 'Cuvasol',
                    style: TextStyle(
                        height: 1.5,
                        fontSize: 40,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: <Color>[
                              Color(0xFFe93e33),
                              Color(0xFFff7e00)
                            ],
                          ).createShader(
                              const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              textHeightBehavior:
                  const TextHeightBehavior(applyHeightToFirstAscent: true),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.clear,
            size: 32,
          ),
        )
      ],
    );
  }

  Future<void> _checkNameData() async {
    // Wait for 1 seconds
    await Future.delayed(const Duration(seconds: 1));
    // If logout not already initiated and name data is still null, initiate logout
    if (!logoutInitiated && _controller.userProfile?.data?.name == null) {
      _initiateLogout();
    }
  }

  void _initiateLogout() {
    logoutInitiated =
        true; // Set flag to true to prevent multiple logout attempts
    // UserRepo().logout();
  }

  void showSessionExpiredSnackBar() {
    Get.snackbar(
      "Session Expired...",
      "Session has expired. Please login again.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      duration: const Duration(seconds: 3),
    );
  }

  Future<HttpResponse> getUserProfile() async {
    var isLoading = false.obs;
    UserRepo userRepo = UserRepo();
    final box = GetStorage();
    isLoading.value = true;

    HttpResponse httpResponse = (await userRepo.userProfile()) as HttpResponse;
    if (httpResponse.statusCode == 401) {
      box.remove("token");
      box.remove("login");
      showSessionExpiredSnackBar();
      Get.offAllNamed(Routes.LOGIN);
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Server issues, Check again later')));
    }
    isLoading.value = false;
    return httpResponse;
  }
}

class MenuItems {
  final String title;
  final IconData icon;
  final Color color;

  MenuItems({required this.title, required this.icon, required this.color});
}
// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
//
// import '../controllers/drawer_navigation-controller.dart';
// import '../network/models/userprofile_model.dart';
// import '../network/repository/auth/auth_repo.dart';
// import '../routes/app_pages.dart';
//
// class CustomDrawer extends StatefulWidget {
//   final UserProfile? userProfile;
//
//   CustomDrawer({this.userProfile});
//
//   @override
//   State<CustomDrawer> createState() => _CustomDrawerState();
// }
//
// class _CustomDrawerState extends State<CustomDrawer> {
//   final DrawerNavigationController _controller =
//       Get.put(DrawerNavigationController());
//   final List<MenuItems> menuItems = [
//     MenuItems(title: 'Dashboard', icon: Icons.home, color: Colors.transparent),
//     MenuItems(title: 'Logout', icon: Icons.logout, color: Colors.transparent),
//   ];
//
//   late bool logoutInitiated; // Flag to track logout initiation
//
//   @override
//   void initState() {
//     super.initState();
//     logoutInitiated = false; // Initialize flag
//     _checkNameData(); // Start checking for null name data
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       child: AnimatedContainer(
//         duration: const Duration(minutes: 1),
//         child: GetBuilder<DrawerNavigationController>(
//           builder: (newController) => Drawer(
//             backgroundColor: Colors.white,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 44, left: 18, right: 18),
//                   child: FutureBuilder<String?>(
//                     future: _getUserName(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return CircularProgressIndicator();
//                       }
//                       if (snapshot.hasData) {
//                         return _buildWelcomeText(snapshot.data!);
//                       } else {
//                         // User profile is null, immediate logout
//                         WidgetsBinding.instance?.addPostFrameCallback((_) {
//                           if (!logoutInitiated) {
//                             _initiateLogout();
//                           }
//                         });
//                         return Container();
//                       }
//                     },
//                   ),
//                 ),
//                 Container(
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
//                   decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.all(Radius.circular(12)),
//                       border: Border.all(width: 0.5, color: Colors.grey)),
//                   child: ListView.separated(
//                     padding: EdgeInsets.zero,
//                     shrinkWrap: true,
//                     itemCount: menuItems.length,
//                     itemBuilder: (context, index) {
//                       return Obx(
//                         () => ListTile(
//                           title: Text(
//                             menuItems[index].title,
//                             style: Theme.of(context)
//                                 .textTheme!
//                                 .headlineLarge!
//                                 .copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     color:
//                                         _controller.selectedIndex.value == index
//                                             ? Color(0xFFe93e33)
//                                             : Colors.black,
//                                     fontSize: 14),
//                           ),
//                           leading: Icon(
//                             menuItems[index].icon,
//                             color: _controller.selectedIndex.value == index
//                                 ? Color(0xFFe93e33)
//                                 : Colors.black,
//                           ),
//                           trailing: const Icon(
//                             Icons.arrow_forward_ios_outlined,
//                             size: 18,
//                             color: Colors.black,
//                           ),
//                           tileColor: _controller.selectedIndex.value == index
//                               ? menuItems[index].color
//                               : null,
//                           onTap: () {
//                             if (index == 0) {
//                               // debugger(when: true, message: "valid");
//                               //showFESessionExpired();
//                               getUserProfile();
//                               Get.back();
//                               // Navigator.pushReplacementNamed(context, '/dashboard');
//                             } else if (index == 1) {
//                               Get.defaultDialog(
//                                 radius: 12,
//                                 title: 'Confirm Logout',
//                                 titleStyle: Theme.of(context)
//                                     .textTheme
//                                     .headlineLarge
//                                     ?.copyWith(
//                                         fontSize: 18,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w800),
//                                 middleText: 'Are you sure you want to logout?',
//                                 middleTextStyle: Theme.of(context)
//                                     .textTheme
//                                     .headlineLarge
//                                     ?.copyWith(
//                                         fontSize: 14,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w500),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       _controller.selectedIndex.value = index;
//                                       UserRepo().logout();
//                                     },
//                                     child: Text(
//                                       'Logout',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headlineLarge
//                                           ?.copyWith(
//                                               fontSize: 14,
//                                               color: Color(0xFFe93e33),
//                                               fontWeight: FontWeight.w800),
//                                     ),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Get.back();
//                                     },
//                                     child: Text(
//                                       'Cancel',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headlineLarge
//                                           ?.copyWith(
//                                               fontSize: 14,
//                                               color: Color(0xFFe93e33),
//                                               fontWeight: FontWeight.w800),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }
//                           },
//                         ),
//                       );
//                     },
//                     separatorBuilder: (BuildContext context, int index) {
//                       return const Divider(
//                         height: 2,
//                         color: Colors.grey,
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void showFESessionExpired() {
//     Get.snackbar(
//       "Session Expired...",
//       "Session has expired. Please login again.",
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.black87,
//       colorText: Colors.white,
//       margin: const EdgeInsets.all(20),
//       duration: const Duration(seconds: 3),
//     );
//   }
//
//   Future<String?> _getUserName() async {
//     // Simulate network delay
//     await Future.delayed(Duration(milliseconds: 13));
//     String? name = _controller.userProfile?.data?.name?.capitalizeFirst;
//     if (name == null) {
//       // Username is null, initiate logout
//       _initiateLogout();
//     }
//     return name;
//   }
//
//   Widget _buildWelcomeText(String name) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           children: [
//             RichText(
//               text: TextSpan(
//                 text: 'Hi $name,\n',
//                 style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black,
//                     fontSize: 26),
//                 children: <TextSpan>[
//                   const TextSpan(
//                     text: 'Welcome to the\n',
//                     style: TextStyle(
//                       height: 1.8,
//                       fontSize: 26,
//                     ),
//                   ),
//                   TextSpan(
//                     text: 'Cuvasol',
//                     style: TextStyle(
//                         height: 1.5,
//                         fontSize: 40,
//                         foreground: Paint()
//                           ..shader = const LinearGradient(
//                             colors: <Color>[
//                               Color(0xFFe93e33),
//                               Color(0xFFff7e00)
//                             ],
//                           ).createShader(
//                               const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               textHeightBehavior:
//                   const TextHeightBehavior(applyHeightToFirstAscent: true),
//             ),
//           ],
//         ),
//         InkWell(
//           onTap: () {
//             Get.back();
//           },
//           child: const Icon(
//             Icons.clear,
//             size: 32,
//           ),
//         )
//       ],
//     );
//   }
//
//   Future<void> _checkNameData() async {
//     // Wait for 1 seconds
//     await Future.delayed(const Duration(seconds: 1));
//     // If logout not already initiated and name data is still null, initiate logout
//     if (!logoutInitiated && _controller.userProfile?.data?.name == null) {
//       _initiateLogout();
//     }
//   }
//
//   void _initiateLogout() {
//     logoutInitiated =
//         true; // Set flag to true to prevent multiple logout attempts
//     //UserRepo().logout();
//   }
//
//   void showSessionExpiredSnackBar() {
//     Get.snackbar(
//       "Session Expired...",
//       "Session has expired. Please login again.",
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.black87,
//       colorText: Colors.white,
//       margin: const EdgeInsets.all(20),
//       duration: const Duration(seconds: 3),
//     );
//   }
//
//   Future<HttpResponse> getUserProfile() async {
//     var isLoading = false.obs;
//     UserRepo userRepo = UserRepo();
//     final box = GetStorage();
//     isLoading.value = true;
//
//     HttpResponse httpResponse = (await userRepo.userProfile()) as HttpResponse;
//     if (httpResponse.statusCode == 401) {
//       box.remove("token");
//       box.remove("login");
//       showSessionExpiredSnackBar();
//       Get.offAllNamed(Routes.LOGIN);
//     } else {
//       // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Server issues, Check again later')));
//     }
//     isLoading.value = false;
//     return httpResponse;
//   }
// }
//
// class MenuItems {
//   final String title;
//   final IconData icon;
//   final Color color;
//
//   MenuItems({required this.title, required this.icon, required this.color});
// }

/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../network/models/userprofile_model.dart';
import '../controllers/drawer_navigation-controller.dart';
import '../network/repository/auth/auth_repo.dart';

class CustomDrawer extends StatefulWidget {
  final UserProfile? userProfile;

  CustomDrawer({this.userProfile});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final DrawerNavigationController _controller =
  Get.put(DrawerNavigationController());
  final List<MenuItems> menuItems = [
    MenuItems(title: 'Dashboard', icon: Icons.home, color: Colors.transparent),
    MenuItems(title: 'Logout', icon: Icons.logout, color: Colors.transparent),
  ];

  late bool logoutInitiated; // Flag to track logout initiation

  @override
  void initState() {
    super.initState();
    logoutInitiated = false; // Initialize flag
    _checkNameData(); // Start checking for null name data
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: AnimatedContainer(
        duration: const Duration(minutes: 1),
        child: GetBuilder<DrawerNavigationController>(
          builder: (newController) => Drawer(
            backgroundColor: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 44, left: 18, right: 18),
                  child: FutureBuilder<String?>(
                    future: _getUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasData) {
                        return _buildWelcomeText(snapshot.data!);
                      } else {
                        // User profile is null, immediate logout
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          if (!logoutInitiated) {
                            _initiateLogout();
                          }
                        });
                        return Container();
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(width: 0.5, color: Colors.grey)),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      return Obx(
                            () => ListTile(
                          title: Text(
                            menuItems[index].title,
                            style: Theme.of(context).textTheme!.headlineLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _controller.selectedIndex.value == index
                                    ? Color(0xFFe93e33)
                                    : Colors.black,
                                fontSize: 14),
                          ),
                          leading: Icon(
                            menuItems[index].icon,
                            color: _controller.selectedIndex.value == index
                                ? Color(0xFFe93e33)
                                : Colors.black,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 18,
                            color: Colors.black,
                          ),
                          tileColor: _controller.selectedIndex.value == index
                              ? menuItems[index].color
                              : null,
                          onTap: () {
                            if (index == 0) {
                              Get.back();
                              // Navigator.pushReplacementNamed(context, '/dashboard');
                            } else if (index == 1) {
                              Get.defaultDialog(
                                radius: 12,
                                title: 'Confirm Logout',
                                titleStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontSize: 18, color: Colors.black, fontWeight: FontWeight.w800),
                                middleText: 'Are you sure you want to logout?',
                                middleTextStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _controller.selectedIndex.value = index;
                                      UserRepo().logout();
                                    },
                                    child: Text(
                                      'Logout',
                                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                          fontSize: 14,
                                          color: Color(0xFFe93e33),
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                          fontSize: 14,
                                          color: Color(0xFFe93e33),
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 2,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _getUserName() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 13));
    return _controller.userProfile?.data?.name?.capitalizeFirst;
  }

  Widget _buildWelcomeText(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            RichText(
              text: TextSpan(
                text: 'Hi $name,\n',
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.black, fontSize: 26),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Welcome to the\n',
                    style: TextStyle(
                      height: 1.8,
                      fontSize: 26,
                    ),
                  ),
                  TextSpan(
                    text: 'Cuvasol',
                    style: TextStyle(
                        height: 1.5,
                        fontSize: 40,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: <Color>[
                              Color(0xFFe93e33),
                              Color(0xFFff7e00)
                            ],
                          ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: true),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.clear,
            size: 32,
          ),
        )
      ],
    );
  }

  Future<void> _checkNameData() async {
    // Wait for 1 seconds
    await Future.delayed(const Duration(seconds: 1));
    // If logout not already initiated and name data is still null, initiate logout
    if (!logoutInitiated && _controller.userProfile?.data?.name == null) {
      _initiateLogout();
    }
  }

  void _initiateLogout() {
    logoutInitiated = true; // Set flag to true to prevent multiple logout attempts
    UserRepo().logout();
  }
}

class MenuItems {
  final String title;
  final IconData icon;
  final Color color;

  MenuItems({required this.title, required this.icon, required this.color});
}

 */

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../network/models/userprofile_model.dart';
import '../controllers/drawer_navigation-controller.dart';
import '../network/repository/auth/auth_repo.dart';

class CustomDrawer extends StatefulWidget {
  final UserProfile? userProfile;

  CustomDrawer({this.userProfile});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final DrawerNavigationController _controller = Get.put(DrawerNavigationController());
  final List<MenuItems> menuItems = [
    MenuItems(title: 'Dashboard', icon: Icons.home, color: Colors.transparent),
    MenuItems(title: 'Logout', icon: Icons.logout, color: Colors.transparent),
  ];

  late String _userName; // Cached user name

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    String? userName = await _getUserName();
    setState(() {
      _userName = userName ?? ''; // Use empty string if userName is null
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: AnimatedContainer(
        duration: const Duration(minutes: 1),
        child: GetBuilder<DrawerNavigationController>(
          builder: (newController) => Drawer(
            backgroundColor: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 44, left: 18, right: 18),
                  child: _buildWelcomeText(_userName),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(width: 0.5, color: Colors.grey)),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      return Obx(
                            () => ListTile(
                          title: Text(
                            menuItems[index].title,
                            style: Theme.of(context).textTheme!.headlineLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _controller.selectedIndex.value == index
                                    ? Color(0xFFe93e33)
                                    : Colors.black,
                                fontSize: 14),
                          ),
                          leading: Icon(
                            menuItems[index].icon,
                            color: _controller.selectedIndex.value == index
                                ? Color(0xFFe93e33)
                                : Colors.black,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 18,
                            color: Colors.black,
                          ),
                          tileColor: _controller.selectedIndex.value == index
                              ? menuItems[index].color
                              : null,
                          onTap: () {
                            if (index == 0) {
                              Get.back();
                              Navigator.pushReplacementNamed(context, '/dashboard');
                            } else if (index == 1) {
                              Get.defaultDialog(
                                radius: 12,
                                title: 'Confirm Logout',
                                titleStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontSize: 18, color: Colors.black, fontWeight: FontWeight.w800),
                                middleText: 'Are you sure you want to logout?',
                                middleTextStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _controller.selectedIndex.value = index;
                                      UserRepo().logout();
                                    },
                                    child: Text(
                                      'Logout',
                                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                          fontSize: 14,
                                          color: Color(0xFFe93e33),
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                          fontSize: 14,
                                          color: Color(0xFFe93e33),
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 2,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _getUserName() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 5));
    return _controller.userProfile.data?.name?.capitalizeFirst;
  }

  Widget _buildWelcomeText(String name) {
    if (name.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              RichText(
                text: TextSpan(
                  text: 'Hi $name,\n',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black, fontSize: 26),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Welcome to the\n',
                      style: TextStyle(
                        height: 1.8,
                        fontSize: 26,
                      ),
                    ),
                    TextSpan(
                      text: 'Cuvasol',
                      style: TextStyle(
                          height: 1.5,
                          fontSize: 40,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: <Color>[
                                Color(0xFFe93e33),
                                Color(0xFFff7e00)
                              ],
                            ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: true),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.clear,
              size: 32,
            ),
          )
        ],
      );
    } else {
      return CircularProgressIndicator(); // Show loading indicator until name is loaded
    }
  }
}

class MenuItems {
  final String title;
  final IconData icon;
  final Color color;

  MenuItems({required this.title, required this.icon, required this.color});
}

 */

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../network/models/userprofile_model.dart';
// import '../controllers/drawer_navigation-controller.dart';
// import '../network/repository/auth/auth_repo.dart';
//
// class CustomDrawer extends StatefulWidget {
//   final UserProfile? userProfile;
//
//   CustomDrawer({this.userProfile});
//
//   @override
//   State<CustomDrawer> createState() => _CustomDrawerState();
// }
//
// class _CustomDrawerState extends State<CustomDrawer> {
//   final DrawerNavigationController _controller =
//   Get.put(DrawerNavigationController());
//   final List<MenuItems> menuItems = [
//     MenuItems(title: 'Dashboard', icon: Icons.home, color: Colors.transparent),
//     MenuItems(title: 'Logout', icon: Icons.logout, color: Colors.transparent),
//   ];
//
//   late bool logoutInitiated; // Flag to track logout initiation
//
//   @override
//   void initState() {
//     super.initState();
//     logoutInitiated = false; // Initialize flag
//     _checkNameData(); // Start checking for null name data
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       child: AnimatedContainer(
//         duration: const Duration(minutes: 1),
//         child: GetBuilder<DrawerNavigationController>(
//           builder: (newController) => Drawer(
//             backgroundColor: Colors.white,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 44, left: 18, right: 18),
//                   child: FutureBuilder<String?>(
//                     future: _getUserName(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return CircularProgressIndicator();
//                       }
//                       if (snapshot.hasData) {
//                         return _buildWelcomeText(snapshot.data!);
//                       } else {
//                         // User profile is null, immediate logout
//                         WidgetsBinding.instance?.addPostFrameCallback((_) {
//                           if (!logoutInitiated) {
//                             _initiateLogout();
//                           }
//                         });
//                         return Container();
//                       }
//                     },
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
//                   decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.all(Radius.circular(12)),
//                       border: Border.all(width: 0.5, color: Colors.grey)),
//                   child: ListView.separated(
//                     padding: EdgeInsets.zero,
//                     shrinkWrap: true,
//                     itemCount: menuItems.length,
//                     itemBuilder: (context, index) {
//                       return Obx(
//                             () => ListTile(
//                           title: Text(
//                             menuItems[index].title,
//                             style: Theme.of(context).textTheme!.headlineLarge!.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: _controller.selectedIndex.value == index
//                                     ? Color(0xFFe93e33)
//                                     : Colors.black,
//                                 fontSize: 14),
//                           ),
//                           leading: Icon(
//                             menuItems[index].icon,
//                             color: _controller.selectedIndex.value == index
//                                 ? Color(0xFFe93e33)
//                                 : Colors.black,
//                           ),
//                           trailing: const Icon(
//                             Icons.arrow_forward_ios_outlined,
//                             size: 18,
//                             color: Colors.black,
//                           ),
//                           tileColor: _controller.selectedIndex.value == index
//                               ? menuItems[index].color
//                               : null,
//                           onTap: () {
//                             if (index == 0) {
//                               Get.back();
//                               // Navigator.pushReplacementNamed(context, '/dashboard');
//                             } else if (index == 1) {
//                               Get.defaultDialog(
//                                 radius: 12,
//                                 title: 'Confirm Logout',
//                                 titleStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                                     fontSize: 18, color: Colors.black, fontWeight: FontWeight.w800),
//                                 middleText: 'Are you sure you want to logout?',
//                                 middleTextStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                                     fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       _controller.selectedIndex.value = index;
//                                       UserRepo().logout();
//                                     },
//                                     child: Text(
//                                       'Logout',
//                                       style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                                           fontSize: 14,
//                                           color: Color(0xFFe93e33),
//                                           fontWeight: FontWeight.w800),
//                                     ),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Get.back();
//                                     },
//                                     child: Text(
//                                       'Cancel',
//                                       style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                                           fontSize: 14,
//                                           color: Color(0xFFe93e33),
//                                           fontWeight: FontWeight.w800),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }
//                           },
//                         ),
//                       );
//                     },
//                     separatorBuilder: (BuildContext context, int index) {
//                       return const Divider(
//                         height: 2,
//                         color: Colors.grey,
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<String?> _getUserName() async {
//     // Simulate network delay
//     await Future.delayed(Duration(milliseconds: 13));
//     return _controller.userProfile.data?.name?.capitalizeFirst;
//   }
//
//   Widget _buildWelcomeText(String name) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           children: [
//             RichText(
//               text: TextSpan(
//                 text: 'Hi $name,\n',
//                 style: const TextStyle(
//                     fontWeight: FontWeight.w500, color: Colors.black, fontSize: 26),
//                 children: <TextSpan>[
//                   const TextSpan(
//                     text: 'Welcome to the\n',
//                     style: TextStyle(
//                       height: 1.8,
//                       fontSize: 26,
//                     ),
//                   ),
//                   TextSpan(
//                     text: 'Cuvasol',
//                     style: TextStyle(
//                         height: 1.5,
//                         fontSize: 40,
//                         foreground: Paint()
//                           ..shader = const LinearGradient(
//                             colors: <Color>[
//                               Color(0xFFe93e33),
//                               Color(0xFFff7e00)
//                             ],
//                           ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: true),
//             ),
//           ],
//         ),
//         InkWell(
//           onTap: () {
//             Get.back();
//           },
//           child: const Icon(
//             Icons.clear,
//             size: 32,
//           ),
//         )
//       ],
//     );
//   }
//
//   Future<void> _checkNameData() async {
//     // Wait for 3 seconds
//     await Future.delayed(const Duration(seconds: 3));
//     // If logout not already initiated and name data is still null, initiate logout
//     if (!logoutInitiated && _controller.userProfile.data?.name == null) {
//       _initiateLogout();
//     }
//   }
//
//   void _initiateLogout() {
//     logoutInitiated = true; // Set flag to true to prevent multiple logout attempts
//     UserRepo().logout();
//   }
// }
//
// class MenuItems {
//   final String title;
//   final IconData icon;
//   final Color color;
//
//   MenuItems({required this.title, required this.icon, required this.color});
// }

// /*
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../network/models/userprofile_model.dart';
// import '../controllers/drawer_navigation-controller.dart';
// import '../network/repository/auth/auth_repo.dart';
//
// class CustomDrawer extends StatefulWidget {
//   UserProfile? userProfile;
//   CustomDrawer({this.userProfile});
//
//   @override
//   State<CustomDrawer> createState() => _CustomDrawerState();
// }
//
// class _CustomDrawerState extends State<CustomDrawer> {
//   final DrawerNavigationController _controller =
//   Get.put(DrawerNavigationController());
//   final List<MenuItems> menuItems = [
//     MenuItems(
//         title: 'Dashboard', icon: Icons.home, color: Colors.transparent),
//     MenuItems(title: 'Logout', icon: Icons.logout, color: Colors.transparent),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: AnimatedContainer(
//           duration: const Duration(minutes: 1),
//           child: GetBuilder<DrawerNavigationController>(
//             builder: (newController) => Drawer(
//               backgroundColor: Colors.white,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 44, left: 18, right: 18),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Column(
//                           children: [
//                             RichText(
//                               text: TextSpan(
//                                 text:
//                                 'Hi ${_controller.userProfile.data?.name?.capitalizeFirst},\n',
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black,
//                                     fontSize: 26),
//                                 children: <TextSpan>[
//                                   const TextSpan(
//                                     text: 'Welcome to the\n',
//                                     style: TextStyle(
//                                       height: 1.8,
//                                       fontSize: 26,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: 'Cuvasol',
//                                     style: TextStyle(
//                                         height: 1.5,
//                                         fontSize: 40,
//                                         foreground: Paint()
//                                           ..shader = const LinearGradient(
//                                             colors: <Color>[
//                                               Color(0xFFe93e33),
//                                               Color(0xFFff7e00)
//                                             ],
//                                           ).createShader(const Rect.fromLTWH(
//                                               0.0, 0.0, 200.0, 100.0)),
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                               textHeightBehavior: const TextHeightBehavior(
//                                   applyHeightToFirstAscent: true),
//                             ),
//                           ],
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Get.back();
//                           },
//                           child: const Icon(
//                             Icons.clear,
//                             size: 32,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.symmetric(
//                         horizontal: 18, vertical: 30),
//                     decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.all(Radius.circular(12)),
//                         border: Border.all(width: 0.5, color: Colors.grey)),
//                     child: ListView.separated(
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       itemCount: menuItems.length,
//                       itemBuilder: (context, index) {
//                         return Obx(
//                               () => ListTile(
//                             title: Text(
//                               menuItems[index].title,
//                               style: Theme.of(context)
//                                   .textTheme!
//                                   .headlineLarge!
//                                   .copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: _controller.selectedIndex.value ==
//                                       index
//                                       ? Color(0xFFe93e33)
//                                       : Colors.black,
//                                   fontSize: 14),
//                             ),
//                             leading: Icon(
//                               menuItems[index].icon,
//                               color: _controller.selectedIndex.value == index
//                                   ? Color(0xFFe93e33)
//                                   : Colors.black,
//                             ),
//                             trailing: const Icon(
//                               Icons.arrow_forward_ios_outlined,
//                               size: 18,
//                               color: Colors.black,
//                             ),
//                             tileColor: _controller.selectedIndex.value == index
//                                 ? menuItems[index].color
//                                 : null,
//                             onTap: () {
//                               if (index == 0) { // Dashboard item clicked
//                                 Get.back(); // Close the drawer
//                                 // Navigate to the Dashboard page
//                                 // You may need to replace '/dashboard' with your actual dashboard route
//                                 Navigator.pushReplacementNamed(context, '/dashboard');
//                               } else if (index == 1) { // Logout item clicked
//                                 Get.defaultDialog(
//                                   radius: 12,
//                                   title: 'Confirm Logout',
//                                   titleStyle: Theme.of(context)
//                                       .textTheme
//                                       .headlineLarge
//                                       ?.copyWith(
//                                       fontSize: 18,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w800),
//                                   middleText:
//                                   'Are you sure you want to logout?',
//                                   middleTextStyle: Theme.of(context)
//                                       .textTheme
//                                       .headlineLarge
//                                       ?.copyWith(
//                                       fontSize: 14,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w500),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () {
//                                         _controller.selectedIndex.value = index;
//                                         UserRepo().logout();
//                                       },
//                                       child: Text(
//                                         'Logout',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .headlineLarge
//                                             ?.copyWith(
//                                             fontSize: 14,
//                                             color: Color(0xFFe93e33),
//                                             fontWeight: FontWeight.w800),
//                                       ),
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         Get.back();
//                                       },
//                                       child: Text(
//                                         'Cancel',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .headlineLarge
//                                             ?.copyWith(
//                                             fontSize: 14,
//                                             color: Color(0xFFe93e33),
//                                             fontWeight: FontWeight.w800),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               }
//                             },
//                           ),
//                         );
//                       },
//                       separatorBuilder: (BuildContext context, int index) {
//                         return const Divider(
//                           height: 2,
//                           color: Colors.grey,
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
//
// class MenuItems {
//   final String title;
//   final IconData icon;
//   final Color color;
//
//   MenuItems({required this.title, required this.icon, required this.color});
// }
//
//
//
//  */
//
//
// /*
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../network/models/userprofile_model.dart';
// import '../controllers/drawer_navigation-controller.dart';
// import '../network/repository/auth/auth_repo.dart';
//
// class CustomDrawer extends StatefulWidget {
//   UserProfile? userProfile;
//   CustomDrawer({this.userProfile});
//
//   @override
//   State<CustomDrawer> createState() => _CustomDrawerState();
// }
//
// class _CustomDrawerState extends State<CustomDrawer> {
//   final DrawerNavigationController _controller =
//   Get.put(DrawerNavigationController());
//   final List<MenuItems> menuItems = [
//     MenuItems(
//         title: 'Dashboard', icon: Icons.home, color: Colors.transparent),
//     MenuItems(title: 'Logout', icon: Icons.logout, color: Colors.transparent),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         width: MediaQuery.of(context).size.width,
//
//         child: AnimatedContainer(
//           duration: const Duration(minutes: 1),
//           child: GetBuilder<DrawerNavigationController>(
//             builder: (newController) => Drawer(
//               backgroundColor: Colors.white,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 44, left: 18, right: 18),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Column(
//                           children: [
//                             RichText(
//                               text: TextSpan(
//                                 text:
//                                 'Hi ${_controller.userProfile?.data?.name?.capitalizeFirst},\n',
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black,
//                                     fontSize: 26),
//                                 children: <TextSpan>[
//                                   const TextSpan(
//                                     text: 'Welcome to the\n',
//                                     style: TextStyle(
//                                       height: 1.8,
//                                       fontSize: 26,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: 'Cuvasol',
//                                     style: TextStyle(
//                                         height: 1.5,
//                                         fontSize: 40,
//                                         foreground: Paint()
//                                           ..shader = const LinearGradient(
//                                             colors: <Color>[
//                                               Color(0xFFe93e33),
//                                               Color(0xFFff7e00)
//                                             ],
//                                           ).createShader(const Rect.fromLTWH(
//                                               0.0, 0.0, 200.0, 100.0)),
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                               textHeightBehavior: const TextHeightBehavior(
//                                   applyHeightToFirstAscent: true),
//                             ),
//                           ],
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Get.back();
//                           },
//                           child: const Icon(
//                             Icons.clear,
//                             size: 32,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.symmetric(
//                         horizontal: 18, vertical: 30),
//                     decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.all(Radius.circular(12)),
//                         border: Border.all(width: 0.5, color: Colors.grey)),
//                     child: ListView.separated(
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       itemCount: menuItems.length,
//                       itemBuilder: (context, index) {
//                         return Obx(
//                               () => ListTile(
//                             title: Text(
//                               menuItems[index].title,
//                               style: Theme.of(context)
//                                   .textTheme!
//                                   .headlineLarge!
//                                   .copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: _controller.selectedIndex.value ==
//                                       index
//                                       ? Color(0xFFe93e33)
//                                       : Colors.black,
//                                   fontSize: 14),
//                             ),
//                             leading: Icon(
//                               menuItems[index].icon,
//                               color: _controller.selectedIndex.value == index
//                                   ? Color(0xFFe93e33)
//                                   : Colors.black,
//                             ),
//                             trailing: const Icon(
//                               Icons.arrow_forward_ios_outlined,
//                               size: 18,
//                               color: Colors.black,
//                             ),
//                             tileColor: _controller.selectedIndex.value == index
//                                 ? menuItems[index].color
//                                 : null,
//                             onTap: () {
//                               if (index == 1) {
//                                 Get.defaultDialog(
//                                   radius: 12,
//                                   title: 'Confirm Logout',
//                                   titleStyle: Theme.of(context)
//                                       .textTheme
//                                       .headlineLarge
//                                       ?.copyWith(
//                                       fontSize: 18,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w800),
//                                   middleText:
//                                   'Are you sure you want to logout?',
//                                   middleTextStyle: Theme.of(context)
//                                       .textTheme
//                                       .headlineLarge
//                                       ?.copyWith(
//                                       fontSize: 14,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w500),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () {
//                                         _controller.selectedIndex.value = index;
//                                         UserRepo().logout();
//                                       },
//                                       child: Text(
//                                         'Logout',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .headlineLarge
//                                             ?.copyWith(
//                                             fontSize: 14,
//                                             color: Color(0xFFe93e33),
//                                             fontWeight: FontWeight.w800),
//                                       ),
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         Get.back();
//                                       },
//                                       child: Text(
//                                         'Cancel',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .headlineLarge
//                                             ?.copyWith(
//                                             fontSize: 14,
//                                             color: Color(0xFFe93e33),
//                                             fontWeight: FontWeight.w800),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               }
//                             },
//                           ),
//                         );
//                       },
//                       separatorBuilder: (BuildContext context, int index) {
//                         return const Divider(
//                           height: 2,
//                           color: Colors.grey,
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
//
// class MenuItems {
//   final String title;
//   final IconData icon;
//   final Color color;
//
//   MenuItems({required this.title, required this.icon, required this.color});
// }
//
//  */
//
// /*
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../network/models/userprofile_model.dart';
// import '../controllers/drawer_navigation-controller.dart';
// import '../network/repository/auth/auth_repo.dart';
//
// class CustomDrawer extends StatefulWidget {
//    UserProfile? userProfile;
//    CustomDrawer({this.userProfile}) ;
//
//   @override
//   State<CustomDrawer> createState() => _CustomDrawerState();
// }
//
// class _CustomDrawerState extends State<CustomDrawer> {
//   final DrawerNavigationController _controller =
//       Get.put(DrawerNavigationController());
//   final List<MenuItems> menuItems = [
//     MenuItems(title: 'Dashboard', icon: Icons.home, color: Colors.transparent),
//     MenuItems(
//         title: 'Progress Report',
//         icon: Icons.person,
//         color: Colors.transparent),
//     MenuItems(
//         title: 'Deep Analysis',
//         icon: Icons.settings,
//         color: Colors.transparent),
//     MenuItems(title: 'Logout', icon: Icons.logout, color: Colors.transparent),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         width: MediaQuery.of(context).size.width, //20.0,
//
//         child: AnimatedContainer(
//           duration: const Duration(minutes: 1),
//           child: GetBuilder<DrawerNavigationController>(
//             builder: (newController) =>
//                 Drawer(
//               backgroundColor: Colors.white,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 44, left: 18, right: 18),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Column(
//                           children: [
//                             RichText(
//                               text: TextSpan(
//                                 text: 'Hi ${_controller.userProfile?.data?.name?.capitalizeFirst},\n',
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black,
//                                     fontSize: 26),
//                                 children: <TextSpan>[
//                                   const TextSpan(
//                                     text: 'Welcome to the\n',
//                                     style: TextStyle(
//                                       height: 1.8,
//                                       fontSize: 26,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: 'Cuvasol',
//                                     style: TextStyle(
//                                         height: 1.5,
//                                         fontSize: 40,
//                                         //color: Color(0xFFff7e00),
//                                         foreground: Paint()
//                                           ..shader = const LinearGradient(
//                                             colors: <Color>[
//                                               Color(0xFFe93e33), Color(0xFFff7e00)
//                                               //add more color here.
//                                             ],
//                                           ).createShader(const Rect.fromLTWH(
//                                               0.0, 0.0, 200.0, 100.0)),
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                               textHeightBehavior: const TextHeightBehavior(
//                                   applyHeightToFirstAscent: true),
//                             ),
//                           ],
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Get.back();
//                           },
//                           child: const Icon(
//                             Icons.clear,
//                             size: 32,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
//                     decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.all(Radius.circular(12)),
//                         border: Border.all(width: 0.5, color: Colors.grey)),
//                     child: ListView.separated(
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       itemCount: menuItems.length,
//                       itemBuilder: (context, index) {
//                         return Obx(
//                           () => ListTile(
//                             // Set the title and icon based on the menu item
//                             title: Text(
//                               menuItems[index].title,
//                               style: Theme.of(context)
//                                   .textTheme!
//                                   .headlineLarge!
//                                   .copyWith(
//                                       fontWeight: FontWeight.bold,
//                                       color:
//                                           _controller.selectedIndex.value == index
//                                               ? Color(0xFFe93e33)
//                                               : Colors.black,
//                                       fontSize: 14),
//                             ),
//                             leading: Icon(
//                               menuItems[index].icon,
//                               color: _controller.selectedIndex.value == index
//                                   ? Color(0xFFe93e33)
//                                   : Colors.black,
//                             ),
//                             trailing: const Icon(
//                               Icons.arrow_forward_ios_outlined,
//                               size: 18,
//                               color: Colors.black,
//                             ),
//                             // Set the selected color based on the selected index
//                             tileColor: _controller.selectedIndex.value == index
//                                 ? menuItems[index].color
//                                 : null,
//                             // On tap, call the onMenuItemTap function to navigate to the respective screen
//                             onTap: () {
//                               if (index == 3) {
//                                 // Show confirmation dialog for logout
//                                 Get.back();
//                                 Get.defaultDialog(
//                                 radius: 12,
//                                   title: 'Confirm Logout',
//                                   titleStyle:      Theme.of(context)
//                                     .textTheme
//                                     .headlineLarge
//                                     ?.copyWith(
//                                     fontSize: 18,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w800),
//                                   middleText: 'Are you sure you want to logout?',
//                                   middleTextStyle:  Theme.of(context)
//                                       .textTheme
//                                       .headlineLarge
//                                       ?.copyWith(
//                                       fontSize: 14,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w500),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () {
//                                         // Perform logout action here
//                                         _controller.selectedIndex.value = index;
//                                         UserRepo().logout();
//
//                                       },
//                                       child: Text('Logout',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headlineLarge
//                                           ?.copyWith(
//                                           fontSize: 14,
//                                           color: Color(0xFFe93e33),
//                                           fontWeight: FontWeight.w800),
//                                       ),
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         Get.back();
//                                       },
//                                       child: Text('Cancel',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headlineLarge
//                                           ?.copyWith(
//                                           fontSize: 14,
//                                           color: Color(0xFFe93e33),
//                                           fontWeight: FontWeight.w800),
//
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               } else {
//                                 // Handle other menu item taps
//                                 _controller.selectedIndex.value = index;
//                               }
//                             },
//                           ),
//                         );
//                       },
//                       separatorBuilder: (BuildContext context, int index) {
//                         return const Divider(
//                           height: 2,
//                           color: Colors.grey,
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
//
// // Model class for menu items
// class MenuItems {
//   final String title;
//   final IconData icon;
//   final Color color;
//
//   MenuItems({required this.title, required this.icon, required this.color});
// }
//
//  */
