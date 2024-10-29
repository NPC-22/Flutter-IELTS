import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../controllers/drawer_navigation-controller.dart';
import '../../network/models/userprofile_model.dart';
import '../../routes/app_pages.dart';

class CAccounts extends StatefulWidget {
  final UserProfile? userProfile;

  CAccounts({this.userProfile});

  @override
  State<CAccounts> createState() => _CAccountsState();
}

class _CAccountsState extends State<CAccounts> {
  final DrawerNavigationController _controller =
      Get.put(DrawerNavigationController());
  bool logoutInitiated = false;
  int videoCount = 0;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await Future.wait([_fetchUserProfile(), _fetchVideoCount()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: isUpdating
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<UserProfile?>(
                      future: _getUserProfile(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasData && snapshot.data != null) {
                          return _buildProfileForm(snapshot.data!);
                        } else {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!logoutInitiated) {
                              _initiateLogout();
                            }
                          });
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<UserProfile?> _getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _controller.userProfile;
  }

  Future<void> _fetchUserProfile() async {
    final box = GetStorage();
    //try {
      var response = await http.get(
        Uri.parse('https://api.cuvasol.com/api/profile'),
        headers: {
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == true) {
          var profile = UserProfile.fromJson(data['data']);
          _controller.userProfile = profile;
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        } else {
          throw Exception('Failed to fetch user profile.');
        }
      } else {
        throw Exception(
            'Failed to fetch user profile. Status code: ${response.statusCode}');
      }
  //   }
  //   catch (e) {
  //     print('Error fetching user profile: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text('Server issues,Please check again later.')),
  //     );
  //   }
   }

  Future<void> _fetchVideoCount() async {
    final box = GetStorage();
    final token = box.read('token');
    print('Fetching video count with token: $token');
    try {
      var response = await http.get(
        Uri.parse('https://api.cuvasol.com/api/videos/limit'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == true) {
          setState(() {
            videoCount = data['data']['video_count'];
          });
        } else {
          throw Exception('Failed to fetch video count.');
        }
      } else {
        throw Exception(
            'Failed to fetch video count. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching video count: $e');
    }
  }

  Widget _buildProfileForm(UserProfile profile) {
    final nameController = TextEditingController(text: profile.data?.name);
    final emailController =
        TextEditingController(text: profile.data?.contactEmail);
    final phoneController =
        TextEditingController(text: profile.data?.phoneNumber);
    final majorController = TextEditingController(text: profile.data?.major);
    final degreeController = TextEditingController(text: profile.data?.degree);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEditableField('Name', nameController),
        _buildEditableField('Email', emailController),
        _buildEditableField('Phone Number', phoneController),
        _buildEditableField('Major', majorController),
        _buildEditableField('Degree', degreeController),
        const SizedBox(height: 20),
        _buildVideoCountField(),
        const SizedBox(height: 40),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton('Update Account', Icons.update, () {
                _updateProfile(
                  nameController.text,
                  emailController.text,
                  phoneController.text,
                  majorController.text,
                  degreeController.text,
                );
              }),
              const SizedBox(width: 10),
              _buildActionButton(
                  'Delete Account', Icons.delete, _showDeleteAccountDialog),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 20, color: Colors.black),
            ],
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1.5,
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCountField() {
    return Text(
      'Number of Videos: $videoCount',
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildActionButton(
      String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xffe56b14),
        textStyle: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        side: const BorderSide(color: Color(0xffe56b14)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: TextStyle(color: Colors.black),
        ),
        content: Text(
          'Are you sure you want to delete your account?',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              _deleteAccount();
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateProfile(String name, String email, String phone,
      String major, String degree) async {
    final box = GetStorage();
    final token = box.read('token');
    print('Updating profile with token: $token');
    setState(() {
      isUpdating = true;
    });

    try {
      var response = await http.post(
        Uri.parse('https://api.cuvasol.com/api/profile/create'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'name': name,
          'contact_email': email,
          'phone_number': phone,
          'major': major,
          'degree': degree,
        },
      );

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data['status'] == true) {
          print(
              'User Profile created Successfully. Verification code: ${data['data']['code']}');
          await _fetchUserProfile();
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Profile updated successfully')),
          // );
        } else {
          throw Exception('Failed to update profile.');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Server issues,Please check again later.')),
        );
        throw Exception(
            'Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isUpdating = false;
      });
    }
  }

  Future<void> _deleteAccount() async {
    final box = GetStorage();
    final token = box.read('token');
    print('Deleting account with token: $token');
    setState(() {
      isUpdating = true;
    });

    try {
      var response = await http.post(
        Uri.parse('https://api.cuvasol.com/api/delete'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data['status'] == true) {
          box.remove("token");
          box.remove("login");
          Get.offAllNamed(Routes.LOGIN);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account successfully deleted')),
          );
        } else {
          throw Exception('Failed to delete account.');
        }
      } else {
        throw Exception(
            'Failed to delete account. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isUpdating = false;
      });
    }
  }

  void _initiateLogout() {
    logoutInitiated = true;
    Get.offAllNamed(Routes.LOGIN);
  }
}
