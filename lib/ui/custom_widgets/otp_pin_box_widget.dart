import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../colors.dart';

class OtpPinBoxWidget extends StatefulWidget {
  const OtpPinBoxWidget({super.key});

  @override
  State<OtpPinBoxWidget> createState() => _OtpPinBoxWidgetState();
}

class _OtpPinBoxWidgetState extends State<OtpPinBoxWidget> {

  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 53,
      width: 53,
      child: TextFormField(
        showCursor: false,
        cursorColor: Colors.transparent,
        cursorWidth: 0,
        enableInteractiveSelection: false,
        onTap: () {
          _pinController.clear();
        },
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: AppColors.primaryGreen, width: 3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: Colors.indigoAccent, width: 3),
            ),
            filled: true,
            fillColor: Colors.white,
          hintText: "0",
            hintStyle: TextStyle(color: Colors.grey.withOpacity(.95))
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}
