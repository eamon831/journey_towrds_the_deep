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
  Offset _iconPosition = Offset(100, 100); // Initial position of the icon

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

      // Get the bounds of the visible area
      final double width = MediaQuery.of(context).size.width;
      final double height = MediaQuery.of(context).size.height;

      final double contentWidth = width * _scale;
      final double contentHeight = height * _scale;

      final double minOffsetX = -contentWidth + width;
      final double minOffsetY = -contentHeight + height;

      // Ensure the offset stays within bounds
      _offset = Offset(
        _offset.dx.clamp(minOffsetX, 0),
        _offset.dy.clamp(minOffsetY, 0),
      );
    });
  }

  void _handleDoubleTap() {
    setState(
      () {
        _scale = 1.0;
        _offset = Offset.zero;
      },
    );
  }

  void _onIconDrag(Offset newOffset) {
    setState(() {
      _iconPosition = newOffset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[300],
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onScaleStart: _handleScaleStart,
        onScaleUpdate: _handleScaleUpdate,
        onDoubleTap: _handleDoubleTap,
        child: ClipRect(
          child: Stack(
            children: [
              Transform(
                transform: Matrix4.identity()
                  ..translate(
                    _offset.dx,
                    _offset.dy,
                  )
                  ..scale(
                    _scale,
                  ),
                child: Padding(
                  padding: widget.padding,
                  child: widget.child,
                ),
              ),
              ..._objectPositions.map(
                (position) => DraggableObject(
                  position: position * _scale + _offset,
                  onPositionChanged: (newPosition) {
                    final int index = _objectPositions.indexOf(position);
                    final List<Offset> newPositions =
                        List.from(_objectPositions);
                    newPositions[index] = (newPosition - _offset) / _scale;
                    setState(
                      () {
                        _objectPositions = newPositions;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DraggableObject extends StatefulWidget {
  final Offset position;
  final ValueChanged<Offset> onPositionChanged;

  const DraggableObject({
    required this.position,
    required this.onPositionChanged,
    super.key,
  });

  @override
  _DraggableObjectState createState() => _DraggableObjectState();
}

class _DraggableObjectState extends State<DraggableObject> {
  late Offset _position;

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
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
            widget.onPositionChanged(_position);
          });
        },
        child: Container(
          width: 50,
          height: 50,
          color: Colors.blue,
          child: const Icon(Icons.home, color: Colors.white),
        ),
      ),
    );
  }
}

// Main app to demonstrate usage
void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ZoomableSurface(
            maxZoom: 4,
            child: Container(
              color: Colors.green,
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //add a draggable object
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _objectPositions.add(Offset(200, 200));
                        });
                      },
                      child: Text('Add Object'),
                    ),
                    Text(
                      'Zoom and Pan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
