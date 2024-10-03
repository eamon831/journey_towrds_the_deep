import '/app/entity/draggable_object.dart';

import '/app/core/exporter.dart';

final objectPositions = Rx<List<DraggableObjectModel>>([]);
final selectedObject = Rx<DraggableObjectModel?>(null);

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
  final Function(DraggableObjectModel value)? onTap;
  final VoidCallback onDoubleTap;
  final bool Function(DraggableObjectModel value) isSelected;
  final DraggableObjectModel model;

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
    required this.onTap,
    required this.onDoubleTap,
    required this.isSelected,
    required this.model,
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
          for (final otherModel in objectPositions.value) {
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
        child: InkWell(
          onTap: () {
            widget.onTap?.call(
              widget.model.copyWith(
                position: _position,
                width: widget.width,
                height: widget.height,
                asset: widget.model.asset,
                onTap: widget.onTap,
                onDoubleTap: widget.onDoubleTap,
              ),
            );
          },
          onDoubleTap: widget.onDoubleTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.isSelected.call(widget.model)
                    ? Colors.red
                    : Colors.transparent,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: widget.objectWidget,
            ),
          ),
        ),
      ),
    );
  }
}
