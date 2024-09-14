import '/app/core/exporter.dart';
import '/app/pages/local_db_data/controllers/local_db_data_controller.dart';

class LocalDbDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocalDbDataController>(
      LocalDbDataController.new,
      fenix: true,
    );
  }
}
