import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {
  final VoidCallback onTap;
  final Color btnColor;
  final Color btnTitleColor;
  final String buttonTitle;
  final double height;
  final double width;

  StaggerAnimation(
      {Key key,
      this.buttonController,
      this.onTap,
      this.btnColor,
      this.btnTitleColor,
      this.height = 48,
      this.width,
      this.buttonTitle = 'Sign In'})
      : buttonSqueezeanimation = Tween(
          begin: 320.0,
          end: 50.0,
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(
              0.0,
              0.150,
            ),
          ),
        ),
        containerCircleAnimation = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 30.0),
          end: const EdgeInsets.only(bottom: 0.0),
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: const Interval(
              0.500,
              0.800,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final AnimationController buttonController;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeanimation;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return GestureDetector(
      onTap: () {
        if (!buttonController.isAnimating) {
          onTap();
        }
      },
      child: Container(
          width: width ?? kScreenSizeWidth,
          height: height,
          alignment: FractionalOffset.center,
          decoration: kButton.copyWith(
              borderRadius: BorderRadius.circular(12), color: btnColor),
          child: buttonSqueezeanimation.value > 75.0
              ? Text(
                  buttonTitle,
                  style: kBaseTextStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: btnTitleColor ?? Colors.white),
                )
              : const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    value: null,
                    strokeWidth: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}
