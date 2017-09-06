part of grizzly_viz_shape.curve;

class LinearCurve implements Curve {
  final PathContext context;

  num _whichLineSeg = _notArea;

  num _point;

  LinearCurve(this.context);

  void areaStart() => _whichLineSeg = _topLineOfArea;

  void areaEnd() => _whichLineSeg = _notArea;

  void lineStart() => _point = 0;

  void lineEnd() {
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

  void point(num x, num y) {
    if (_point == 2) {
      context.lineTo(x, y);
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
      context.lineTo(x, y);
    } else
      throw new Exception('Unknown state!');
  }

  static const int _notArea = 0;

  static const int _topLineOfArea = 1;

  static const int _baseLineOfArea = 2;
}
