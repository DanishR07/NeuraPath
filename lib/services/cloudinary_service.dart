import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = "dpw7heky8"; // Replace with your Cloudinary cloud name
  static const String uploadPreset = "neura profiles"; // Replace with your unsigned upload preset

  static Future<String?> uploadProfileImage(File imageFile) async {
    try {
      print('[v0] CloudinaryService: Starting image upload');

      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      var request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = 'neurapath/profiles';
      request.fields['public_id'] = 'profile_${DateTime.now().millisecondsSinceEpoch}';

      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);

        // Extract secure_url from JSON response
        final startIndex = responseString.indexOf('"secure_url":"') + 14;
        final endIndex = responseString.indexOf('"', startIndex);
        final imageUrl = responseString.substring(startIndex, endIndex);

        print('[v0] CloudinaryService: Image uploaded successfully - $imageUrl');
        return imageUrl;
      } else {
        print('[v0] CloudinaryService: Upload failed - Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('[v0] CloudinaryService: Exception during upload - ${e.toString()}');
      return null;
    }
  }
}
