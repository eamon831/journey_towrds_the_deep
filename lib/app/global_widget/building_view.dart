import 'package:nb_utils/nb_utils.dart';

import '/app/core/exporter.dart';
import '/app/entity/resource_building.dart';

final audioPlayer = AudioPlayerSingleton();

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
    final currentLevel = building.currentLevel > 5 ? 5 : building.currentLevel;
    return InkWell(
      onTap: onTap,
      onDoubleTap: () async {
        onDoubleTap.call();
        await audioPlayer.playBeepSound();
      },
      child: Container(
        // height: 100,
        //  width: 100,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              Container(
                height: Get.height * 0.1,
                width: Get.width * 0.1,
                margin: const EdgeInsets.only(bottom: 30),
                child: building.resource.image.contains('.json')
                    ? Lottie.asset(
                        'assets/lottie/methane_$currentLevel.json',
                        width: Get.width * 0.2,
                        height: Get.height * 0.2,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/${building.resourceType}_$currentLevel.png',
                        width: Get.width * 0.1,
                        height: Get.height * 0.1,
                        fit: BoxFit.contain,
                      ),
              ),
              Text(
                'Name :${building.resource.name}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Level :${building.currentLevel}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
