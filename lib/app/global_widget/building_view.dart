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
              SizedBox(
                height: 50,
                width: 50,
                child: building.resource.image.contains('.json')
                    ? Lottie.asset(
                        'assets/lottie/methane_$currentLevel.json',
                        width: Get.width * 0.2,
                        height: Get.height * 0.2,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/${building.resourceType}_$currentLevel.png',
                      ),
              ),
              Text(
                'Name :${building.resource.name}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
              Text(
                'Level :${building.currentLevel}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
