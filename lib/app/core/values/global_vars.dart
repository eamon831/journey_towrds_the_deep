import 'package:get/get.dart';
import 'package:getx_template/app/entity/resource.dart';
import 'package:getx_template/app/entity/resource_building.dart';

var methane = Resource(
  name: 'Methane',
  slug: 'methane',
  description: 'Methane is a chemical compound with the chemical formula CH4.',
  image: 'assets/lottie/mountain.json',
  type: 'Gas',
);


var hydrogenSulfide = Resource(
  name: 'Hydrogen Sulfide',
  slug: 'hydrogen-sulfide',
  description:
      'Hydrogen sulfide is a colorless gas with the characteristic foul odor of rotten eggs.',
  image: 'assets/lottie/mountain.json',
  type: 'Gas',
);

var ammonia = Resource(
  name: 'Ammonia',
  slug: 'ammonia',
  description:
      'Ammonia is a compound of nitrogen and hydrogen with the formula NH3.',
  image: 'assets/lottie/mountain.json',
  type: 'Liquid',
);

var water = Resource(
  name: 'Water',
  slug: 'water',
  description:
      'Water is a transparent, tasteless, odorless, and nearly colorless chemical substance, which is the main constituent of Earth\'s hydrosphere and the fluids of all known living organisms.',
  image: 'assets/lottie/mountain.json',
  type: 'Liquid',
);

var bacteria = Resource(
  name: 'Bacteria',
  slug: 'bacteria',
  description:
      'Bacteria are a type of biological cell. They constitute a large domain of prokaryotic microorganisms.',
  image: 'assets/lottie/mountain.json',
  type: 'Organism',
);

final methaneBuilding = ResourceBuilding(
  resource: methane,
  resourceType: 'methane',
  upgradeRequirements: {
    hydrogenSulfide: 30,
  },
  currentCount: 0,
).obs;

final hydrogenSulfideBuilding = Rx<ResourceBuilding?>(null);

final ammoniaBuilding = Rx<ResourceBuilding?>(null);

final waterBuilding = Rx<ResourceBuilding?>(null);

final bacteriaBuilding = Rx<ResourceBuilding?>(null);
