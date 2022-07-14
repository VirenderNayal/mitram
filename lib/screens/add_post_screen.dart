import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mitram/models/users.dart' as model;
import 'package:mitram/providers/user_provider.dart';
import 'package:mitram/resources/firestore_methods.dart';
import 'package:mitram/utils/colors.dart';
import 'package:mitram/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  void postImage(String uid, String username, String profilePicUrl) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _file!,
        _descriptionController.text,
        uid,
        username,
        profilePicUrl,
      );

      if (res == 'success') {
        showSnackBar("Post uploaded successfully.", context);
        clearPost();
      } else {
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a Post"),
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
                padding: const EdgeInsets.all(20),
                child: const Text("Click Picture"),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from Device"),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
              ),
            ],
          );
        });
  }

  void clearPost() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: blueColor,
              ),
              child: IconButton(
                onPressed: () => _selectImage(context),
                padding: const EdgeInsets.all(50),
                iconSize: 50,
                icon: const Icon(Icons.upload),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text("New Post"),
              leading: IconButton(
                onPressed: clearPost,
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      postImage(user.uid, user.username, user.profilePicUrl),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      color: blueColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(padding: EdgeInsets.only(top: 0)),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.69,
                        child: TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: "Write a caption..",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: secondaryColor)),
                          ),
                          maxLines: 6,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
