// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library grizzly_viz_shape.path;

import 'dart:collection';
import 'dart:math' as math;

part 'package:grizzly_viz_shape/src/path_context/svg_path.dart';

abstract class PathContext {
  PathContext moveTo(num x, num y);

  PathContext closePath();

  PathContext lineTo(num x, num y);

  PathContext quadraticCurveTo(num x1, num y1, num x, num y);

  PathContext bezierCurveTo(num x1, num y1, num x2, num y2, num x, num y);

  /// Adds an arc to the path with the given control points and radius, connected
  /// to the previous point by a straight line
  ///
  /// [x1]: The x axis of the coordinate for the first control point.
  /// [y1]: The y axis of the coordinate for the first control point.
  /// [x2]: The x axis of the coordinate for the second control point.
  /// [y2]: The y axis of the coordinate for the second control point.
  /// [radius]: The arc's radius.
  PathContext arcTo(num x1, num y1, num x2, num y2, num radius);

  PathContext arc(num x, num y, num radius, num startAngle, num endAngle,
      [bool anticlockwise = false]);

  PathContext rect(num x, num y, num width, num height);
}
