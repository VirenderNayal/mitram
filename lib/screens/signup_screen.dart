import 'dart:typed_data';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:mitram/resources/auth_method.dart';
import 'package:mitram/utils/colors.dart';
import 'package:mitram/utils/utils.dart';
import 'package:mitram/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  void selectImage() async {
    Uint8List imageFromDevice = await pickImage(ImageSource.gallery);
    setState(() {
      _image = imageFromDevice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/mitram_logo.png',
                height: 200,
              ),
              const SizedBox(height: 40),

              // User Avatar
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                              "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1374&q=80"),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Field for Email
              TextFieldInput(
                textEditingController: _emailController,
                hintText: "Email",
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Field for Full Name
              TextFieldInput(
                textEditingController: _fullNameController,
                hintText: "Full Name",
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 20),

              // Field for Username
              TextFieldInput(
                textEditingController: _usernameController,
                hintText: "Username",
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 20),

              // Field for Password
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: "Password",
                textInputType: TextInputType.text,
                isObscureText: true,
              ),
              const SizedBox(height: 20),

              // Signup Button
              InkWell(
                onTap: () async {
                  String res = await AuthMethods().signUpUser(
                    email: _emailController.text,
                    password: _passwordController.text,
                    username: _usernameController.text,
                    fullName: _fullNameController.text,
                    file: _image!,
                  );

                  print(res);
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                  child: const Text("Sign Up"),
                ),
              ),
              const SizedBox(height: 20),

              Flexible(flex: 2, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
