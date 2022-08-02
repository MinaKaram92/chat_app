import 'package:flutter/material.dart';
import 'package:free_chat/shared/components/components.dart';
import 'package:free_chat/shared/cubit/cubit.dart';

class EditAboutScreen extends StatelessWidget {
  var aboutController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: goBack(context),
        title: Text('Write about your self'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              defaultTextFormField(
                type: TextInputType.text,
                controller: aboutController,
                autoFocus: true,
                maxLines: 4,
                maxLength: 132,
              ),
              SizedBox(
                height: 20.0,
              ),
              defaultMaterialButton(
                width: 100.0,
                fontSize: 15.0,
                pressed: () {
                  FreeChatCubit.get(context).updateUserData(
                      fieldName: 'about', fieldData: aboutController.text);
                },
                text: 'Update',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
