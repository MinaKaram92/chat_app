import 'package:flutter/material.dart';

void navigateTo(context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigateAndFinish(context, Widget widget) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => widget), (route) => false);
}

Widget defaultTextFormField({
  required TextInputType type,
  required TextEditingController controller,
  String? label,
  String? hint,
  TextStyle? hintStyle,
  TextStyle? labelStyle,
  IconData? prefix,
  IconData? suffix,
  bool isPassword = false,
  Function? validate,
  Function? submit,
  Function? changed,
  VoidCallback? suffixPressed,
  VoidCallback? onTab,
  TextStyle? style,
  int? maxLength,
  bool expands = false,
  int? maxLines = 1,
  bool autoFocus = false,
  InputBorder? border,
}) =>
    TextFormField(
      autofocus: autoFocus,
      expands: expands,
      maxLength: maxLength,
      maxLines: maxLines,
      obscureText: isPassword,
      controller: controller,
      style: style,
      keyboardType: type,
      validator: (value) {
        return validate!(value);
      },
      onFieldSubmitted: (s) {
        if (submit != null) {
          submit(s);
        }
      },
      onChanged: (s) {
        if (changed != null) {
          changed(s);
        }
      },
      onTap: onTab,
      decoration: InputDecoration(
        counterText: '',
        labelText: label,
        labelStyle: labelStyle,
        hintStyle: hintStyle,
        hintText: hint,
        prefixIcon: prefix != null ? Icon(prefix) : null,
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: suffixPressed,
              )
            : null,
        border: border,
      ),
    );

Widget defaultMaterialButton({
  double width = double.infinity,
  Color backgroundColor = Colors.blue,
  double radius = 10.0,
  bool isUpper = true,
  required VoidCallback pressed,
  required String text,
  double fontSize = 25.0,
  Color textColor = Colors.white,
}) =>
    Container(
      width: width,
      height: 40.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius), color: backgroundColor),
      child: MaterialButton(
        onPressed: pressed,
        child: Text(
          isUpper ? text.toUpperCase() : text,
          style: TextStyle(fontSize: fontSize, color: textColor),
        ),
      ),
    );

Widget goBack(context) {
  return IconButton(
    icon: Icon(
      Icons.arrow_back_ios_new,
      color: Colors.black,
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );
}
