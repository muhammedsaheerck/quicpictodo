import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../application/todo_provider.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: ((context) => TodoProvider())),
];
