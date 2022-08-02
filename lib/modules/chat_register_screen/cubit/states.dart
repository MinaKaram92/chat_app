abstract class ChatRegisterStates {}

class InitialChatRegisterState extends ChatRegisterStates {}

class ChangePasswordVisibilityState extends ChatRegisterStates {}

class ChatRegisterUserSuccessState extends ChatRegisterStates {}

class ChatRegisterUserErrorState extends ChatRegisterStates {
  String error;
  ChatRegisterUserErrorState(this.error);
}
