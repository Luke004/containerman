import 'dart:math';

class Util {
  static double smoothDamp(
    double current,
    double target,
    double currentVelocity,
    double smoothTime,
    double dt,
  ) {
    return smoothDamp2(
      current,
      target,
      currentVelocity,
      smoothTime,
      double.infinity,
      dt,
    );
  }

  static double smoothDamp2(
    double current,
    double target,
    double currentVelocity,
    double smoothTime,
    double maxSpeed,
    double deltaTime,
  ) {
    smoothTime = max(0.0001, smoothTime);
    double num = 2.0 / smoothTime;
    double num2 = num * deltaTime;
    double num3 = 1.0 / (1 + num2 + 0.48 * pow(num2, 2) + 0.235 * pow(num2, 3));
    double num4 = current - target;
    double num5 = target;
    double num6 = maxSpeed * smoothTime;
    num4 = num4.clamp(-num6, num6);
    target = current - num4;
    double num7 = (currentVelocity + num * num4) * deltaTime;
    currentVelocity = (currentVelocity - num * num7) * num3;
    double num8 = target + (num4 + num7) * num3;
    if (num5 - current > 0.0 == num8 > num5) {
      num8 = num5;
      currentVelocity = (num8 - num5) / deltaTime;
    }
    return num8;
  }
}
