import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/Utilities/colors.dart';
import 'package:untitled1/Utilities/size_block.dart';

void showAlertPopUp(BuildContext context, String title, String message) {
  showDialog<Widget>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        title: Text(
          title,
          style: TextStyle(color: CustomColors.orange, fontFamily: 'Korolev', fontSize: SizeBlock.v! * 22, fontWeight: FontWeight.w700),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.black, fontFamily: 'Korolev', fontSize: SizeBlock.v! * 16, fontWeight: FontWeight.w500),
        ), actions: <Widget>[

        TextButton(
            child: Text('Ok'),
            onPressed: () {

              Navigator.of(context).pop();
            })
      ],
      ));
}
//custom dialog for after account is created
void showAlertPopUpAuth(BuildContext context, String title, String message) {
  showDialog<Widget>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        title: Text(
          title,
          style: TextStyle(color: CustomColors.orange, fontFamily: 'Korolev', fontSize: SizeBlock.v! * 22, fontWeight: FontWeight.w700),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.black, fontFamily: 'Korolev', fontSize: SizeBlock.v! * 16, fontWeight: FontWeight.w500),
        ), actions: <Widget>[

        TextButton(
            child: Text('Ok'),
            onPressed: () {

              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/mainnav');


            })
      ],
      ));
}