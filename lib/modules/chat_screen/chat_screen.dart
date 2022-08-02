import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_chat/models/user_model.dart';
import 'package:free_chat/modules/chat_screen/cubit/cubit.dart';
import 'package:free_chat/modules/chat_screen/cubit/states.dart';
import 'package:free_chat/shared/components/components.dart';
import 'package:free_chat/shared/components/constants.dart';
import 'package:free_chat/shared/cubit/cubit.dart';
import 'package:free_chat/shared/cubit/states.dart';

class ChatScreen extends StatelessWidget {
  UserModel userModel;
  ChatScreen(this.userModel);
  TextEditingController messageController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String time() {
    return DateTime.now().toString();
  }

  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Builder(builder: (context) {
      messageController.clear();
      return BlocProvider(
        create: (context) =>
            ChattingCubit()..getUserMessages(userId: userModel.uId!),
        child: BlocConsumer<ChattingCubit, ChattingStates>(
          listener: (context, state) {},
          builder: (context, state) {
            ChattingCubit cubit = ChattingCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                shadowColor: Colors.cyan,
                backgroundColor: Colors.white,
                leading: goBack(context),
                elevation: 0.0,
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 26.0,
                      backgroundImage: NetworkImage('${userModel.image}'),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      '${userModel.name}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                if (cubit.messages[index].senderId ==
                                    currentUserId) {
                                  return buildSenderMessage(
                                      context, cubit.messages[index].message!);
                                }
                                return buildRecieverMessage(
                                    context, cubit.messages[index].message!);
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10.0,
                              ),
                              itemCount: cubit.messages.length,
                            ),
                          ),
                          /* SizedBox(
                            height: 20.0,
                          ), */
                        ],
                      ),
                    ),
                    Material(
                      elevation: 10.0,
                      child: Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyan.shade100,
                              // offset: Offset(0.0, 0.0),
                              blurRadius: 6.0,
                            ),
                          ],
                          border: Border.all(
                            color: Colors.cyan.shade200,
                            width: 2.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: defaultTextFormField(
                                  type: TextInputType.text,
                                  controller: messageController,
                                  hint: 'Send Message',
                                  border: InputBorder.none,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return '';
                                    }
                                  }),
                            ),
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.cyan,
                              child: IconButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.sendMessage(
                                      dateTime: time(),
                                      message: messageController.text,
                                      receiverId: userModel.uId!,
                                    );
                                  }
                                  messageController.clear();
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget buildRecieverMessage(context, String message) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 3 / 4,
        ),
        decoration: BoxDecoration(
          color: Colors.cyan.shade200,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            message,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  Widget buildSenderMessage(context, String message) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 3 / 4,
        ),
        decoration: BoxDecoration(
          color: Colors.cyan.shade200,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            message,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
