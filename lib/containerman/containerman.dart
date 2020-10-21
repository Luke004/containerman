import 'dart:math';

import 'package:containerman/containerman/background.dart';
import 'package:containerman/containerman/containerspawner.dart';
import 'package:containerman/containerman/player.dart';
import 'package:containerman/containerman/settings.dart';
import 'package:flame/components/joystick/joystick_action.dart';
import 'package:flame/components/joystick/joystick_component.dart';
import 'package:flame/components/joystick/joystick_directional.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';

class Containerman extends BaseGame with MultiTouchDragDetector {
  Random random = new Random(Settings.SEED);

  final joystick = JoystickComponent(
    directional: JoystickDirectional(
      margin: const EdgeInsets.only(left: 100, bottom: 50),
    ),
    actions: [
      JoystickAction(
        actionId: 1,
        size: 50,
        margin: const EdgeInsets.only(right: 100, bottom: 50),
        color: const Color(0xFF0000FF),
      ),
    ],
  );

  Player player;

  Containerman() {
    WidgetsFlutterBinding.ensureInitialized();
    Flame.util.fullScreen();
    Flame.util.setLandscape();
    add(Background());
    player = Player();
    joystick.addObserver(player);
    add(player);
    add(joystick);
    add(ContainerManager(random, this));
  }

  @override
  void onReceiveDrag(DragEvent drag) {
    joystick.onReceiveDrag(drag);
  }
}
