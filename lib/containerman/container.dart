import 'dart:ui';

import 'package:containerman/containerman/containerman.dart';
import 'package:containerman/containerman/containerspawner.dart';
import 'package:containerman/containerman/settings.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Container extends Component {
  double x;
  double y;
  double width;
  double height;

  double tileSize;
  double fieldWidth;
  double fieldHeight;
  double borderWidth;

  bool landed = false;
  Paint paint = Paint()..color = Colors.red;
  static const fallSpeed = 100;
  int destiny;
  ContainerManager containerSpawner;
  Sprite sprite = Sprite("container.png");
  Containerman containerman;

  Container(
    this.x,
    this.y,
    this.destiny,
    this.containerSpawner,
    this.containerman,
  );

  @override
  void render(Canvas c) {
    sprite.renderRect(c, Rect.fromLTWH(borderWidth + x, y, width, height));
  }

  @override
  void update(double dt) {
    if (!landed) {
      y += fallSpeed * dt;
      if (y >= destiny * tileSize) {
        y = destiny * tileSize;
        landed = true;
        containerSpawner.onContainerLanded(this);
      }
    }
  }

  @override
  void resize(Size size) {
    tileSize = size.height / Settings.TILES_IN_HEIGHT;
    width = tileSize;
    height = tileSize;
    fieldWidth = Settings.TILES_IN_WIDTH * tileSize;
    fieldHeight = size.height;
    borderWidth = (size.width - fieldWidth) / 2;
  }
}
