import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: ZoomableSurface(),
      ),
    ),
  );
}

class ZoomableSurface extends StatefulWidget {
  const ZoomableSurface({super.key});

  @override
  _ZoomableSurfaceState createState() => _ZoomableSurfaceState();
}

class _ZoomableSurfaceState extends State<ZoomableSurface> {
  double _scale = 1;
  double _previousScale = 1;
  Offset? _objectPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        _previousScale = _scale;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _scale = _previousScale * details.scale;
        });
      },
      onTapDown: (TapDownDetails details) {
        setState(() {
          // Update the object position to the new tap location
          _objectPosition = details.localPosition;
        });
      },
      child: Transform.scale(
        scale: _scale,
        child: Stack(
          children: [
            Container(
              color: Colors.green[200],
              child: const GridSurface(rows: 10, columns: 10),
            ),
            if (_objectPosition != null)
              DraggableObject(
                position: _objectPosition!,
                onPositionChanged: (newPosition) {
                  setState(() {
                    _objectPosition = newPosition;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

class GridSurface extends StatelessWidget {
  final int rows;
  final int columns;

  const GridSurface({
    required this.rows,
    required this.columns,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
      ),
      itemCount: rows * columns,
      itemBuilder: (context, index) {
        return GridTile(
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          ),
        );
      },
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
