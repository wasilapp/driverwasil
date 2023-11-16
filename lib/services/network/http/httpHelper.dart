import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'endPoint.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

sendNotification(
    {required String? to,
    required String? title,
    required String? imageUrl,
    required String? body}) async {
  var client = http.Client();
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  try {
    await client
        .post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "key=AAAA-LdECyI:APA91bFKnjvowXUdqcQPlzNx0toy4ePvCjChtUFZQDMsMEIpf6JiAAL0cvV1F9JCVZ8o0JvTYkSlx-pOtW_NfK0TnQMv5Ax1fbUiI5F4kY4w-l14Z4DSDYtLckZWJOYxHdcop1vi3i6K",
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'title': title,
                'image': imageUrl,
                'body': body,
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done',
                'title': title,
                'image': imageUrl,
                'body': body,
              },
              "to": '$to',
            },
          ),
        )
        .then((value) => print('done 1${value}'));
    print('done notified');
  } catch (e) {
    print("error push notification");
  }
}

Future postData(
    {required String? pathUrl,
    required Map<String, dynamic>? body,
    token,header}) async {
  var client = http.Client();
  var url = Uri.parse('${ApiPath.BASEURL}$pathUrl');
  var res = await client.post(
    url,
    headers:header?? {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: body,
  );
  print(body);
  print(res.statusCode);
  print(res.body.toString());

  return jsonDecode(res.body.toString());
}

Future uploadImage({
  required String? pathUrl,
  required File imageFile,
  required Map<String, String> body,
  token,
}) async {
  // File imageFile = File('path_to_your_image.jpg');
  //var stream = await http.ByteStream(imageFile.openRead());
  //
  // var request = http.MultipartRequest('POST', Uri.parse('your_api_endpoint'));
  //  request.files.add(
  //    http.MultipartFile.fromBytes('image', imageBytes, filename: 'image.jpg'),
  //  );
  //
  // var headers = {
  //   'token': '$token',
  //   'Cookie': 'PHPSESSID=j5jact0mbq01t04d9u3050r9qo'
  // };
  // var request =
  //     http.MultipartRequest('POST', Uri.parse('${ApiPath.BASEURL}${pathUrl}'));
  // print('${ApiPath.BASEURL}create');
  // var length = await imageFile.length();
  // var stream = new http.ByteStream(imageFile.openRead());
  // stream.cast();
  // request.files.add(await http.MultipartFile('image', stream, length,
  //     filename: (imageFile.path)));

  // request.files.add(
  //   await http.MultipartFile.fromBytes('image', imageBytes,
  //       filename: 'image.jpg'),
  // );
  // print(imageBytes);
  var file = File(imageFile.path);
  // var stream = http.ByteStream(file.openRead());
  var length = await file.length();
  var stream = http.ByteStream(file.openRead());
  var headers = {
    'token': '623c8bb13872e0c4d3dbcff37e97b49e4a7f8d34c39fa9360c6600d749842f20',
    'Cookie': 'PHPSESSID=j9sqsp6vqa65p8dsj78kfa6124'
  };
  var request = http.MultipartRequest(
      'POST', Uri.parse('http://chat.msarweb.net/api/create'));
  request.fields.addAll({'name': 'دردشة', 'category': '1'});
  var multipartFile = http.MultipartFile(
    'image',
    stream,
    length,
    filename: file.path.split('/').last,
  );

  request.files.add(multipartFile);
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }

  // request.fields.addAll(body);
  //
  // print(imageFile.path.toString());
  // request.headers.addAll(headers);
  //
  // http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
  // var stream = http.ByteStream(Stream.castFrom(imageFile.openRead()));
  // var length = await imageFile.length();
  // var headers = {
  //   'token': '$token',
  //   'Cookie': 'PHPSESSID=o3tl1srvea3fbq9n48d7sbf4qe'
  // };
  // var uri =
  //     Uri.parse('${ApiPath.BASEURL}${pathUrl}'); // Replace with your server URL
  //
  // var request = http.MultipartRequest('POST', uri);
  // request.fields.addAll(body);
  //
  // var multipartFile = await http.MultipartFile('image', stream, length,
  //     filename: imageFile.path);
  //
  // request.files.add(multipartFile);
  // request.headers.addAll(headers);
  //
  // http.StreamedResponse response = await request.send();
  //
  // if (response.statusCode == 200) {
  //   print('Image uploaded successfully :::');
  // } else {
  //   print('Image upload failed with status code: ${response.statusCode}');
  // }
  final respStr = await response.stream.bytesToString();
  return jsonDecode(respStr.toString());
}

Future getData(
    {required String pathUrl, Map<String, dynamic>? query, token}) async {
  var client = http.Client();
  var url = Uri.parse('${ApiPath.BASEURL}$pathUrl');
  var res = await client.get(url, headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  });
  print(res.body.toString());
  return jsonDecode(res.body.toString());
}

uploadFile({
  required String pathUrl,
  required String token,
  required Map<String, String> data,
  required File file,
}) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse('http://chat.msarweb.net/api/create'));
  // request.fields.addAll(data);
  //request.fields.addAll(data);
  var length = await file.length();
  var stream = http.ByteStream(file.openRead());
  var multiPartFile = http.MultipartFile('image', stream, length,
      filename: basename(file.path));
  request.files.add(multiPartFile);
  // request.fields.addAll(data);
  // data.forEach((key, value) {
  //   request.fields[key] = value;
  // });
  var headers = {
    'token': token,
    'Cookie': 'PHPSESSID=jf2kc67ab7oa5gb5rpafg92c7e'
  };
  request.fields.addAll(data);
  print(data);
  request.headers.addAll(headers);

  var myRequest = await request.send();
  var response = await http.Response.fromStream(myRequest);
  if (myRequest.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print('Error ${myRequest.statusCode}');
  }

  return jsonDecode(response.body);
}

Future<void> pickAndUploadImage() async {
  var headers = {
    'token': '623c8bb13872e0c4d3dbcff37e97b49e4a7f8d34c39fa9360c6600d749842f20',
  };

  // Pick image from gallery
  var imagePicker = ImagePicker();
  var pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

  if (pickedImage != null) {
    var file = File(pickedImage.path);

    try {
      var url = Uri.parse('http://chat.msarweb.net/api/create');

      var request = http.MultipartRequest('POST', url);

      // Add form fields
      request.fields.addAll({
        'name': 'دردشة',
        'category': 'ahmed',
      });

      // Add the image file
      request.files.add(await http.MultipartFile.fromPath('image', file.path));

      // Add headers
      request.headers.addAll(headers);

      var response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print('Image upload failed with status code: ${response.statusCode}');
        // Handle the error
        // ...
      }
    } catch (e) {
      print('Error uploading image: $e');
      // Handle the error
      // ...
    }
  } else {
    print('No image picked');
  }
}

Future uploadImage11({
  required String? pathUrl,
  required File imageFile,
  required token,
  required Map<String, String> data,
}) async {
  if (imageFile == null) {
    return; // No image selected, handle this as per your app requirements.
  }

  var stream = http.ByteStream(imageFile.openRead());
  var length = await imageFile.length();

  var uri = Uri.parse(
      '${ApiPath.BASEURL}${pathUrl}'); // Replace with your server's URL.

  var request = http.MultipartRequest('POST', uri);
  var multipartFile = http.MultipartFile('image', stream, length,
      filename: imageFile.path.split('/').last);

  request.files.add(multipartFile);
  var headers = {
    'token': '$token',
    'Cookie': 'PHPSESSID=jf2kc67ab7oa5gb5rpafg92c7e'
  };
  request.fields.addAll(data);
  print(data);
  request.headers.addAll(headers);

  var response = await request.send();

  var res = await http.Response.fromStream(response);

  if (response.statusCode == 200) {
    // Image uploaded successfully. Handle the server response here.
    // You may get the response using await response.stream.bytesToString()
    print('Image uploaded successfully.');
  } else {
    // Handle error cases here.
    print('Error uploading image.');
  }
  print(res.body);
  return jsonDecode(res.body.toString());
}
