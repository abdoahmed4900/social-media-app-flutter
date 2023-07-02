part of 'app_bloc.dart';

@immutable
abstract class AppEvent {}

class AppLogOut extends AppEvent {}

class AppLogin extends AppEvent {}

class AppLoad extends AppEvent {}

class ChangePasswordIcon extends AppEvent {}

class ChangeBottomNavIndex extends AppEvent {}

class VerifyEmail extends AppEvent {}

class ChangeProfilePhoto extends AppEvent {}

class EditProfile extends AppEvent {}

class AddPost extends AppEvent {}

class RemovePost extends AppEvent {}

class FetchPosts extends AppEvent {}

class AddComment extends AppEvent {}

class AddPostPhoto extends AppEvent {}

class LikePost extends AppEvent {}

class SearchUser extends AppEvent {}

class FollowUser extends AppEvent {}

class SendMessage extends AppEvent {}

class SendPhoto extends AppEvent {}
