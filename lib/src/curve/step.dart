part of grizzly_viz_shape.curve;

class StepCurve implements Curve {
  final PathContext context;

  num _whichLineSeg = _notArea;

  num _point;

  num _x;

  num _y;

  num _t;

  StepCurve(this.context, this._t);

  @override
  void areaStart() => _whichLineSeg = _topLineOfArea;

  @override
  void areaEnd() => _whichLineSeg = _notArea;

  @override
  void lineStart() {
    _x = null;
    _y = null;
    _point = 0;
  }

  @override
  void lineEnd() {
    if (_t > 0 && _t < 1) {
      if (_point == 2) {
        context.lineTo(_x, _y);
      }
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
      _t = 1 - _t;
    } else if (_whichLineSeg == _baseLineOfArea) {
      // End existing base line segment and start top line segment
      _whichLineSeg = _topLineOfArea;
      _t = 1 - _t;
    }
  }

  @override
  void point(num x, num y) {
    if (_point == 2) {
      if (_t <= 0) {
        context.lineTo(_x, y);
        context.lineTo(x, y);
      } else {
        final num x1 = (_x * (1 - _t)) + (x * _t);
        context.lineTo(x1, _y);
        context.lineTo(x1, y);
      }
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
      if (_t <= 0) {
        context.lineTo(_x, y);
        context.lineTo(x, y);
      } else {
        final num x1 = (_x * (1 - _t)) + (x * _t);
        context.lineTo(x1, _y);
        context.lineTo(x1, y);
      }
    } else
      throw new Exception('Unknown state!');

    _x = x;
    _y = y;
  }

  static const int _notArea = 0;

  static const int _topLineOfArea = 1;

  static const int _baseLineOfArea = 2;
}
