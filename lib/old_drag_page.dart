import 'package:flutter/material.dart';

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
      final double newScale = (_previousScale * details.scale).clamp(
        widget.minZoom,
        widget.maxZoom,
      );
      final bool isZoomingIn = newScale > _scale;
      final bool isZoomingOut = newScale < _scale;
      _scale = newScale;
      _offset = details.focalPoint - _normalizedOffset * _scale;

      if (isZoomingOut) {
        if (_scale < 1) {
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

  const DraggableObject({
    required this.position,
    required this.onPositionChanged,
    required this.isOverlapping,
    required this.isDragging,
    required this.onDragStart,
    required this.onDragEnd,
    super.key,
  });

  @override
  _DraggableObjectState createState() => _DraggableObjectState();
}

class _DraggableObjectState extends State<DraggableObject> {
  late Offset _position;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _position = widget.position;
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
            });
            widget.onDragStart();
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
            setState(() {
              _isDragging = false;
            });
            widget.onDragEnd();
          }
        },
        child: Container(
          width: 50,
          height: 50,
          color: widget.isOverlapping ? Colors.red : Colors.blue,
          child: const Icon(Icons.home, color: Colors.white),
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
    return position1.dx < position2.dx + size &&
        position1.dx + size > position2.dx &&
        position1.dy < position2.dy + size &&
        position1.dy + size > position2.dy;
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
                    // Check if the current object overlaps with any other object
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
                    );
                  },
                ),
                Positioned(
                  top: 50,
                  left: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _objectPositions.add(const Offset(100, 100));
                      });
                    },
                    child: const Text('Add Object'),
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
