import 'package:cryptbee/Utilities/utilities.dart';
import 'package:flutter/material.dart';

class PasswordTextArea extends StatefulWidget {
  final String labelText;
  final String hintText;
  TextEditingController controller = TextEditingController();
  final Color fontColor = Colors.black;

  PasswordTextArea(
      {super.key, required this.labelText, required this.hintText});

  @override
  State<PasswordTextArea> createState() => _PasswordTextAreaState();
}

class _PasswordTextAreaState extends State<PasswordTextArea> {
  bool _passwordShow = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.85 * MediaQuery.of(context).size.width,
      child: TextFormField(
          obscureText: !_passwordShow,
          controller: widget.controller,
          style: bodyMedium(),
          decoration: InputDecoration(
            hintStyle: bodyMedium(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: widget.labelText,
            hintText: widget.hintText,
            labelStyle: labelMedium(),
            errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                    color: Palette.secondaryOffWhiteColor, width: 2)),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                    color: Palette.secondaryOffWhiteColor, width: 2)),
            disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                    color: Palette.secondaryOffWhiteColor, width: 2)),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                    color: Palette.secondaryOffWhiteColor, width: 2)),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                    color: Palette.secondaryOffWhiteColor, width: 2)),
            suffixIcon: IconButton(
              icon: Icon(
                _passwordShow
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Palette.secondaryOffWhiteColor,
              ),
              onPressed: () {
                setState(() {
                  _passwordShow = !_passwordShow;
                });
              },
            ),
            prefixIcon: const Icon(
              Icons.person_outline_sharp,
              color: Palette.secondaryOffWhiteColor,
            ),
          )),
    );
  }
}
