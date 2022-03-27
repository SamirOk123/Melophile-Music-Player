import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:my_music_player/constants/constants.dart';

class FunctionsController extends GetxController{


 showToast({required msge}) {
    Fluttertoast.showToast(
        msg: msge,
        backgroundColor: kLightBlue,
        textColor: Colors.white,
        fontSize: 14,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT);
  }


}