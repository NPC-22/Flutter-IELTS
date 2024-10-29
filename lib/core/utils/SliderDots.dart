import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SlideDots extends StatelessWidget {
  bool isActive;
  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.3),
      height: isActive ? 10 : 8,
      width: isActive ? 10 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white,
        border: isActive ?  Border.all(color: Color(0xFFe93e33),width: 2.0,) : Border.all(color: Colors.grey,width: 2.0,),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}