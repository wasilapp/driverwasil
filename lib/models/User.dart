

import 'package:DeliveryBoyApp/utils/TextUtils.dart';

class User{

  int id;
  String? name,email,avatarUrl,mobile;

  User(this.id,this.name, this.email,this.avatarUrl,this.mobile);

  static User fromJson(Map<String, dynamic> jsonObject) {



    int id = int.parse(jsonObject['id'].toString());
    String? mobile=jsonObject['mobile'];
    String? name = jsonObject['name'].toString();
    String? email = jsonObject['email'].toString();
    String? avatarUrl = jsonObject['avatar_url'].toString();

    return User(id,name, email, avatarUrl,mobile);
  }

  static List<User> getListFromJson(List<dynamic> jsonArray) {
    List<User> list = [];
    for (int i = 0; i < jsonArray.length; i++) {
      list.add(User.fromJson(jsonArray[i]));
    }
    return list;
  }


  @override
  String toString() {
    return 'User{id: $id, mobile: $mobile, name: $name, email: $email}';
  }

  getAvatarUrl(){
    return TextUtils.getImageUrl(avatarUrl);
  }

}