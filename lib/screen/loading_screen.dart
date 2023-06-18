import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    getLoadingWidget() {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        return const CupertinoActivityIndicator();
      } else {
        return const CircularProgressIndicator();
      }
    }

    return Scaffold(
      body: Center(
        child: getLoadingWidget(),
      ),
    );
  }
}
