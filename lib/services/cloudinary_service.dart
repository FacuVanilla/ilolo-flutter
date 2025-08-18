import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  // Initialize Cloudinary configuration
  final cloudName = 'du0fmx61a';
  final apiKey = '772482574151749';
  final apiSecret = 'Wui708vzWA1NjUdlhHNUkzn4dgM';

  // method to pick image from device and upload to cloudinary
  Future<String?> saveToCloud() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery, maxHeight: 600.0, maxWidth: 600.0);

    if (image != null) {
      final filePath = File(image.path);

      // Generate a unique timestamp for the public_id
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a SHA-1 hash of the timestamp and the API secret
      final signature = sha1.convert(utf8.encode('timestamp=$timestamp$apiSecret'));

      // Construct the URL for the upload request
      final uploadUrl = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/upload');

      // Create a multipart request
      final request = http.MultipartRequest('POST', uploadUrl);

      // Add the API key and timestamp to the request headers
      request.headers['X-Requested-With'] = 'XMLHttpRequest';
      request.fields['api_key'] = apiKey;
      request.fields['timestamp'] = timestamp;
      request.fields['signature'] = signature.toString();

      // Add the image file to the request
      final imageFile = await http.MultipartFile.fromPath('file', filePath.path);
      request.files.add(imageFile);

      // Send the request and await the response
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> jsonResponse = json.decode(responseBody);
        if (jsonResponse.containsKey('secure_url')) {
          return jsonResponse['secure_url'];
        } else {
          throw Exception('Uploaded image URL not found in response');
        }
      } else {
        // print('Image upload failed');
        return null;
      }
    } else {
      return null;
    }
  }
}
