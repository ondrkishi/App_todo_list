import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:todo_list/todo.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DBHelper {
  DBHelper();

  // プライベートな名前付きコンストラクタ
  DBHelper._();

  // このクラスの同一インスタンスを返す
  @Deprecated('not user')
  static DBHelper get instance => _instance;

  // 初回の呼び出しでインスタンスを生成する
  static final DBHelper _instance = DBHelper._();

  // プライベートなDatabaseインスタンス
  late final Database _database;

  // 実際にデータを保存するためのインスタンス
  late final StoreRef<int, Map<String, dynamic>> _store ;

  Future<void> initialize() async {
    // データベースの保存先を取得
    final appDir = await getApplicationDocumentsDirectory();

    // データベースを開く
    _database = await databaseFactoryIo.openDatabase(
      join(appDir.path, 'todo.db'),
    );

    // データを保存する領域を確保する
    _store = intMapStoreFactory.store('todo');
  }

  Future<List<ToDoRecord>> find() async {
    final result = await _store.find(
      _database,
      finder: Finder(
        sortOrders: [SortOrder(Field.key, false)],
      ),
    );

    return result
        .map(
          (e) => ToDoRecord(
            e.key,
            ToDo.fromJson(e.value),
          ),
        )
        .toList();
  }

  /// テーブルに新しいToDoを追加
  Future<ToDoRecord> add(ToDo todo) async {
    final key = await _store.add(_database, todo.toJson());
    return ToDoRecord(key, todo);
  }

  /// ToDoを更新
  Future<void> update(int key, ToDo todo) async {
    _store.record(key).put(_database, todo.toJson());
  }
}