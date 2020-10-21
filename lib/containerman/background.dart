import 'dart:ui';

import 'package:containerman/containerman/settings.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Background extends Component {
  Sprite sprite = Sprite("factory.png");

  double tileSize;
  double borderWidth;
  double fieldWidth;
  double fieldHeight;

  @override
  void render(Canvas c) {
    sprite.renderRect(
      c,
      Rect.fromLTWH(
        borderWidth,
        0,
        fieldWidth,
        fieldHeight,
      ),
    );
  }

  @override
  void update(double t) {}

  @override
  void resize(Size size) {
    tileSize = size.height / Settings.TILES_IN_HEIGHT;
    fieldWidth = Settings.TILES_IN_WIDTH * tileSize;
    fieldHeight = size.height;
    borderWidth = (size.width - fieldWidth) / 2;
  }
}
