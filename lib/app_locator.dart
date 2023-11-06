import 'package:get_it/get_it.dart';
import 'package:mom/core/config.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton<Config>(Config());
}

