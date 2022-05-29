// import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_list.freezed.dart';
part 'todo_list.g.dart';

@freezed
class ToDoRecord with _$ToDoRecord {
  factory ToDoRecord(
    int key,
    ToDo value,
  ) = _ToDoRecord;
}

@freezed
class ToDo with _$ToDo{
  factory ToDo({
    //ToDoのタイトル
    required String title,
    //ToDoのチェック状態
    @Default(false) bool archived,
  }) = _ToDo;

  factory ToDo.fromJson(Map<String, dynamic> json) => _$ToDoFromJson(json);
}


