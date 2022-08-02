abstract class ChatLoginStates {}

class InitialChatLoginState extends ChatLoginStates {}

class ChangePasswordVisibilityState extends ChatLoginStates {}

class ChatLoginSuccessState extends ChatLoginStates {
  String userId;
  ChatLoginSuccessState(this.userId);
}

class ChatLoginErrorState extends ChatLoginStates {
  String error;
  ChatLoginErrorState(this.error);
}
