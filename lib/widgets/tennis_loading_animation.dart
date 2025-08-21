import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tennis_training_app/core/app_constants.dart';

class TennisLoadingAnimation extends StatefulWidget {
  const TennisLoadingAnimation({Key? key}) : super(key: key);

  @override
  State<TennisLoadingAnimation> createState() => _TennisLoadingAnimationState();
}

class _TennisLoadingAnimationState extends State<TennisLoadingAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _racketController;
  late final AnimationController _ballController;

  @override
  void initState() {
    super.initState();
    _racketController = AnimationController(vsync: this);
    _ballController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _racketController.dispose();
    _ballController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            AppConstants.racketAnimation,
            controller: _racketController,
            onLoaded: (composition) {
              _racketController
                ..duration = composition.duration
                ..repeat(reverse: true);
            },
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 20),
          Lottie.asset(
            AppConstants.ballAnimation,
            controller: _ballController,
            onLoaded: (composition) {
              _ballController
                ..duration = composition.duration
                ..repeat(reverse: true);
            },
            height: 60,
            width: 60,
          ),
        ],
      ),
    );
  }
}