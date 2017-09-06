part of grizzly_viz_shape.curve;

class CatmullRomOpenCurve implements Curve {
  final PathContext context;

  CatmullRomOpenCurve(this.context);

  @override
  void areaStart() {
    throw new UnimplementedError();
  }

  @override
  void point(num x, num y) {
    throw new UnimplementedError();
  }

  @override
  void lineEnd() {
    throw new UnimplementedError();
  }

  @override
  void lineStart() {
    throw new UnimplementedError();
  }

  @override
  void areaEnd() {
    throw new UnimplementedError();
  }
}