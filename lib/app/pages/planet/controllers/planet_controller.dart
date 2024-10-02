import '/app/core/exporter.dart';

class PlanetObject {
  final String name;
  final String description;
  final String image;
  final String type;

  PlanetObject({
    required this.name,
    required this.description,
    required this.image,
    required this.type,
  });
}

final methane = PlanetObject(
  name: 'Methane',
  description: 'Methane is a chemical compound with the chemical formula CH4.',
  image: 'assets/lottie/mountain.json',
  type: 'Gas',
);

final sulfur = PlanetObject(
  name: 'Sulfur',
  description:
      'Sulfur is a chemical element with the symbol S and atomic number 16.',
  image: 'assets/images/sulfur.jpg',
  type: 'Solid',
);

class PlanetController extends BaseController {
  final methaneCount = 0.0.obs;
  final selectedObject = Rx<PlanetObject?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> upgradeObject({
    required PlanetObject object,
  }) async {
    // upgrade object
    selectedObject
      ..value = object
      ..refresh();

    Get.dialog(
      DialogPattern(
        title: object.name,
        subTitle: object.type,
        child: Column(
          children: [
            Text(object.description),
            Lottie.asset(
              object.image,
              width: Get.width * 0.05,
              height: Get.height * 0.05,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
