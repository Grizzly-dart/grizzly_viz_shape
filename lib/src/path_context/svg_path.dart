part of grizzly_viz_shape.path;

class SvgPathContext implements PathContext {
  final List<String> _path = [];

  UnmodifiableListView<String> _umPath;

  UnmodifiableListView<String> get path => _umPath;

  // Start of current subpath
  num _x0;

  num _y0;

  // End of current subpath
  num _x1;

  num _y1;

  SvgPathContext() {
    _umPath = new UnmodifiableListView<String>(_path);
  }

  String render() => _path.join(' ');

  String toString() => render();

  SvgPathContext moveTo(num x, num y) {
    _x0 = _x1 = x;
    _y0 = _y1 = y;
    _path.add(cmdM(x, y));
    return this;
  }

  SvgPathContext closePath() {
    if (_x1 != null) {
      _x1 = _x0;
      _y1 = _y0;
      _path.add("Z");
    }
    return this;
  }

  SvgPathContext lineTo(num x, num y) {
    _x1 = x;
    _y1 = y;
    _path.add(cmdL(x, y));
    return this;
  }

  SvgPathContext quadraticCurveTo(num x1, num y1, num x, num y) {
    _x1 = x;
    _y1 = y;
    _path.add("Q$x1 $y1 $x $y");
    return this;
  }

  SvgPathContext bezierCurveTo(num x1, num y1, num x2, num y2, num x, num y) {
    _x1 = x;
    _y1 = y;
    _path.add("C$x1 $y1 $x2 $y2 $x $y");
    return this;
  }

  /// Adds an arc to the path with the given control points and radius, connected
  /// to the previous point by a straight line
  ///
  /// [x1]: The x axis of the coordinate for the first control point.
  /// [y1]: The y axis of the coordinate for the first control point.
  /// [x2]: The x axis of the coordinate for the second control point.
  /// [y2]: The y axis of the coordinate for the second control point.
  /// [radius]: The arc's radius.
  SvgPathContext arcTo(num x1, num y1, num x2, num y2, num radius) {
    final num x0 = _x1;
    final num y0 = _y1;

    final num x21 = x2 - x1;
    final num y21 = y2 - y1;
    final num x01 = x0 - x1;
    final num y01 = y0 - y1;
    final num lenSq01 = x01 * x01 + y01 * y01;

    if (radius < 0) throw new Exception('Negative radius!');

    if (_x1 == null) {
      _x1 = x1;
      _y1 = y1;
      _path.add(cmdM(x1, y1));
    } else if (lenSq01 <= epsilon) {
      // if (x1, y1) is coincident with (x0, y0), do nothing
    } else if ((y01 * x21 - y21 * x01).abs() <= epsilon || radius == 0) {
      _x1 = x1;
      _y1 = y1;
      _path.add(cmdL(x1, y1));
    } else {
      final num x20 = x2 - x0;
      final num y20 = y2 - y0;
      final num lenSq21 = x21 * x21 + y21 * y21;
      final num lenSq20 = x20 * x20 + y20 * y20;
      final num len21 = math.sqrt(lenSq21);
      final num len01 = math.sqrt(lenSq01);
      final num l = radius *
          math.tan((math.PI -
                  math.acos(
                      (lenSq21 + lenSq01 - lenSq20) / (2 * len21 * len01))) /
              2);
      final num t01 = l / len01;
      final num t21 = l / len21;

      if ((t01 - 1).abs() > epsilon) {
        _path.add(cmdL(x1 + t01 * x01, y1 + t01 * y01));
      }

      _x1 = x1 + t21 * x21;
      _y1 = y1 + t21 * y21;
      final bool sweepFlag = y01 * x20 > x01 * y20;
      _path.add(cmdA(radius, radius, false, false, sweepFlag,_x1, _y1));
    }
    return this;
  }

  SvgPathContext arc(num x, num y, num radius, num startAngle, num endAngle,
      [bool anticlockwise = false]) {
    final num dx = radius * math.cos(startAngle);
    final num dy = radius * math.sin(startAngle);
    final num x0 = x + dx;
    final num y0 = y + dy;
    final bool cw = !anticlockwise;
    num da = anticlockwise ? startAngle - endAngle : endAngle - startAngle;

    if (radius < 0) throw new Exception("Radius must be positive!");

    // Is this path empty? Move to (x0,y0).
    if (_x1 == null)
      _path.add(cmdM(x0, y0));

    // Or, is (x0,y0) not coincident with the previous point? Line to (x0,y0).
    else if ((_x1 - x0).abs() > epsilon || (_y1 - y0).abs() > epsilon)
      _path.add(cmdL(x0, y0));

    // Is this arc empty? We’re done.
    if (radius == null) return this;

    // Does the angle go the wrong way? Flip the direction.
    if (da < 0) da = da % tau + tau;

    // Is this a complete circle? Draw two arcs to complete the circle.
    if (da > tauEpsilon) {
      _x1 = x0;
      _y1 = y0;
      _path.add(cmdA(radius, radius, false, true, cw, x - dx, y - dy));
      _path.add(cmdA(radius, radius, false, true, cw, x0, y0));
    }

    // Is this arc non-empty? Draw an arc!
    else if (da > epsilon) {
      _x1 = x + radius * math.cos(endAngle);
      _y1 = y + radius * math.sin(endAngle);
      _path.add(cmdA(radius, radius, false, da >= math.PI, cw, _x1, _y1));
    }
    return this;
  }

  SvgPathContext rect(num x, num y, num width, num height) {
    _x0 = _x1 = x;
    _y0 = _y1 = y;
    _path.add(cmdM(x, y));
    _path.add("h$width");
    _path.add("v$height");
    _path.add("h${-width}");
    _path.add("Z");
    return this;
  }

  static final double epsilon = 1e-6;

  static final double tau = 2 * math.PI;

  static final double tauEpsilon = tau - epsilon;

  static String cmdM(num x, num y) => "M$x $y";

  static String cmdL(num x, num y) => "L$x $y";

  static String cmdA(num rx, num ry, bool axisRot, bool laFlag, bool sweepFlag,
          num x, num y) =>
      "A$rx $ry ${axisRot?1:0} ${laFlag?1:0} ${sweepFlag?1:0} $x $y";
}
