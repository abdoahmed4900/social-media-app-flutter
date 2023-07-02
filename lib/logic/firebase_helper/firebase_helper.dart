import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/constants.dart';
import '../../constants/methods.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../app_bloc/app_bloc.dart';

class FirebaseHelper {
  // get posts
  static void getPostsAfterData(AppBloc bloc) async {
    final data = await bloc.postsCollection.get();

    for (var element in data.docs) {
      PostModel model = PostModel.fromMap(element.data());
      if (model.userId == uId) {
        bloc.userModel!.yourPostsNumber++;
      }
    }

    bloc.usersCollection
        .doc(uId)
        .update({'yourPostsNumber': bloc.userModel!.yourPostsNumber});

    bloc.add(FetchPosts());
  }

  // updates your posts user avatar after changing profile image
  static void updatePostsImage(
      QuerySnapshot<Map<String, dynamic>> data, String value, AppBloc bloc) {
    for (var element in data.docs) {
      PostModel model = PostModel.fromMap(element.data());
      if (model.userId == uId) {
        model.userImage = value;
        bloc.add(EditProfile());
      }
      for (int i = 0; i < model.commentsNumber; i++) {
        if (model.commentsUsersIds![i] == uId) {
          model.commentsUsersAvatars![i] = value;
        }
      }

      bloc.postsCollection.doc(model.postId).update(model.toMap());
    }
  }

  // upload profile image to firebase storage

  static void uploadProfileImage(File file, AppBloc bloc) {
    bloc.storageRef
        .child('images/$uId/storageImage.jpg')
        .putFile(file)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) async {
        bloc.add(AddPostPhoto());
        bloc.userModel!.userImage = value;
        bloc.usersCollection.doc(uId).update({'userImage': value});
        final data = await bloc.postsCollection.get();
        FirebaseHelper.updatePostsImage(data, value, bloc);
      });
    });
  }

  // follow user
  static void followUser(String userId, AppBloc bloc) async {
    final data = await bloc.usersCollection.doc(userId).get();
    UserModel otherUser = UserModel.fromMap(data.data()!);
    if (bloc.userModel!.followingIds!.contains(userId)) {
      removeUserFromFollowing(bloc, userId, otherUser);
    } else {
      addUserToFollowing(bloc, userId, otherUser);
    }
    bloc.usersCollection.doc(uId).update(bloc.userModel!.toMap());

    bloc.usersCollection.doc(userId).update(otherUser.toMap());

    bloc.add(FollowUser());
  }

  // search user
  static void searchUser(
      {required String userName, required AppBloc bloc}) async {
    bloc.searchResults.clear();
    bloc.add(AppLoad());
    final users = await bloc.usersCollection.get();

    for (var element in users.docs) {
      UserModel model = UserModel.fromMap(element.data());
      if (model.name!.startsWith(userName)) {
        bloc.searchResults.add(model);
        bloc.add(SearchUser());
      }
    }
  }
}
