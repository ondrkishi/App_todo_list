import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/provider.dart';
import 'package:todo_list/todo.dart';

class ToDoInputView extends HookConsumerWidget {
  const ToDoInputView({
    Key? key,
    this.record,
  }) : super(key: key);

  final ToDoRecord? record;

  /// ToDoInputViewを表示する静的メソッド
  static Future<void> show(
    BuildContext context, {
    ToDoRecord? record,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => ToDoInputView(record: record),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _controller = useTextEditingController(
      text: record?.value.title,
    );

    final _todoListNotifier = ref.read(
      todoListProvider.notifier,
    );

    return Padding(
      padding: EdgeInsets.only(
        // キーボードが表示された分下から押し上げる
        bottom: MediaQuery.of(context).viewInsets.bottom,
        // 画面両端に余白をつくる
        right: 10,
        left: 10,
      ),
      child: Column(
        // TextFieldの高さに合わせる
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            // 入力値の変更を外部インスタンスで制御できるようにする
            controller: _controller,
            // 画面表示時にフォーカス
            autofocus: true,
            // キーボードでdone(完了)したらこの画面を閉じる
            onEditingComplete: () async {
              if (_controller.text.isEmpty) {
                return;
              }

              if (record == null) {
                await _todoListNotifier.add(
                  ToDo(title: _controller.text),
                );
              } else {
                // ToDoのtitleを更新
                final updatedToDo = record!.value.copyWith(
                  title: _controller.text,
                );

                // 新しいToDoRecordとToDoで更新
                await _todoListNotifier.update(
                  record!.copyWith(
                    value: updatedToDo,
                  ),
                );
              }

              Navigator.pop(context);
            },
            decoration: const InputDecoration(
              // TextFieldの下線を消す
              border: InputBorder.none,
              // 未入力時に表示するテキスト
              hintText: '追加するToDoのタイトルを入力',
            ),
          ),
        ],
      ),
    );
  }
}