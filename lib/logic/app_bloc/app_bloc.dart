// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:io';

import 'package:chat_app/cache/cache_helper/cache_helper.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/constants/methods.dart';
import 'package:chat_app/logic/firebase_helper/firebase_helper.dart';
import 'package:chat_app/models/post.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/view/screens/bottom_nav_screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/message.dart';
import '../../view/screens/bottom_nav_screens/home_screen.dart';
import '../../view/screens/bottom_nav_screens/messages_screen.dart';
import '../../view/screens/bottom_nav_screens/post_screen.dart';
import '../notifications_helper/notifications_helper.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(context) : super(AppInitial()) {
    userModel = null;
    on<AppEvent>((event, emit) {
      if (event is AppLogOut) {
        emit(AppLoggedOut());
      } else if (event is ChangePasswordIcon) {
        emit(AppPasswordChangeIcon());
      } else if (event is ChangeBottomNavIndex) {
        emit(AppBottomNavIndexChanged());
      } else if (event is AppLoad) {
        emit(AppLoading());
      } else if (event is VerifyEmail) {
        emit(AppEmailVerified());
      } else if (event is AppLogin) {
        emit(AppLoggedIn());
      } else if (event is ChangeProfilePhoto) {
        emit(AppChangeProfilePhoto());
      } else if (event is EditProfile) {
        emit(AppEditProfile());
      } else if (event is AddPost) {
        emit(PostAdded());
      } else if (event is RemovePost) {
        emit(PostRemoved());
      } else if (event is FetchPosts) {
        emit(PostsFetched());
      } else if (event is AddComment) {
        emit(CommentAdded());
      } else if (event is AddPostPhoto) {
        emit(PostPhotoAdded());
      } else if (event is LikePost) {
        emit(PostLiked());
      } else if (event is SearchUser) {
        emit(UserSearched());
      } else if (event is FollowUser) {
        emit(UserFollowed());
      } else if (event is SendMessage) {
        emit(MessageSent());
      } else if (event is SendPhoto) {
        emit(PhotoSent());
      }
    });
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }

  final storageRef = FirebaseStorage.instance.ref();

  final usersCollection = FirebaseFirestore.instance.collection('users');

  final postsCollection = FirebaseFirestore.instance.collection('posts');

  Timer? timer;

  List<PostModel> posts = [];

  List<String> pickedPostImages = [];

  List<UserModel> searchResults = [];

  void getUserData(context) async {
    add(AppLoad());
    if (uId.isNotEmpty) {
      usersCollection.doc(uId).get().then((value) async {
        Map<String, dynamic> map = value.data()!;
        userModel = UserModel.fromMap(map);
        NotificationsHelper.getToken();
        NotificationsHelper.initNotificationSettings(context);

        add(AppLogin());

        bool? isEmailVerfiedBefore =
            CacheHelper.getBoolean('isEmailVerfiedBefore');

        if (!isEmailVerfiedBefore!) {
          timer = Timer.periodic(Duration(seconds: 3), ((timer) async {
            isEmailVerified();
          }));
        }
      }).catchError((e) {
        errorToast(error: e.toString());
      });
    }
  }

  void editProfile(
      {required String name,
      required String phone,
      required String bio,
      context}) async {
    usersCollection
        .doc(uId)
        .update({'name': name, 'phone': phone, 'bio': bio}).then((value) async {
      userModel!.name = name;
      userModel!.bio = bio;
      userModel!.phone = phone;
      add(EditProfile());

      final data = await postsCollection.get();

      updatePostsUserName(data, name, this);
      Navigator.pop(context);
    }).catchError((error) {
      errorToast(error: error.toString());
    });
  }

  List<Widget> screens = [
    HomeScreen(),
    MessagesScreen(),
    PostScreen(),
    ProfileScreen()
  ];

  late UserModel? userModel;

  static AppBloc get(context) => BlocProvider.of(context);

  Future verifyEmail() async {
    FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value) {
      successToast(message: 'Check Your Email');
    }).catchError((error) {
      errorToast(error: error);
    });

    await Future.delayed(Duration(seconds: 10));

    usersCollection.doc(uId).get().then((value) {
      Map<String, dynamic>? map = value.data();
      userModel = UserModel.fromMap(map!);
    });
  }

  bool isPassword = true;

  IconData passwordIcon = Icons.visibility;

  int bottomNavIndex = 0;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    passwordIcon = isPassword ? Icons.visibility : Icons.visibility_off;
    add(ChangePasswordIcon());
  }

  void changeBottomNavIndex(int index, context) {
    if (index != 2) {
      bottomNavIndex = index;
      add(ChangeBottomNavIndex());
    } else {
      push(PostScreen(), context);
    }
  }

  Future isEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    if (FirebaseAuth.instance.currentUser!.emailVerified &&
        !CacheHelper.getBoolean('isEmailVerfiedBefore')! &&
        uId.isNotEmpty) {
      userModel!.isEmailVerified = true;
      usersCollection.doc(uId).update({'isEmailVerified': true}).then((value) {
        timer!.cancel();
        CacheHelper.setBoolean('isEmailVerfiedBefore', true);
        add(VerifyEmail());
        FirebaseHelper.getPostsAfterData(this);

        showToast(
            message: 'Your Email is verified!',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.green);
      });
    }
  }

  Stream get postsStream => postsCollection.snapshots();

  Future postWithoutImage({required String post}) async {
    PostModel model = PostModel(
        post: post,
        userImage: userModel!.userImage,
        userName: userModel!.name!,
        userId: userModel!.uId,
        comments: [],
        postImages: [],
        commentsUsersAvatars: [],
        commentsUsersIds: [],
        commentsUsersNames: []);

    await postsCollection.add(model.toMap()).then((value) async {
      model.postId = value.id;
      postsCollection.doc(model.postId).update(
        {'postId': model.postId},
      );
    });

    usersCollection
        .doc(uId)
        .update({'yourPostsNumber': ++userModel!.yourPostsNumber});

    add(AddPost());
  }

  Future postWithImage({required String post}) async {
    PostModel model = PostModel(
        post: post,
        userImage: userModel!.userImage,
        userName: userModel!.name!,
        userId: userModel!.uId,
        comments: [],
        postImages: [],
        commentsNumber: 0,
        commentsUsersAvatars: [],
        commentsUsersIds: [],
        commentsUsersNames: []);

    return postsCollection.add(model.toMap()).then((value) async {
      model.postId = value.id;
      for (int i = 0; i < pickedPostImages.length; i++) {
        storageRef
            .child('images/posts/${value.id}/${i + 1}')
            .putFile(File(pickedPostImages[i]))
            .then((p0) {
          p0.ref.getDownloadURL().then((value) {
            add(AddPost());
            model.postImages!.add(value);
            FirebaseFirestore.instance
                .collection('posts')
                .doc(model.postId)
                .update(model.toMap());
          });
        });
      }

      postsCollection.doc(model.postId).update(model.toMap());

      add(AddPost());
    });
  }

  Future removePost({required String postId, required int index}) async {
    add(RemovePost());
    await postsCollection.doc(postId).delete();

    await usersCollection.doc(uId).update({
      'yourPostsNumber':
          userModel!.yourPostsNumber == 0 ? 0 : --userModel!.yourPostsNumber
    });
  }

  void addComment(postId, index, String comment) async {
    final data = await postsCollection.doc(postId).get();

    PostModel post = PostModel.fromMap(data.data()!);

    post.comments!.add(comment);
    post.commentsUsersAvatars!.add(userModel!.userImage);

    post.commentsUsersNames!.add(userModel!.name);

    post.commentsUsersIds!.add(userModel!.uId);

    post.commentsNumber++;

    postsCollection.doc(postId).update(post.toMap()).then((value) {
      add(AddComment());
    });
  }

  void likePost(index, postId) async {
    postsCollection.doc(postId).get().then((value) {
      PostModel model = PostModel.fromMap(value.data()!);
      if (model.likesUsersId!.contains(uId)) {
        removeLike(model);
      } else {
        addLike(model);
      }
      postsCollection.doc(model.postId).update(model.toMap());
    });
  }

  void sendMessage(
      {required String message, required String receiverId}) async {
    final otherUserData = await usersCollection.doc(receiverId).get();

    UserModel otherUser = UserModel.fromMap(otherUserData.data()!);

    MessageModel model = MessageModel(
        message: message,
        dateTime: DateTime.now().toString(),
        senderId: uId,
        receiverId: receiverId,
        receiverName: otherUser.name!);

    usersCollection
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap());

    if (uId != model.receiverId) {
      usersCollection
          .doc(receiverId)
          .collection('chats')
          .doc(uId)
          .collection('messages')
          .add(model.toMap());
    }
  }

  void sendPhoto({required String receiverId, required String source}) async {
    final otherUserData = await usersCollection.doc(receiverId).get();

    UserModel otherUser = UserModel.fromMap(otherUserData.data()!);

    List pickedPhotos = await pickMessagePhoto(source);

    MessageModel model = MessageModel(
        dateTime: DateTime.now().toString(),
        photos: [],
        senderId: uId,
        receiverId: receiverId,
        receiverName: otherUser.name!);

    usersCollection
        .doc(receiverId)
        .collection('chats')
        .doc(uId)
        .collection('messages')
        .add(model.toMap());

    usersCollection
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      for (int i = 0; i < pickedPhotos.length; i++) {
        add(AppLoad());
        storageRef
            .child('images/messages/${value.id}/$i')
            .putFile(File(pickedPhotos[i]))
            .then((p0) {
          p0.ref.getDownloadURL().then((link) {
            model.photos!.add(link);
            usersCollection
                .doc(uId)
                .collection('chats')
                .doc(receiverId)
                .collection('messages')
                .doc(value.id)
                .update(model.toMap());
            usersCollection
                .doc(receiverId)
                .collection('chats')
                .doc(uId)
                .collection('messages')
                .doc(value.id)
                .set(model.toMap());
          });
        });
        add(SendPhoto());
      }
    });
  }
}
