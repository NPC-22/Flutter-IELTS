import 'package:flutter/material.dart';

AppButton(
    {Function()? onTap,
    String? buttontext,
    double? width,
    Color? buttonColor,
      BorderRadius? borderRadius,
    textcolor,
    Gradient? gradientcolor,
    EdgeInsetsGeometry? margin1,
    BoxBorder? border}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: margin1,
      decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: gradientcolor,
          border: border,
          color: buttonColor),
      height: 50,
      width: width,
      child: Center(
          child: Text(buttontext!,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textcolor,
                  fontFamily: "Gilroy Bold",
                  fontSize: 16))),
    ),
  );
}
