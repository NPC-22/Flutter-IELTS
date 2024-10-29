

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../routes/app_pages.dart';

class FirstMiddleware extends GetMiddleware{
  final box = GetStorage();


  @override
  int? priority = 0;

  FirstMiddleware({required this.priority});
 @override
RouteSettings? redirect(String? route){
return box.read('login') == true ? RouteSettings(name: Routes.LOGIN) :  RouteSettings(name: Routes.DASHBOARD);

 }

}