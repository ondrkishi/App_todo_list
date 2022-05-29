//import 'package:flutter/cupertino.dart'; 今回cupertinoは不要
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/database.dart';
import 'package:todo_list/provider.dart';
import 'package:todo_list/todo_list_screen.dart';

Future<void> main() async {
  //runAppの前にpath_providerが使えるように呼び出し
  WidgetsFlutterBinding.ensureInitialized();

  //DBを開く
  //await DBHelper.instance.initaialize(); →使わない
  final dbHelper = DBHelper();
  await dbHelper.initialize();

  //Appを実行
  runApp(
    //Riverpodを使用→プロバイダーを通じ状態変化をwidgetに通知
    ProviderScope(
      child: const App(), //Appの実行
      overrides: [
      //プロバイダの値を上書き
      databaseProvider.overrideWithValue(dbHelper),
    ],
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //[todo_list_screen]のclass[ToDoListScreen]を参照してwidgetを表示
      home: ToDoListScreen(), 
    );
  }
}

//[todo_list_screen]を見るためこのclassごと不要
// class HomeScreen extends StatefulWidget {
//   //メタデータ追加
//   @Deprecated('use[ToDoListScreen]') //@Deprecatedをつけることで非推奨クラスにする
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//  State<HomeScreen> createState() => _HomeScreenState();
// }
