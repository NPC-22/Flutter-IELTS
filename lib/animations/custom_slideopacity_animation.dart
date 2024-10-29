
import 'package:flutter/material.dart';

class SlideFadeTransition extends StatefulWidget {
  final Widget? child;
 final AnimationController? animationController;

  const SlideFadeTransition({Key? key,  this.child, this.animationController}) : super(key: key);

  @override
  State<SlideFadeTransition> createState() => _SlideFadeTransitionState();
}

class _SlideFadeTransitionState extends State<SlideFadeTransition>  with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<Offset>? animation;
  Animation<double>? fadeAnimation;


  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animation = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero).animate(

      CurvedAnimation(
        parent: animationController!,
        curve: Curves.easeIn,

      ),
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(

      CurvedAnimation(
        parent: animationController!,
        curve: Curves.easeIn,
      ),
    );

    animationController!.forward();

  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation!,
      child: AnimatedOpacity(
         opacity: .9,
        duration: Duration(milliseconds: 1000),
        child: widget.child,


      ),
    );

  }
}