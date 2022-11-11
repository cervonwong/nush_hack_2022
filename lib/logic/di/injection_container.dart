import 'package:get_it/get_it.dart';

import '../controllers/gates_selected_controller.dart';

void configureDependencies() {
  final getIt = GetIt.instance;
  getIt.registerLazySingleton(
    () => GatesSelectedController(),
  );
}
