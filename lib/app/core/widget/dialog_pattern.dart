import '/app/core/exporter.dart';

class DialogPattern extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget child;
  final EdgeInsets insetsPadding;
  const DialogPattern({
    required this.title,
    required this.subTitle,
    required this.child,
    this.insetsPadding = const EdgeInsets.only(
      left: 20,
      right: 20,
    ),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: insetsPadding,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.grey.withOpacity(.9),
      elevation: 0,
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 80,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  4,
                ),
                color: AppColors.pageBackground,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      DecoratedBox(
                        decoration: const BoxDecoration(
                          color: AppColors.pageBackground,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(
                              4,
                            ),
                            topLeft: Radius.circular(
                              4,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            bottom: 8,
                            top: 60,
                            right: 16,
                          ),
                          child: Column(
                            children: [
                              Container(
                                color: Colors.transparent,
                                alignment: Alignment.topCenter,
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.red,
                                  ),
                                ),
                              ),
                              Text(
                                subTitle,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: 15,
                        child: InkWell(
                          onTap: Get.back,
                          child: const Icon(
                            TablerIcons.x,
                            color: AppColors.red,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  child,
                ],
              ),
            ),
            Positioned(
              top: 10,
              child: Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  color: AppColors.pageBackground,
                  borderRadius: BorderRadius.circular(
                    100,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    child: ClipOval(
                      child: Image.asset('assets/images/app_logo.png'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
