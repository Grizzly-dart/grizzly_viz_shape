library grizzly_viz_shape.path.browser;

import 'dart:html';
import '../path.dart';

class Canvas2DPathContext implements PathContext {
  final CanvasRenderingContext2D canvas;

  Canvas2DPathContext(this.canvas);

  Canvas2DPathContext moveTo(num x, num y) {
    canvas.moveTo(x, y);
    return this;
  }

  Canvas2DPathContext closePath() {
    canvas.closePath();
    return this;
  }

  Canvas2DPathContext lineTo(num x, num y) {
    canvas.lineTo(x, y);
    return this;
  }

  Canvas2DPathContext quadraticCurveTo(num x1, num y1, num x, num y) {
    canvas.quadraticCurveTo(x1, y1, x, y);
    return this;
  }

  Canvas2DPathContext bezierCurveTo(
      num x1, num y1, num x2, num y2, num x, num y) {
    canvas.bezierCurveTo(x1, y1, x2, y2, x, y);
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
  Canvas2DPathContext arcTo(num x1, num y1, num x2, num y2, num radius) {
    canvas.arcTo(x1, y1, x2, y2, radius);
    return this;
  }

  Canvas2DPathContext arc(
      num x, num y, num radius, num startAngle, num endAngle,
      [bool anticlockwise = false]) {
    canvas.arc(x, y, radius, startAngle, endAngle, anticlockwise);
    return this;
  }

  Canvas2DPathContext rect(num x, num y, num width, num height) {
    canvas.rect(x, y, width, height);
    return this;
  }
}
