import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_chat/models/user_model.dart';
import 'package:free_chat/modules/chat_screen/chat_screen.dart';
import 'package:free_chat/shared/components/components.dart';
import 'package:free_chat/shared/components/constants.dart';
import 'package:free_chat/shared/cubit/cubit.dart';
import 'package:free_chat/shared/cubit/states.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('user id from users screen: $currentUserId');
    return BlocConsumer<FreeChatCubit, FreeChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        FreeChatCubit cubit = FreeChatCubit.get(context);
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return buildChatHead(context, cubit.allUsers[index]);
                },
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.black,
                  ),
                ),
                itemCount: cubit.allUsers.length,
              ),
            )
          ],
        );
      },
    );
  }

  Widget buildChatHead(context, UserModel userModel) {
    return InkWell(
      onTap: () {
        navigateTo(context, ChatScreen(userModel));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundImage: NetworkImage('${userModel.image}'),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${userModel.name}',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
