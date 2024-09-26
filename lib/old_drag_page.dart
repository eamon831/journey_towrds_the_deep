import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import the Lottie package

// Model to represent draggable object
class DraggableObjectModel {
  Offset position;
  double width;
  double height;
  String asset;

  DraggableObjectModel({
    required this.position,
    required this.width,
    required this.height,
    required this.asset,
  });
}

List<DraggableObjectModel> _objectPositions = [];

class ZoomableSurface extends StatefulWidget {
  final Widget child;
  final double minZoom;
  final double maxZoom;
  final EdgeInsets padding;

  const ZoomableSurface({
    required this.child,
    super.key,
    this.minZoom = 0.5,
    this.maxZoom = 3.0,
    this.padding = EdgeInsets.zero,
  });

  @override
  _ZoomableSurfaceState createState() => _ZoomableSurfaceState();
}

class _ZoomableSurfaceState extends State<ZoomableSurface> {
  double _scale = 1;
  Offset _offset = Offset.zero;
  Offset _normalizedOffset = Offset.zero;
  double _previousScale = 1;

  void _handleScaleStart(ScaleStartDetails details) {
    _previousScale = _scale;
    _normalizedOffset = (details.focalPoint - _offset) / _scale;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      final double newScale = (_previousScale * details.scale).clamp(
        widget.minZoom,
        widget.maxZoom,
      );
      final bool isZoomingIn = newScale > _scale;
      final bool isZoomingOut = newScale < _scale;
      _scale = newScale;
      _offset = details.focalPoint - _normalizedOffset * _scale;
      // Print whether zooming in or out
      if (isZoomingIn) {
        print('Zooming In');
      } else if (isZoomingOut) {
        print('Zooming Out');
        print('Scale: $_scale');
        print('Offset: $_offset');

        // Detect if the user is zooming out and the scale is less than 1
        if (_scale < 1) {
          // Reset the scale and offset
          _scale = 1;
          _offset = Offset.zero;
        }
      }

      final double width = MediaQuery.of(context).size.width;
      final double height = MediaQuery.of(context).size.height;
      final double contentWidth = width * _scale;
      final double contentHeight = height * _scale;

      final double minOffsetX = -contentWidth + width;
      final double minOffsetY = -contentHeight + height;

      _offset = Offset(
        _offset.dx.clamp(minOffsetX, 0),
        _offset.dy.clamp(minOffsetY, 0),
      );
    });
  }

  void _handleDoubleTap() {
    setState(() {
      _scale = 1.0;
      _offset = Offset.zero;
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onDoubleTap: _handleDoubleTap,
      child: ClipRect(
        child: Stack(
          children: [
            Transform(
              transform: Matrix4.identity()
                ..translate(_offset.dx, _offset.dy)
                ..scale(_scale),
              child: Padding(
                padding: widget.padding,
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DraggableObject extends StatefulWidget {
  final Offset position;
  final ValueChanged<Offset> onPositionChanged;
  final bool isOverlapping;
  final bool isDragging;
  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;
  final bool Function(Offset, Offset, double) checkCollision;
  final Widget objectWidget;
  final double width;
  final double height;

  const DraggableObject({
    required this.position,
    required this.onPositionChanged,
    required this.isOverlapping,
    required this.isDragging,
    required this.onDragStart,
    required this.onDragEnd,
    required this.checkCollision,
    required this.objectWidget,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  _DraggableObjectState createState() => _DraggableObjectState();
}

class _DraggableObjectState extends State<DraggableObject> {
  late Offset _position;
  late Offset _previousPosition;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _position = widget.position;
    _previousPosition = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanStart: (details) {
          if (!_isDragging && !widget.isDragging) {
            setState(() {
              _isDragging = true;
              _previousPosition = _position;
              widget.onDragStart();
            });
          }
        },
        onPanUpdate: (details) {
          if (_isDragging) {
            setState(() {
              _position += details.delta;
              widget.onPositionChanged(_position);
            });
          }
        },
        onPanEnd: (details) {
          bool hasCollision = false;
          for (final otherModel in _objectPositions) {
            if (otherModel.position != _position &&
                widget.checkCollision(_position, otherModel.position, 50)) {
              hasCollision = true;
              break;
            }
          }
          if (hasCollision) {
            setState(() {
              _position = _previousPosition;
              widget.onPositionChanged(_position);
            });
          }
          setState(() {
            _isDragging = false;
          });
          widget.onDragEnd();
        },
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: widget.objectWidget,
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDragging = false;

  bool _checkCollision(Offset position1, Offset position2, double size) {
    final bool collision = _distanceBetweenPoints(position1, position2) < size;
    if (collision) {
      print("Collision between $position1 and $position2"); // Debug print
    }
    return collision;
  }

  double _distanceBetweenPoints(Offset point1, Offset point2) {
    return sqrt(pow(point1.dx - point2.dx, 2) + pow(point1.dy - point2.dy, 2));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ZoomableSurface(
            maxZoom: 4,
            child: Stack(
              children: [
                Container(
                  color: Colors.green,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                ..._objectPositions.map(
                  (model) {
                    final bool isOverlapping = _objectPositions.any(
                      (otherModel) =>
                          otherModel.position != model.position &&
                          _checkCollision(
                              model.position, otherModel.position, 50),
                    );
                    return DraggableObject(
                      position: model.position,
                      isOverlapping: isOverlapping,
                      isDragging: _isDragging,
                      onDragStart: () {
                        setState(() {
                          _isDragging = true;
                        });
                      },
                      onDragEnd: () {
                        setState(() {
                          _isDragging = false;
                        });
                      },
                      onPositionChanged: (newPosition) {
                        final int index = _objectPositions.indexOf(model);
                        if (index != -1) {
                          setState(() {
                            _objectPositions[index] = DraggableObjectModel(
                              position: newPosition,
                              width: model.width,
                              height: model.height,
                              asset: model.asset,
                            );
                          });
                        }
                      },
                      checkCollision: _checkCollision,
                      width: model.width,
                      height: model.height,
                      objectWidget: Lottie.asset(model.asset),
                    );
                  },
                ).toList(),
                Positioned(
                  top: 50,
                  left: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final newModel = DraggableObjectModel(
                          position: const Offset(100, 100),
                          width: 100,
                          height: 100,
                          asset: 'assets/lottie/mountain.json',
                        );
                        _objectPositions.add(newModel);
                        print(
                            "Added object at: ${newModel.position}"); // Debug print
                      });
                    },
                    child: const Text('Add Object'),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _objectPositions.clear();
                        print("Cleared all objects"); // Debug print
                      });
                    },
                    child: const Text('Clear Objects'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
