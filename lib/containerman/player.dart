import 'dart:math';
import 'dart:ui';

import 'package:containerman/containerman/settings.dart';
import 'package:containerman/containerman/util.dart';
import 'package:flame/animation.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/joystick/joystick_component.dart';
import 'package:flame/components/joystick/joystick_events.dart';
import 'package:flame/sprite_batch.dart';
import 'package:flutter/material.dart' as Flutter;

enum Direction {
  LEFT,
  RIGHT
}

class Player extends Component implements JoystickListener {
  double x = 0;
  double y = 0;
  double width = 0;
  double height = 0;
  double tileSize;
  Direction facing = Direction.LEFT;

  Animation leftIdleAnimation = Animation.sequenced(
    "idle_left.png",
    11,
    amountPerRow: 11,
    textureWidth: 28,
    textureHeight: 34,
    stepTime: 0.25,
  );

  Animation rightIdleAnimation = Animation.sequenced(
    "idle_right.png",
    11,
    amountPerRow: 11,
    textureWidth: 28,
    textureHeight: 34,
    stepTime: 0.075,
  );

  Animation jumpAnimation = Animation.sequenced(
    "jump.png",
    8,
    amountPerRow: 8,
    textureWidth: 37,
    textureHeight: 34,
    stepTime: 0.1,
  );

  Animation leftPushAnimation;
  Animation rightPushAnimation;

  Animation leftWalkAnimation = Animation.sequenced(
    "walk_left.png",
    33,
    amountPerRow: 33,
    textureWidth: 28,
    textureHeight: 34,
    stepTime: 1,
  );

  Animation rightWalkAnimation;

  Animation currentAnimation = Animation.sequenced(
    "walk_left.png",
    33,
    amountPerRow: 33,
    textureWidth: 28,
    textureHeight: 34,
    stepTime: 0.15,
  );

  // https://www.youtube.com/watch?v=PlT44xr0iW0&ab_channel=SebastianLague
  static const double JUMP_HEIGHT = 4 * 40.0;
  static const double TIME_TO_JUMP_APEX = 0.2;
  static const double ACCELERATION_TIME_AIRBORNE = 0.2 * 0.5;
  static const double ACCELERATION_TIME_GROUNDED = 0.1 * 0.5;
  static const double MOVE_SPEED = 6 * 10.0;
  static const double GRAVITY =
      -(2 * JUMP_HEIGHT) / (TIME_TO_JUMP_APEX * TIME_TO_JUMP_APEX);
  static const double JUMP_VELOCITY =
      (GRAVITY < 0 ? -GRAVITY : GRAVITY) * TIME_TO_JUMP_APEX;
  double velocityX = 0;
  double velocityY = 0;
  double velocityXSmoothing = 0;

  Paint paint = Paint()
    ..color = Flutter.Colors.white;

  bool jumping = false;

  double lrIntensity = 0;
  double inputX = 0;
  double inputY = 0;

  bool grounded = true;

  @override
  void update(double dt) {
    currentAnimation.update(dt);
    double targetVelocityX = lrIntensity * MOVE_SPEED;
    velocityX = Util.smoothDamp(
      velocityX,
      targetVelocityX,
      velocityXSmoothing,
      grounded ? ACCELERATION_TIME_GROUNDED : ACCELERATION_TIME_AIRBORNE,
      dt,
    );
    velocityY += GRAVITY * dt;

    x += velocityX * dt;
    y -= velocityY * dt;

    // collision
    if (x >= borderWidth + fieldWidth - width) {
      x = borderWidth + fieldWidth - width;
    } else if (x <= borderWidth) {
      x = borderWidth;
    }

    if (y >= fieldHeight - height) {
      y = fieldHeight - height;
      grounded = true;
//      currentAnimation = leftIdleAnimation;
    } else if (y <= 0) {
      y = 0;
    }
  }

  @override
  void render(Canvas canvas) {
    currentAnimation.getSprite().renderRect(
      canvas,
      Rect.fromLTWH(
        x,
        y,
        width,
        height,
      ),
    );
  }

  double fieldWidth = 0;
  double fieldHeight = 0;
  double borderWidth = 0;

  void jump() {
    if (grounded) {
      velocityY = JUMP_VELOCITY;
      grounded = false;
      currentAnimation = jumpAnimation;
    }
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    if (event.event == ActionEvent.DOWN) {
      if (event.id == 1) {
        jump();
      }
    }
  }

  @override
  void resize(Size size) {
    tileSize = size.height / Settings.TILES_IN_HEIGHT;
    width = tileSize;
    height = 2 * tileSize;
    fieldWidth = Settings.TILES_IN_WIDTH * tileSize;
    fieldHeight = size.height;
    borderWidth = (size.width - fieldWidth) / 2;
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    if (event.directional != JoystickMoveDirectional.IDLE) {
      double newLrIntensity =
          event.intensity * (cos(event.radAngle) > 0 ? 1 : -1);
      if (newLrIntensity < 0 && lrIntensity > 0 ||
          newLrIntensity > 0 && lrIntensity < 0) {
        if (lrIntensity > 0) {
          currentAnimation = leftIdleAnimation;
        } else {
          currentAnimation = rightIdleAnimation;
        }
        currentAnimation.currentIndex = 0;
      }
      lrIntensity = newLrIntensity;
    } else {
      lrIntensity = 0;
    }
  }
}
