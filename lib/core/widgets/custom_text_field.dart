import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool isEnabled;
  final Function? onChangedValue;
  final double? height;
  final int? maxLength;
  final double? customPadding;
  final bool isForDescription;
  final int? maxLine;
  final Function? onSuffixIconClicked;
  final TextInputAction textInputAction;
  final Function? onClicked;
  final bool autoFocus;

  CustomTextField(
      {required this.hintText,
       required this.controller,
      required this.textInputType,
      this.inputFormatters,
      this.validator,
      this.isEnabled = true,
      this.onChangedValue,
      this.height,
      this.maxLength,
      this.customPadding,
      this.isForDescription = false,
      this.maxLine,
      this.onSuffixIconClicked,
      this.textInputAction = TextInputAction.none,
      this.onClicked,
      this.autoFocus = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Container(
         decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 0),
              ),
            ],
          ),
        child: TextFormField(
          controller: controller,
          cursorColor: Theme.of(context).primaryColor,
          keyboardType: textInputType,
          autofocus: autoFocus,
          inputFormatters: inputFormatters,
          validator: validator,
          style: TextStyle(color: Colors.black, decorationThickness: 0),
          enabled: isEnabled,
          minLines: isForDescription ? 3 : null,
          maxLines: maxLine ?? 1,
          maxLength: maxLength,
          onTap: (){
            if(onClicked != null){
              onClicked!();
            }
          },
          textInputAction: textInputAction,
          onChanged: onChangedValue != null
              ? (value) {
                  onChangedValue!(value);
                }
              : null,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8),
                child:SvgPicture.asset(
                  'assets/images/ic_search.svg',
                  width: 19,
                  height: 19,
                ),
              ),
              /*suffixIcon: Padding(
                padding:  EdgeInsets.only(right: 8.w, top: 8.h, bottom: 8.h),
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Color(0xFF08022A)
                  ),
                  child: Center(child: Icon(Icons.mic, color: Colors.white,)),
                ),
              ),*/
              //constraints: BoxConstraints(maxHeight: height ?? 100.h, maxWidth: double.infinity),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 16.h,
                  horizontal: 16.w),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,)),
        ),
      ),
    );
  }

}
