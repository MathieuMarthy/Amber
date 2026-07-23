import 'dart:math' as math;
import 'package:flutter/material.dart';

final fabStyle = ButtonStyle(
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  fixedSize: const WidgetStatePropertyAll(Size(60, 60)),
  iconSize: const WidgetStatePropertyAll(28),
  padding: const WidgetStatePropertyAll(EdgeInsets.zero),
);

Widget fabShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection direction,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, _) {
      final t = animation.value;
      final addOpacity = (1.0 - t).clamp(0.0, 1.0);
      final checkOpacity = t.clamp(0.0, 1.0);

      // Rotation de 90 degrés (pi/2)
      final addAngle = t * (math.pi / 2);
      final checkAngle = (t - 1.0) * (math.pi / 2);

      return FilledButton(
        onPressed: () {}, // Non-null pour éviter l'état grisé
        style: fabStyle,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: addOpacity,
              child: Transform.rotate(
                angle: addAngle,
                child: const Icon(Icons.add),
              ),
            ),
            Opacity(
              opacity: checkOpacity,
              child: Transform.rotate(
                angle: checkAngle,
                child: const Icon(Icons.check),
              ),
            ),
          ],
        ),
      );
    },
  );
}
