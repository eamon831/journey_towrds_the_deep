import '/app/core/exporter.dart';

class PurchaseAbleBuilding {
  final String name;
  final int price;
  final String image;
  final bool isPurchased = false;
  final VoidCallback? onTap;

  PurchaseAbleBuilding({
    required this.name,
    required this.price,
    required this.image,
    this.onTap,
  });
}

class ShopPageController extends BaseController {
  final buildingList = Rx<List<PurchaseAbleBuilding>?>(null);
  final methaneCount = Rx<int?>(null);
  final hydrogenSulfideCount = Rx<int?>(null);
  final ammoniaCount = Rx<int?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    methaneCount.value = await prefs.getInt(prefMethaneCount);
    hydrogenSulfideCount.value = await prefs.getInt(prefHydrogenSulfideCount);
    ammoniaCount.value = await prefs.getInt(prefAmmoniaCount);

    if(kDebugMode){
      print('methaneCount: $methaneCount');
      print('hydrogenSulfideCount: $hydrogenSulfideCount');
      print('ammoniaCount: $ammoniaCount');
    }

    await getBuildingList();
  }

  Future<void> getBuildingList() async {
    buildingList.value = [
      PurchaseAbleBuilding(
        name: 'Sulfur Building',
        price: 100,
        image: 'assets/images/building_1.png',
        onTap: () async {
          final confirmation = await confirmationModal(
            msg: 'Do you want to buy this building?',
          );
          if (confirmation) {
            // Do something
            await prefs.setBool(
              key: prefsHasHydrogenSulfide,
              value: true,
            );
          }
        },
      ),
      PurchaseAbleBuilding(
        name: 'Building 2',
        price: 200,
        image: 'assets/images/building_2.png',
      ),
      PurchaseAbleBuilding(
        name: 'Building 3',
        price: 300,
        image: 'assets/images/building_3.png',
      ),
      PurchaseAbleBuilding(
        name: 'Building 4',
        price: 400,
        image: 'assets/images/building_4.png',
      ),
      PurchaseAbleBuilding(
        name: 'Building 5',
        price: 500,
        image: 'assets/images/building_5.png',
      ),
    ];
  }
}
