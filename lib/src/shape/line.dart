part of grizzly_viz_shape.shape;

class Line<VT> {
  final ValueAccessor<VT> x;

  final ValueAccessor<VT> y;

  final CurveCreator curve;

  Line(
      {ValueAccessor<VT> x: _defaultXAccessor,
      ValueAccessor<VT> y: _defaultYAccessor,
      CurveCreator curve: Curve.linear})
      : x = x ?? _defaultXAccessor,
        y = y ?? _defaultYAccessor,
        curve = curve ?? Curve.linear;

  Ctx path<Ctx extends PathContext>(List<VT> data, {Ctx ctx}) {
    ctx ??= new SvgPathContext() as Ctx;
    if (data.length >= 1) {
      final Curve c = curve(ctx);
      c.lineStart();
      for (int i = 0; i < data.length; i++) {
        c.point(x(data[i], i), y(data[i], i));
      }
      c.lineEnd();
    }
    return ctx;
  }
}

num _defaultXAccessor<VT>(VT d, int index) {
  if (d is Iterable)
    return d.first;
  else if (d is math.Point)
    return d.x;
  else if (d is num)
    return d;
  else
    throw new Exception('Unhandled data found!');
}

num _defaultYAccessor<VT>(VT d, int index) {
  if (d is Iterable)
    return d.elementAt(1);
  else if (d is math.Point)
    return d.y;
  else if (d is num)
    return d;
  else
    throw new Exception('Unhandled data found!');
}
