import 'dart:io';

class ConnectivityService {
  /// Check if device has internet connectivity
  /// Returns true if internet is available, false otherwise
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get error message for no internet
  static String getNoInternetMessage() {
    return 'No internet connection. Please check your network and try again.';
  }
}
