import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/database.dart';
import 'package:todo_list/todo.dart';
import 'package:todo_list/todo_list_state.dart';

//初期値はなく使うときまでにoverrideする
final databaseProvider = Provider<DBHelper>(
  (_) => throw UnimplementedError(),
);

final todoListProvider = StateNotifierProvider<ToDoListState, List<ToDoRecord>>(
  (ref) => ToDoListState(
    [],
    ref.read(databaseProvider),
  ),
);