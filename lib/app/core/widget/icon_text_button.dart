import '/app/core/exporter.dart';

class IconTextButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onTap;
  const IconTextButton({
    required this.text,
    required this.icon,
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // height: 50,
        // width: 50,
        decoration: BoxDecoration(
          color: AppColors.red,
          borderRadius: BorderRadius.circular(
            8,
          ),
          border: Border.all(
            color: AppColors.green,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.white,
            ),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
