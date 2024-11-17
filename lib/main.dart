import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/app_providers.dart';
import 'core/extentions.dart';
import 'core/router.dart';
import 'domain/model/todo_model.dart';
import 'domain/services/notification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());
  await Hive.openBox<Task>('tasksBox');
  await NotificationService.instance.initialize();
  runApp(const MyApp());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: MultiProvider(
        providers: providers,
        builder: (context, child) => MaterialApp.router(
          title: 'quicpictodo',
          themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          routeInformationProvider: AppRouter.router.routeInformationProvider,
          routeInformationParser: AppRouter.router.routeInformationParser,
          routerDelegate: AppRouter.router.routerDelegate,
        ),
      ),
    );
  }
}
