import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  // Gmail SMTP Configuration
  static const String _senderEmail = 'danishriasat792@gmail.com'; // Update with your email
  static const String _appPassword = 'aqos srhz qviq yvua'; // Update with App Password from Google

  static final smtpServer = gmail(_senderEmail, _appPassword);

  /// Send OTP to user's email
  static Future<bool> sendOTPEmail({
    required String recipientEmail,
    required String otp,
  }) async {
    try {
      print('[v0] [EmailService] Preparing to send OTP email to: $recipientEmail');
      print('[v0] [EmailService] OTP: $otp');

      final message = Message()
        ..from = Address(_senderEmail, 'Neura Path')
        ..recipients.add(recipientEmail)
        ..subject = 'Your OTP for Password Reset'
        ..html = '''
          <html>
            <body style="font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;">
              <div style="background-color: white; padding: 30px; border-radius: 8px; max-width: 600px; margin: 0 auto;">
                <h2 style="color: #333;">Password Reset OTP</h2>
                <p style="color: #666; font-size: 16px;">Hi,</p>
                <p style="color: #666; font-size: 16px;">You requested to reset your password. Use the following OTP to complete the process:</p>
                
                <div style="background-color: #f0f0f0; padding: 20px; border-radius: 5px; text-align: center; margin: 20px 0;">
                  <p style="font-size: 32px; font-weight: bold; color: #007bff; margin: 0;">$otp</p>
                </div>
                
                <p style="color: #666; font-size: 14px;">This OTP will expire in 5 minutes.</p>
                <p style="color: #666; font-size: 14px;">If you didn't request this, please ignore this email.</p>
                
                <hr style="border: none; border-top: 1px solid #ddd; margin: 20px 0;">
                <p style="color: #999; font-size: 12px;">© 2025 Neura Path. All rights reserved.</p>
              </div>
            </body>
          </html>
        ''';

      print('[v0] [EmailService] Connecting to SMTP server...');
      await send(message, smtpServer);

      print('[v0] [EmailService] OTP email sent successfully to: $recipientEmail');
      return true;
    } catch (e) {
      print('[v0] [EmailService] ERROR sending email: ${e.toString()}');
      return false;
    }
  }
}
