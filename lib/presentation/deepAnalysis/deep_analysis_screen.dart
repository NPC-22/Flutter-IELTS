

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../widgets/custom_drawer.dart';
import '../dashboard/dashboard_screen.dart';

class DeepAnalysisScreen extends GetWidget{
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        key: _scaffoldState,
        drawer: CustomDrawer(),
        body: Padding(
          padding: EdgeInsets.only(top: 44, left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        _scaffoldState.currentState!.openDrawer();
                        // Navigator.pop(context);
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));
                      },
                      icon: const Icon(
                        Icons.menu,
                        //Icons.arrow_back,
                        size: 30,
                      )),
                  Text(
                      "Deep Analysis",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)
                  ),
                  Container()
                ],
              ),
            ],
          ),

        )

    );
  }



}