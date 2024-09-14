import '/app/core/exporter.dart';

class SelectiveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final bool isSelected;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? borderRadius;
  final double? elevation;
  final double? padding;
  final double? margin;
  final double? borderWidth;
  final Color? borderColor;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final double? iconPadding;
  final double? iconMargin;

  const SelectiveButton({
    required this.onPressed,
    super.key,
    this.text,
    this.isSelected = false,
    this.color = Colors.transparent,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.elevation,
    this.padding,
    this.margin,
    this.borderWidth,
    this.borderColor,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.iconPadding,
    this.iconMargin,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          isSelected ? color! : Colors.transparent,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 0,
            ),
          ),
        ),
        elevation: MaterialStateProperty.all<double>(elevation ?? 0),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.all(padding ?? 0),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          Size(width ?? 0, height ?? 0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: EdgeInsets.only(right: iconPadding ?? 0),
              child: Icon(
                icon,
                size: iconSize ?? 0,
                color: iconColor,
              ),
            ),
          Text(
            text ?? '',
            style: TextStyle(
              color: isSelected ? textColor : Colors.black,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
