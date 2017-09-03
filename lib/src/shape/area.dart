part of grizzly_viz_shape.shape;

class Area<VT> {
  final ValueAccessor<VT> x0;

  final ValueAccessor<VT> y0;

  final ValueAccessor<VT> x1;

  final ValueAccessor<VT> y1;

  final CurveCreator curve;

  Area(
      {ValueAccessor<VT> x0: _defaultXAccessor,
      ValueAccessor<VT> y0: _defaultYAccessor,
      ValueAccessor<VT> x1,
      ValueAccessor<VT> y1,
      CurveCreator curve: Curve.linear})
      : x0 = x0 ?? _defaultXAccessor,
        y0 = y0 ?? _defaultYAccessor,
        x1 = x1,
        y1 = y1,
        curve = curve ?? Curve.linear;

  Ctx path<Ctx extends PathContext>(List<VT> data, {Ctx ctx}) {
    ctx ??= new SvgPathContext() as Ctx;
    final x0s = new List(data.length);
    final y0s = new List(data.length);
    if (data.length >= 1) {
      final Curve c = curve(ctx);
      c.areaStart();
      c.lineStart();
      for (int i = 0; i < data.length; i++) {
        x0s[i] = x0(data[i], i);
        y0s[i] = y0(data[i], i);
        final num pX = x1 != null ? x1(data[i], i) : x0s[i];
        final num pY = y1 != null ? y1(data[i], i) : y0s[i];
        c.point(pX, pY);
      }
      c.lineEnd();
      c.areaEnd();
    }
    return ctx;
  }

  Line<VT> toLine() => line<VT>(x: x0, y: y0, curve: curve);

  Line<VT> toLineX1() => line<VT>(x: x1, y: y0, curve: curve);

  Line<VT> toLineY1() => line<VT>(x: x0, y: y1, curve: curve);
}
