class PostModel {
  late String post;
  late String? postDateTime;

  late int likes;
  late int commentsNumber;
  late String postId;
  late String userId;
  late List? comments;
  late List? commentsUsersIds;
  late List? postImages;
  late String userName;
  late List? commentsUsersAvatars;
  late List? commentsUsersNames;
  late String userImage;
  late List? likesUsersId;
  late List? likesUserNames;

  PostModel(
      {this.post = '',
      this.postDateTime,
      this.likes = 0,
      this.likesUserNames,
      this.likesUsersId,
      this.commentsNumber = 0,
      required this.userName,
      required this.userImage,
      this.postId = '',
      required this.userId,
      this.comments,
      this.postImages,
      this.commentsUsersAvatars,
      this.commentsUsersNames,
      this.commentsUsersIds});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'post': post,
      'postDateTime': postDateTime ?? '',
      'likes': likes,
      'commentsNumber': commentsNumber,
      'postId': postId,
      'comments': comments,
      'commentsUsersIds': commentsUsersIds ?? [],
      'likesUsersId': likesUsersId,
      'likesUserNames': likesUserNames,
      'postImages': postImages,
      'commentsUsersNames': commentsUsersNames ?? [],
      'commentsUsersAvatars': commentsUsersAvatars ?? [],
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      post: map['post'],
      postDateTime: map['postDateTime'] ?? '',
      commentsNumber: map['commentsNumber'] ?? 0,
      comments: map['comments'] ?? [],
      likesUserNames: map['likesUserNames'] ?? [],
      likesUsersId: map['likesUsersId'] ?? [],
      likes: map['likes'] ?? 0,
      postId: map['postId'],
      userId: map['userId'],
      commentsUsersIds: map['commentsUsersIds'] ?? [],
      commentsUsersAvatars: map['commentsUsersAvatars'] ?? [],
      commentsUsersNames: map['commentsUsersNames'] ?? [],
      postImages: map['postImages'],
      userName: map['userName'],
      userImage: map['userImage'],
    );
  }
}
