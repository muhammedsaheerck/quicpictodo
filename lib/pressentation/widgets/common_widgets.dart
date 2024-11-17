import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_constants.dart';
import '../../core/extentions.dart';

class CommonTextWidget extends StatelessWidget {
  final Color? color;
  final String text;
  final double fontSize;
  final TextAlign align;
  final double letterSpacing;
  final FontWeight fontWeight;
  final int? maxLines;
  final double? height;
  final double? wordSpacing;
  final TextOverflow? overFlow;
  final List<Shadow>? shadows;

  const CommonTextWidget({
    super.key,
    this.color,
    required this.text,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.letterSpacing = 0.5,
    this.maxLines,
    this.align = TextAlign.center,
    this.overFlow,
    this.height,
    this.wordSpacing,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
        maxLines: maxLines,
        text,
        textAlign: align,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            shadows: shadows,
            color: color,
            fontSize: fontSize,
            fontFamily: GoogleFonts.urbanist().fontFamily,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
            overflow: overFlow,
            wordSpacing: wordSpacing,
          ),
        ));
  }
}

class CommonButton extends StatelessWidget {
  final void Function()? ontap;

  final double horizontal;
  final Color bgColor;
  final double? width;
  final double? fontSize;
  final Color textColor;
  final String text;
  final FontWeight fontWeight;
  final Color borderColor;
  final double height;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;
  final Gradient? gradient;

  const CommonButton(
      {super.key,
      this.textColor = AppConstants.whiteColor,
      this.borderColor = Colors.transparent,
      required this.ontap,
      this.horizontal = 0.0,
      this.bgColor = AppConstants.mainColor,
      this.fontWeight = FontWeight.normal,
      this.fontSize,
      this.width,
      required this.height,
      required this.text,
      this.borderRadius,
      this.gradient,
      this.child});

  @override
  Widget build(BuildContext context) {
    return CommonInkwell(
      onTap: ontap,
      child: Container(
        alignment: Alignment.center,
        width: width ?? Responsive.wp(100),
        height: height,
        // padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 15),
        decoration: BoxDecoration(
          gradient: gradient,
          color: bgColor,
          border: Border.all(color: borderColor),
          borderRadius: borderRadius ?? BorderRadius.circular(5),
        ),
        child: Center(
          child: child ??
              CommonTextWidget(
                color: textColor,
                text: text,
                fontWeight: fontWeight,
                fontSize: fontSize ?? 12,
              ),
        ),
      ),
    );
  }
}

class CommonInkwell extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  final double? borderRadius;
  final Color? splashColor;
  const CommonInkwell(
      {super.key,
      required this.child,
      required this.onTap,
      this.borderRadius,
      this.splashColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      splashColor: splashColor ?? Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      focusColor: Colors.transparent,
      onTap: onTap,
      child: child,
    );
  }
}

class CustomTextFormFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String hintText;
  final Widget? prefix;
  final Widget? suffix;
  final bool isobsecureTrue;
  final bool isSuffixShow;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  const CustomTextFormFieldWidget(
      {super.key,
      required this.controller,
      this.maxLines = 1,
      this.keyboardType,
      required this.hintText,
      this.prefix,
      this.suffix,
      this.validator,
      this.textInputAction,
      this.isobsecureTrue = false,
      this.readOnly = false,
      this.isSuffixShow = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      textInputAction: textInputAction,
      obscureText: isobsecureTrue,
      keyboardType: keyboardType,
      validator: validator,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        prefixIcon: prefix,
        hintText: hintText,
        suffixIcon: suffix,
      ),
    );
  }
}

void toast(
    {String? title,
    int duration = 2,
    Color? backgroundColor,
    Color? textColor}) {
  Fluttertoast.showToast(
      msg: title ?? 'Something went wrong',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor ?? Colors.white,
      fontSize: 16.0);
}

class CommonTextFormField extends StatelessWidget {
  final Color? bgColor;
  final String hintText;
  final Color? hintTextColor;
  final bool readOnly;

  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int? maxLines;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? contentPadding;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final void Function()? onTap;

  const CommonTextFormField(
      {super.key,
      this.bgColor,
      required this.hintText,
      this.hintTextColor,
      this.readOnly = false,
      required this.keyboardType,
      this.textInputAction,
      this.validator,
      this.maxLength,
      required this.controller,
      this.contentPadding,
      this.obscureText = false,
      this.suffixIcon,
      this.maxLines = 1,
      this.prefixIcon,
      this.onChanged,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      onTap: onTap,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      style: const TextStyle(
        color: AppConstants.whiteColor,
        fontSize: 16,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      keyboardAppearance: Brightness.dark,
      maxLines: maxLines,
      onChanged: onChanged,
      cursorColor: AppConstants.whiteColor,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        counterText: '',
        alignLabelWithHint: true,
        contentPadding: contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
              const BorderSide(color: AppConstants.whiteColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
              const BorderSide(color: AppConstants.whiteColor, width: 1),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        suffixIcon: suffixIcon,
        fillColor: bgColor ?? Colors.transparent,
        filled: true,
        labelText: hintText,
        hintStyle: TextStyle(
          color: hintTextColor ?? AppConstants.whiteColor,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      validator: validator,
      maxLength: maxLength,
      controller: controller,
    );
  }
}
