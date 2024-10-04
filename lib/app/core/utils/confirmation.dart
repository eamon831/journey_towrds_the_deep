import 'package:nb_utils/nb_utils.dart';

import '/app/core/exporter.dart';

Future<bool> confirmationModal({
  required String msg,
}) async {
  final confirmation = await showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return DialogPattern(
            title: msg,
            subTitle: '',
            insetsPadding: const EdgeInsets.only(
              left: 40,
              right: 40,
            ),
            child: Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back(result: false);
                    },
                    child: Container(
                      //  height: 50,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        left: 32,
                        right: 32,
                        top: 8,
                        bottom: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppValues.containerBorderRadius,
                        ),
                        color: Colors.red,
                        border: Border.all(
                          color: Colors.teal,
                        ),
                      ),
                      child: const Text(
                        'No',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  15.width,
                  InkWell(
                    onTap: () {
                      Get.back(result: true);
                    },
                    child: Container(
                      //height: buttonHeight,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        left: 32,
                        right: 32,
                        top: 8,
                        bottom: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppValues.containerBorderRadius,
                        ),
                        color: Colors.green,
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ) ??
      false;

  return confirmation;
}
