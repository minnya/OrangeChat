
import 'package:orange_chat/components/profile/input_image.dart';
import 'package:orange_chat/components/commons/input_place.dart';
import 'package:orange_chat/components/profile/input_gender.dart';
import 'package:orange_chat/components/profile/input_age.dart';
import 'package:orange_chat/helpers/auth_helper.dart';
import 'package:orange_chat/helpers/supabase/storage_helper.dart';
import 'package:flutter/material.dart';

import '../../helpers/supabase/user_model_helper.dart';
import '../../models/supabase/edit_users.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late EditUserModel editUserModel;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser()async{
    setState(() {
      isLoading = true;
    });
    editUserModel = (await UserModelHelper().get(AuthHelper().getUID()))
        .toEditModel();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          TextButton(
              onPressed: () async {
                // 画像を先にstorageにアップロードする
                if (editUserModel.uploadFile != null) {
                  editUserModel.iconUrl = await StorageHelper()
                      .uploadFile(file: editUserModel.uploadFile!, context: context);
                }
                await UserModelHelper(context: context).update(editUserModel.toUserModel());
                Navigator.pop(context);
              },
              child: const Text("Save")),
        ],
      ),
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight, maxWidth: 600),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      children: [
                        InputImage(
                          editUserModel: editUserModel,
                        ),
                        Form(
                          autovalidateMode: AutovalidateMode.always,
                          child: Column(
                            children: [
                              TextFormField(
                                initialValue: editUserModel.name,
                                maxLength: 20,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  counterText: ""
                                ),
                                validator: (value){
                                  if(value==null || value.isEmpty){
                                    return "Username cannot be blank";
                                  }
                                  editUserModel.name = value;
                                  return null;
                                },
                              ),
                              SizedBox(height: 12,),
                              InputGender(
                                editUserModel: editUserModel,
                              ),
                              SizedBox(height: 12,),
                              InputAge(
                                editUserModel: editUserModel,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12,),
                        InputPlace(
                          isState: false,
                          placeModel: editUserModel.placeModel,
                        ),
                        SizedBox(height: 12,),
                        InputPlace(
                          isState: true,
                          placeModel: editUserModel.placeModel,
                        ),
                        SizedBox(height: 12,),
                        Form(
                          autovalidateMode: AutovalidateMode.always,
                          child: TextFormField(
                            initialValue: editUserModel.description,
                            keyboardType: TextInputType.multiline,
                            maxLength: 200,
                            maxLines: 10,
                            minLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'About Me',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                            validator: (value){
                              editUserModel.description = value;
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
