import 'package:flutter/material.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/widgets/customWidgets.dart';

class StaggerAnimation extends StatelessWidget {
  final VoidCallback onTap;
  final Color btnColor;
  final Color btnTitleColor;
  final String buttonTitle;
  final double height;

  StaggerAnimation(
      {Key key,
      this.buttonController,
      this.onTap,
      this.btnColor,
      this.btnTitleColor,
      this.height = 40,
      this.buttonTitle = "Sign In"})
      : buttonSqueezeanimation = new Tween(
          begin: 320.0,
          end: 50.0,
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.0,
              0.150,
            ),
          ),
        ),
        containerCircleAnimation = new EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 30.0),
          end: const EdgeInsets.only(bottom: 0.0),
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
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
    return new GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
          width: kScreenSizeWidth,
          height: height,
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
            color: btnColor == null ? Theme.of(context).buttonColor : btnColor,
            borderRadius: BorderRadius.all(const Radius.circular(25.0)),
          ),
          child: buttonSqueezeanimation.value > 75.0
              ? new DynamicText(
                  buttonTitle,
                  style: kBaseTextStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color:
                          btnTitleColor == null ? Colors.white : btnTitleColor),
                )
              : CircularProgressIndicator(
                  value: null,
                  strokeWidth: 1.0,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}
