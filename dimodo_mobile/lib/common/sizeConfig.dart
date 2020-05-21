//make it a singleton.
class SizeConfig {
  double screenWidth;
  double screenHeight;
  double textMultiplier;
  double containerMultiplier;
  double heightDifferences;
  double widthDifferences;
  static double baseWidth = 375;
  static double baseHeight = 667;

  SizeConfig(screenSize) {
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    heightDifferences = screenHeight / baseHeight;
    widthDifferences = screenWidth / baseWidth;

    if (widthDifferences > 1.1) {
      widthDifferences = widthDifferences * 0.9;
    }

    if (heightDifferences > 1.1) {
      heightDifferences = heightDifferences * 0.9;
    }

    textMultiplier = widthDifferences * heightDifferences;
    containerMultiplier = widthDifferences;
  }
}
