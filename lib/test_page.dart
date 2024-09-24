import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import the Lottie package

List<Offset> _objectPositions = [];

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
      _scale = (_previousScale * details.scale).clamp(widget.minZoom, widget.maxZoom);
      _offset = details.focalPoint - _normalizedOffset * _scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
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
  final Widget objectWidget; // This widget can be anything, including a Lottie animation

  const DraggableObject({
    required this.position,
    required this.onPositionChanged,
    required this.isOverlapping,
    required this.isDragging,
    required this.onDragStart,
    required this.onDragEnd,
    required this.checkCollision,
    required this.objectWidget, // Pass different widgets here
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
          if (_isDragging) {
            bool hasCollision = false;
            for (var otherPosition in _objectPositions) {
              if (otherPosition != _position &&
                  widget.checkCollision(_position, otherPosition, 50)) {
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
          }
        },
        child: widget.objectWidget, // Render the passed widget (Lottie or any widget)
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

  // Function to calculate the distance between two points
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
                      (position) {
                    final bool isOverlapping = _objectPositions.any(
                          (otherPosition) =>
                      otherPosition != position &&
                          _checkCollision(position, otherPosition, 50),
                    );
                    return DraggableObject(
                      position: position,
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
                        final int index = _objectPositions.indexOf(position);
                        if (index != -1) {
                          setState(() {
                            _objectPositions[index] = newPosition;
                          });
                        }
                      },
                      checkCollision: _checkCollision,
                      // Pass different Lottie or widget for each draggable object
                      objectWidget: Lottie.asset('assets/animation_${_objectPositions.indexOf(position)}.json'),
                    );
                  },
                ),
                Positioned(
                  top: 50,
                  left: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final newPosition = const Offset(100, 100);
                        _objectPositions.add(newPosition);
                        print("Added object at: $newPosition"); // Debug print
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
                    child: const Text('Clear Object'),
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
