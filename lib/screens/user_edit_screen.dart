import 'dart:io';

import "package:flutter/material.dart";
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:todonick/providers/todo_user_provider.dart';
import 'package:todonick/providers/view_state_provider.dart';

class UserEditScreen extends StatefulWidget {
  static const String routeName = "/user-edit-screen";

  @override
  _UserEditScreenState createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  TextEditingController _nameController;
  File _profileImage;

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> pickProfileImage() async {
    try {
      final File imageFile =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: imageFile.path,
          maxWidth: 100,
          maxHeight: 100,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

      setState(() {
        _profileImage = croppedFile;
      });
    } catch (error) {
      print('profile image picking failed');
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TodoUserProvider todoUserProvider =
        Provider.of<TodoUserProvider>(context, listen: true);
    final String userName = todoUserProvider?.user?.name ?? "";
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: Theme.of(context)
            .textTheme
            .copyWith(title: TextStyle(color: Colors.black, fontSize: 16)),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Edit Profile"),
        actions: <Widget>[
          Builder(builder: (ctx) {
            return IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                final newName = _nameController.text;
                if (newName.isEmpty) return;
                final imageName = "profile-image-${todoUserProvider.user.id}";
                final response = await todoUserProvider.updateUser(
                    name: newName,
                    profileImageName: imageName,
                    profileImageFile: _profileImage);
                if (response.error) {
                  Scaffold.of(ctx).showSnackBar(SnackBar(
                    content: Text(response.message),
                  ));
                } else {
                  _nameController.clear();
                  _nameController.dispose();
                  Navigator.pop(context);
                }
              },
            );
          })
        ],
      ),
      body: todoUserProvider.state == ViewState.loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Divider(
                  height: 1,
                ),
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    controller: _nameController
                      ..text = userName
                      ..selection =
                          TextSelection.collapsed(offset: userName.length),
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: "Your Name", border: InputBorder.none),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 200,
                  decoration: BoxDecoration(border: Border.all()),
                  child: Center(
                    child: _profileImage == null
                        ? Text("Upload profile image")
                        : Image.file(
                            _profileImage,
                            fit: BoxFit.none,
                          ),
                  ),
                ),
                RaisedButton.icon(
                    onPressed: pickProfileImage,
                    icon: Icon(Icons.camera),
                    label: Text("Upload"))
              ],
            ),
    );
  }
}
