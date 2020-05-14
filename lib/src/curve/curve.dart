library grizzly_viz_shape.curve;

import 'dart:math' as math;
import 'package:grizzly_viz_shape/src/path_context/path.dart';

part 'basis.dart';
part 'basis_closed.dart';
part 'basis_open.dart';
part 'bundle.dart';
part 'cardinal.dart';
part 'cardinal_closed.dart';
part 'cardinal_open.dart';
part 'catmull_rom.dart';
part 'catmull_rom_closed.dart';
part 'catmull_rom_open.dart';
part 'linear.dart';
part 'linear_closed.dart';
part 'monotone.dart';
part 'natural.dart';
part 'radial.dart';
part 'step.dart';

typedef CurveCreator = Curve Function(PathContext ctx);

abstract class Curve {
  PathContext get context;

  /// Starts a new area. Each area consists of two lines.
  void areaStart();

  /// Ends current area
  void areaEnd();

  /// Starts a new line
  void lineStart();

  /// Ends a line
  void lineEnd();

  void point(num x, num y);

  static LinearCurve linear(PathContext context) => new LinearCurve(context);

  static StepCurve step(PathContext context, {num t: 0.5}) =>
      new StepCurve(context, t);

  static StepCurve stepBefore(PathContext context) => new StepCurve(context, 0);

  static StepCurve stepAfter(PathContext context) => new StepCurve(context, 1);

  static MonotoneXCurve monotoneX(PathContext context) =>
      new MonotoneXCurve(context);
}
