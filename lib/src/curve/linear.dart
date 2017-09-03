part of grizzly_viz_shape.curve;

class LinearCurve implements Curve {
  final PathContext context;

  num _line;

  num _point;

  LinearCurve(this.context);

  void areaStart() => _line = 0;

  void areaEnd() => _line = null;

  void lineStart() => _point = 0;

  void lineEnd() {
    if(_line != null) {
      if(_line != 0) context.closePath();
    } else {
      if(_point == 1) context.closePath();
    }
    _line = 1 - (_line??0);
  }

  void point(num x, num y) {
    if(_point == 0) {
      _point = 1;
      if((_line??0) != 0) {
        context.lineTo(x, y);
      } else {
        context.moveTo(x, y);
      }
    } else if(_point == 1) {
      _point = 2;
      context.lineTo(x, y);
    } else {
      context.lineTo(x, y);
    }
  }
}