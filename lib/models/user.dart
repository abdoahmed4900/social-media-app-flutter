class UserModel {
  String? name;
  late String email;
  late String uId;
  late bool isEmailVerified;
  late String notiifcationToken;
  late String? bio;
  late String? phone;
  late String userImage;
  late int yourPostsNumber;
  late String? token;
  late int? following;
  late int? followers;
  late List? followersIds;
  late List? followingIds;
  late List? chats;
  UserModel(
      {this.name,
      this.phone,
      this.token,
      this.userImage = '',
      required this.email,
      required this.uId,
      this.following,
      this.followers,
      this.followersIds,
      this.followingIds,
      this.bio,
      this.chats,
      this.notiifcationToken = '',
      this.yourPostsNumber = 0,
      required this.isEmailVerified});

  UserModel.fromMap(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    following = json['following'] ?? 0;
    followers = json['followers'] ?? 0;
    followersIds = json['followersIds'] ?? [];
    followingIds = json['followingIds'] ?? [];
    uId = json['uId'];
    phone = json['phone'];
    userImage = json['userImage'];
    bio = json['bio'] ?? 'write about yourself';
    isEmailVerified = json['isEmailVerified'];
    yourPostsNumber = json['yourPostsNumber'] ?? 0;
    token = json['token'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uId': uId,
      'followers': followers,
      'followersIds': followersIds,
      'followingIds': followingIds,
      'following': following,
      'bio': bio,
      'token': token,
      'phone': phone,
      'userImage': userImage,
      'isEmailVerified': isEmailVerified,
      'yourPostsNumber': yourPostsNumber
    };
  }
}
