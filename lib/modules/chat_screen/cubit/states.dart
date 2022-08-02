abstract class ChattingStates {}

class InitialChattingState extends ChattingStates {}

class GetMessagesSuccessState extends ChattingStates {}

class SendMessageSuccessState extends ChattingStates {}

class SendMessageErrorState extends ChattingStates {
  String error;
  SendMessageErrorState(this.error);
}
