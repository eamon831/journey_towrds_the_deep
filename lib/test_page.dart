import 'package:flutter/material.dart';

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

  void _handleScaleStart(
    ScaleStartDetails details,
  ) {
    _previousScale = _scale;
    _normalizedOffset = (details.focalPoint - _offset) / _scale;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(
      () {
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

        // detect if the user is panning out of the screen
        if (_offset.dx > 0 || _offset.dy > 0) {
          _offset = Offset.zero;
        }
      },
    );
  }

  void _handleDoubleTap() {
    setState(
      () {
        _scale = 1.0;
        _offset = Offset.zero;
      },
    );
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
          child: Transform(
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
        ),
      ),
    );
  }
}

// Main app to demonstrate usage
void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: ZoomableSurface(
            maxZoom: 4,
            child: Container(
              color: Colors.blue,
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: Text(
                  'Zoom and Pan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
