import 'package:getx_template/app/entity/draggable_object.dart';

import '/app/core/exporter.dart';

class HomeController extends BaseController {
  final objectList = Rx<List<DraggableObjectModel>>([]);

  @override
  Future<void> onInit() async {
    super.onInit();

  }
}
