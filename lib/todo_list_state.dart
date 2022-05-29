import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/database.dart';
import 'package:todo_list/todo.dart';

class ToDoListState extends StateNotifier<List<ToDoRecord>> {
  ToDoListState(List<ToDoRecord> state, this.dbHelper) : super(state);

  final DBHelper dbHelper;

  Future<void> find() async {
    state = await dbHelper.find();
  }
  Future<void> add(ToDo todo) async{
    //登録後の新しいレコードを取得
    final record = await dbHelper.add(todo);
    state = state.sublist(0)..insert(0, record);
  }

  Future<void> toggle(ToDoRecord record) async {
    //現在のaechivedを反転する
    final updateRecord = record.copyWith.value(
      archived: !record.value.archived,
    );

    await dbHelper.update(
      updateRecord.key,
      updateRecord.value,
    );

    _replaceRecord(updateRecord);
  }

  void _replaceRecord(ToDoRecord record){
    //配列の同じToDoを入れ替える
    final findIndex = state.indexWhere(
      (e) => e.key == record.key,
      );

      //新しいリストで更新する
      state = List.from(state)
      ..replaceRange(
        findIndex,
        findIndex + 1,
        [record],
        );
  }

  update(ToDoRecord toDoRecord) {}
}