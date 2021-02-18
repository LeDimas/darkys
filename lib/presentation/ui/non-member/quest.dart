import 'package:darky_app/presentation/ui/non-member/loginPage.dart';
import 'package:darky_app/presentation/ui/non-member/info.dart';
import 'package:flutter/material.dart';

class QuestPageView extends StatefulWidget {
  QuestPageView({Key key}) : super(key: key);

  @override
  _QuestPageViewState createState() => _QuestPageViewState();
}

class _QuestPageViewState extends State<QuestPageView> {
  PageController _pageController = PageController(initialPage: 0);

  //TODO TO MAKE MAIL WORK U NEED A WORKING SMTP SERVER OR SERVICE PROVIDER,AND I SUPPOSE THAT
  //AS YOU GOING TO USE PRIVATE BUISENESS MAIL, U WILL NEED TO SPECIFY YOUR OWN SMTTP FIRST
  //
  //
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [InfoPage(), LoginPage()],
    );
  }
}
