import 'package:flutter/material.dart';

class MentionedScreen extends StatefulWidget{
  const MentionedScreen({super.key});


  @override
  State<MentionedScreen> createState() => _MentionedScreenState();
}

class _MentionedScreenState extends State<MentionedScreen> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text("Coming Soon"),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}