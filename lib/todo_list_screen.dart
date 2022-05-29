import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/provider.dart';
//import 'package:todo_list/todo_input.dart'; 使わない
import 'package:todo_list/todo_input_view.dart';

class ToDoListScreen extends HookConsumerWidget {
  const ToDoListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ToDoListStateに変更があるとリビルド
    final _todos = ref.watch(todoListProvider);
    // ToDoListStateのメソッドを使えるようにする
    final _todoNotifier = ref.read(todoListProvider.notifier);

    // buildが呼ばれてからToDoリストを読み込みこむ
    useEffect(() {
      _todoNotifier.find();
    }, []);

    //画面の表示
    return Scaffold(
      appBar: AppBar(
        //AppBarに表示するタイトル
        title: const Text('ToDoデモ'),
      ),
      //スクロールバーの追加
      body: Scrollbar(
        //ToDoのリスト
        child: ListView.builder(
          //チェックボックス付きのリスト
          itemBuilder: (context, index) => CheckboxListTile(
            onChanged: (checked) {
              _todoNotifier.toggle(_todos[index]);
            },
            value: _todos[index].value.archived,
            // ListTileからCheckedListTileに変更
            //ToDoのタイトル押下でタイトルの変更が可能
            //押下時の処理は[todo_input_viev]のclass
            title: GestureDetector(
              onTap: () {
                ToDoInputView.show(
                  context,
                  record: _todos[index],
                );
              },
              child: Text(_todos[index].value.title),
            ),
          ),
          itemCount: _todos.length,
        ),
      ),
      //ToDoの追加ボタン
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          //押下時の処理は[todo_input_viev]のclass
          ToDoInputView.show(context);
        },
      ),
    );
  }
}
