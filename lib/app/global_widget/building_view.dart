import '/app/core/exporter.dart';
import '/app/entity/resource_building.dart';

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
        // height: 100,
        //  width: 100,
        decoration: BoxDecoration(
          color: AppColors.red,
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              /*  Text(
                'Name  ${building.resource.name}',
                style: const TextStyle(
                  color: AppColors.white,
                ),
              ),
              Text(
                'Level ${building.currentLevel}',
                style: const TextStyle(
                  color: AppColors.white,
                ),
              ),
              Text(
                'Production Rate ${building.productionRate}',
                style: const TextStyle(
                  color: AppColors.white,
                ),
              ),
              Text(
                'Next Upgrade Cost ${building.upgradeRequirements.map((key, value) => MapEntry(key.name, value))}',
                style: const TextStyle(
                  color: AppColors.white,
                ),
              ),*/
              SizedBox(
                height: 50,
                width: 50,
                child: Lottie.asset(
                  'assets/lottie/methane_${building.currentLevel}.json',
                  width: Get.width * 0.2,
                  height: Get.height * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
