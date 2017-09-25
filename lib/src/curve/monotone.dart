part of grizzly_viz_shape.curve;

class MonotoneXCurve implements Curve {
  final PathContext context;

  num _whichLineSeg = _notArea;

  num _point;

  num _x0;

  num _y0;

  num _x1;

  num _y1;

  num _t0;

  MonotoneXCurve(this.context);

  @override
  void areaStart() => _whichLineSeg = _topLineOfArea;

  @override
  void areaEnd() => _whichLineSeg = _notArea;

  @override
  void lineStart() {
    _x0 = _y0 = _x1 = _y1 = null;
    _point = 0;
  }

  @override
  void lineEnd() {
    if (_point == 2) {
      context.lineTo(_x1, _y1);
    } else if (_point == 3) {
      MonotoneXCurve.bezierCurveTo(this, _t0, slope2(this, _t0));
    }
    if (_whichLineSeg == _baseLineOfArea) {
      // Close the path if it is a base line segment
      context.closePath();
    } else if (_whichLineSeg == _notArea && _point == 1) {
      context.closePath();
    }
    if (_whichLineSeg == _topLineOfArea) {
      // End existing top line segment and start base line segment
      _whichLineSeg = _baseLineOfArea;
    } else if (_whichLineSeg == _baseLineOfArea) {
      // End existing base line segment and start top line segment
      _whichLineSeg = _topLineOfArea;
    }
  }

  @override
  void point(num x, num y) {
    num t1 = null;

    // Skip coincident point
    if (x == _x1 && y == _y1) return;

    if (_point == 3) {
      t1 = slope3(this, x, y);
      MonotoneXCurve.bezierCurveTo(this, _t0, t1);
    } else if (_point == 2) {
      _point = 3;
      t1 = slope3(this, x, y);
      MonotoneXCurve.bezierCurveTo(this, slope2(this, t1), t1);
    } else if (_point == 0) {
      _point = 1;
      if (_whichLineSeg == _baseLineOfArea) {
        // If it is base line segment, continue from previous point of top line
        // segment
        context.lineTo(x, y);
      } else {
        context.moveTo(x, y);
      }
    } else if (_point == 1) {
      _point = 2;
    } else
      throw new Exception('Unknown state!');

    _x0 = _x1;
    _x1 = x;
    _y0 = _y1;
    _y1 = y;
    _t0 = t1;
  }

  static const int _notArea = 0;

  static const int _topLineOfArea = 1;

  static const int _baseLineOfArea = 2;

  static num slope2(MonotoneXCurve curve, num t) {
    final num h = curve._x1 - curve._x0;
    return h != 0 ? (3 * (curve._y1 - curve._y0) / h - t) / 2 : t;
  }

  static int _sign(num inp) => inp < 0 ? -1 : 1;

  static num slope3(MonotoneXCurve curve, num x2, num y2) {
    final num h0 = curve._x1 - curve._x0;
    final num h1 = x2 - curve._x1;
    num s0 = (curve._y1 - curve._y0);
    num s1 = (y2 - curve._y1);
    if (h0 != 0) {
      s0 /= h0;
    } else {
      if (h1 < 0)
        s0 = double.INFINITY;
      else
        s0 = double.NEGATIVE_INFINITY;
    }
    if (h1 != 0) {
      s1 /= h1;
    } else {
      if (h0 < 0)
        s1 = double.INFINITY;
      else
        s1 = double.NEGATIVE_INFINITY;
    }
    final num p = (s0 * h1 + s1 * h0) / (h0 + h1);
    final num ret = (_sign(s0) + _sign(s1)) *
            math.min(s0.abs(), math.min(s1.abs(), 0.5 * p.abs()));
    if(ret == double.NAN) {
      return 0;
    } else {
      return ret;
    }
  }

  static void bezierCurveTo(MonotoneXCurve curve, num t0, num t1) {
    final num x0 = curve._x0;
    final num y0 = curve._y0;
    final num x1 = curve._x1;
    final num y1 = curve._y1;
    final num dx = (x1 - x0) / 3;
    curve.context.bezierCurveTo(
      x0 + dx,
      y0 + dx * t0,
      x1 - dx,
      y1 - dx * t1,
      x1,
      y1,
    );
  }
}
