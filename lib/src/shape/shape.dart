library grizzly_viz_shape.shape;

import 'dart:collection';
import 'dart:math' as math;
import 'package:grizzly_viz_shape/src/curve/curve.dart';
import 'package:grizzly_viz_shape/src/path_context/path.dart';

part 'area.dart';
part 'line.dart';

typedef num ValueAccessor<VT>(VT datum, int index);

ValueAccessor<VT> constAccessor<VT>(num v) => (_, _1) => v;

Line<VT> line<VT>(
        {ValueAccessor<VT> x: _defaultXAccessor,
        ValueAccessor<VT> y: _defaultYAccessor,
        CurveCreator curve: Curve.linear}) =>
    new Line(x: x, y: y, curve: curve);

Area<VT> area<VT>(
        {ValueAccessor<VT> x0: _defaultXAccessor,
        ValueAccessor<VT> y0: _defaultYAccessor,
        ValueAccessor<VT> x1,
        ValueAccessor<VT> y1,
        CurveCreator curve: Curve.linear}) =>
    new Area(x0: x0, y0: y0, x1: x1, y1: y1, curve: curve);
