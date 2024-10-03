import 'package:getx_template/app/pages/planet/controllers/planet_controller.dart';

import '/app/core/exporter.dart';

class BuildingView extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final ResourceBuilding building;

  const BuildingView({
    required this.onTap,
    required this.onDoubleTap,
    required this.building,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: AppColors.red,
          borderRadius: BorderRadius.circular(
            30,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Text(
                building.resource.name,
                style: TextStyle(
                  color: AppColors.white,
                ),
              ),
              Text(
                building.currentLevel.toString(),
                style: TextStyle(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
/*
                      child: Lottie.asset(
                        'assets/lottie/mountain.json',
                        width: Get.width * 0.2,
                        height: Get.height * 0.2,
                        fit: BoxFit.cover,
                      ),
*/
    );
  }
}
