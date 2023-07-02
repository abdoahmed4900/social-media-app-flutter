part of 'app_bloc.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class AppLoggedOut extends AppState {}

class AppLoading extends AppState {}

class AppLoggedIn extends AppState {}

class AppEmailVerified extends AppState {}

class AppPasswordChangeIcon extends AppState {}

class AppBottomNavIndexChanged extends AppState {}

class AppChangeProfilePhoto extends AppState {}

class AppEditProfile extends AppState {}

class PostAdded extends AppState {}

class PostRemoved extends AppState {}

class PostsFetched extends AppState {}

class CommentAdded extends AppState {}

class PostPhotoAdded extends AppState {}

class PostLiked extends AppState {}

class UserSearched extends AppState {}

class UserFollowed extends AppState {}

class MessageSent extends AppState {}

class PhotoSent extends AppState {}
