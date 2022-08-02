abstract class FreeChatStates {}

class InitialFreeChatState extends FreeChatStates {}

class ChangeBottomNavBarStatus extends FreeChatStates {}

class GetUserDataSuccessState extends FreeChatStates {}

class GetUserDataErrorState extends FreeChatStates {
  String error;
  GetUserDataErrorState(this.error);
}

class UpdateUserDataSuccessState extends FreeChatStates {}

class UpdateUserDataErrorState extends FreeChatStates {
  String error;
  UpdateUserDataErrorState(this.error);
}

class UserDataUpdatedSuccessState extends FreeChatStates {
  String fieldName;
  UserDataUpdatedSuccessState(this.fieldName);
}

class UserDataUpdatedErrorState extends FreeChatStates {
  String error;
  UserDataUpdatedErrorState(this.error);
}

class EmailUpdatedSuccessState extends FreeChatStates {}

class EmailUpdatedErrorState extends FreeChatStates {
  String error;
  EmailUpdatedErrorState(this.error);
}

class GetAllUserSuccessState extends FreeChatStates {}

class GetAllUserErrorState extends FreeChatStates {
  String error;
  GetAllUserErrorState(this.error);
}

class DeleteUserDataSuccessState extends FreeChatStates {}

class DeleteUserDataErrorState extends FreeChatStates {
  String error;
  DeleteUserDataErrorState(this.error);
}

class GetProfilePhotoSuccessState extends FreeChatStates {}

class CnacelProfilePhotoUpdateState extends FreeChatStates {}

class UploadingProfileImageSuccessState extends FreeChatStates {}

class UploadingProfileImageErrorState extends FreeChatStates {
  String error;
  UploadingProfileImageErrorState(this.error);
}
