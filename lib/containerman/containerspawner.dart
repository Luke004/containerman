import 'dart:math';
import 'dart:ui';

import 'package:containerman/containerman/settings.dart';
import 'package:flame/components/component.dart';

import 'container.dart';
import 'containerman.dart';

class ContainerManager extends Component {
  double accumulatedTime = 0;
  static const double spawnSpeedInSec = 0.5;
  Random random;
  Containerman containerman;
  List<List<Container>> containers = List.generate(
    Settings.TILES_IN_WIDTH,
    (index) => List.generate(
      Settings.TILES_IN_HEIGHT,
      (index) => null,
    ),
  );

  ContainerManager(this.random, this.containerman);

  @override
  void render(Canvas canvas) {}
  int i = 0;

  void onContainerLanded(Container container) {
    if (container.destiny == Settings.TILES_IN_HEIGHT - 1) {
      bool flag = true;
      for (int x = 0; x < Settings.TILES_IN_WIDTH; x++) {
        Container container = containers[x][Settings.TILES_IN_HEIGHT - 1];
        if (container == null || !container.landed) {
          flag = false;
          break;
        }
      }
      if (flag) {
        for (int x = 0; x < Settings.TILES_IN_WIDTH; x++) {
          containerman
              .markToRemove(containers[x][Settings.TILES_IN_HEIGHT - 1]);
        }
        for (int x = 0; x < Settings.TILES_IN_WIDTH; x++) {
          for (int y = Settings.TILES_IN_HEIGHT - 2; y > 0; y--) {
            Container container = containers[x][y];
            if (container != null) {
              container.destiny += 1;
              container.landed = false;
            }
            containers[x][y + 1] = container;
          }
        }
      }
    }
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;
    if (accumulatedTime >= spawnSpeedInSec) {
      int column = random.nextInt(Settings.TILES_IN_WIDTH);
      while (containers[column][3] != null) {
        column = random.nextInt(Settings.TILES_IN_WIDTH);
      }
      int i = containers[column].length - 1;
      while (containers[column][i] != null) {
        i--;
        if (i == -1) break;
      }
      containers[column][i] = Container(column * tileSize, 0.0, i, this, containerman);
      this.containerman.add(containers[column][i]);
      accumulatedTime -= spawnSpeedInSec;
    }
  }

  double tileSize;

  @override
  void resize(Size size) {
    tileSize = size.height / Settings.TILES_IN_HEIGHT;
  }
}
