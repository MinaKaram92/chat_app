import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_chat/models/message_model.dart';
import 'package:free_chat/modules/chat_screen/cubit/states.dart';
import 'package:free_chat/shared/components/constants.dart';

class ChattingCubit extends Cubit<ChattingStates> {
  ChattingCubit() : super(InitialChattingState());
  static ChattingCubit get(context) => BlocProvider.of(context);

  List<MessageModel> messages = [];

  void getUserMessages({required String userId}) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(GetMessagesSuccessState());
    });
  }

  void sendMessage({
    required String message,
    required String receiverId,
    required String dateTime,
  }) {
    MessageModel messageModel = MessageModel(
      dateTime: dateTime,
      message: message,
      receiverId: receiverId,
      senderId: currentUserId,
    );
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState(error.toString()));
    });

    FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverId)
        .collection('chats')
        .doc(currentUserId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState(error.toString()));
    });
  }
}
