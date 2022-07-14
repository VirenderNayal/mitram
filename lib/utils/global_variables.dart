import 'package:flutter/material.dart';
import 'package:mitram/screens/add_post_screen.dart';
import 'package:mitram/screens/feed_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  Center(child: Text("search")),
  AddPostScreen(),
  Center(child: Text("notification")),
  Center(child: Text("profile")),
];
