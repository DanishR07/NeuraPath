import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../customs.dart';
import '../../../data/repositories/auth_repository.dart';
import '../view_models/otp_verification_vm.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late OtpVerificationViewModel _viewModel;
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _viewModel = Get.put(OtpVerificationViewModel());
  }

  String _getEnteredOTP() => _otpControllers.map((controller) => controller.text).join();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 30),
          child: Column(
            children: [
              SizedBox(height: 5),
              Text(
                'Enter OTP',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  textAlign: TextAlign.center,
                  'A one-time-password (OTP) has been sent to your registered email.',
                  style: TextStyle(fontSize: 13.5),
                ),
              ),
              SizedBox(height: 40),

              // OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return OtpInputField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                      }
                    },
                  );
                }),
              ),

              SizedBox(height: 20),

              // Countdown / Expired Banner
              Obx(() {
                return Text(
                  _viewModel.isOTPExpired.value
                      ? 'OTP has expired. Please request a new one.'
                      : 'OTP expires in ${_viewModel.formatTime(_viewModel.otpSecondsRemaining.value)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: _viewModel.isOTPExpired.value ? Colors.red : Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),

              // Error display
              Obx(() {
                if (_viewModel.errorMessage.value != null) {
                  return Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        _viewModel.errorMessage.value!,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  );
                }
                return SizedBox.shrink();
              }),

              SizedBox(height: 60),

              // Verify Button
              Obx(() {
                final isLoading = _viewModel.isVerifying.value;

                return ElevatedButton(
                  onPressed: (isLoading || _viewModel.isOTPExpired.value)
                      ? null
                      : () {
                    _viewModel.verifyOTP(_getEnteredOTP());
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                  child: isLoading
                      ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text(
                    "Verify",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                );
              }),

              SizedBox(height: 230),

              // Resend OTP Row
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Didn't receive the code?"),
                    SizedBox(width: 5),
                    _viewModel.isResending.value
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    )
                        : GestureDetector(
                      onTap: _viewModel.isResendCooldownActive.value
                          ? null
                          : () => _viewModel.resendOTP(),
                      child: Text(
                        _viewModel.isResendCooldownActive.value
                            ? "Resend in ${_viewModel.resendCooldownSeconds.value}s"
                            : "Resend",
                        style: TextStyle(
                          color: _viewModel.isResendCooldownActive.value
                              ? Colors.grey
                              : AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}

class OtpInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;

  const OtpInputField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 53,
      width: 53,
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        showCursor: false,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: AppColors.primaryGreen, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.indigoAccent, width: 3),
          ),
          filled: true,
          fillColor: Colors.white,
          counterText: '',
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
