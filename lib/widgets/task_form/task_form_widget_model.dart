import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/domain/data_provider/box_manager.dart';
import 'package:todo_app/domain/entity/group.dart';
import 'package:todo_app/domain/entity/task.dart';

class TaskFormWidgetModel extends ChangeNotifier{
  var _taskText ='';

  bool get isValid => _taskText.trim().isNotEmpty;

  set taskText(String value){
    final isTaskTextEmpty = _taskText.trim().isEmpty;
    _taskText = value;
    if(value.trim().isEmpty != isTaskTextEmpty){
      notifyListeners();
    }
  }

  int groupKey;
  
  TaskFormWidgetModel({required this.groupKey});

  void saveTask(BuildContext context) async{
    final taskText = _taskText.trim();
    if(taskText.isEmpty) return;


    final task = Task(text: _taskText, isDone: false);

    final box = await BoxManager.instance.openTaskBox(groupKey);
   await box.add(task);
   await BoxManager.instance.closeBox(box);
   Navigator.of(context).pop();


   

  }


}

class TaskFormWidgetModelProvider extends InheritedNotifier{

  final TaskFormWidgetModel model;
  const TaskFormWidgetModelProvider({Key? key, required Widget child,required this.model}) : super(key: key,notifier: model, child: child);

  static TaskFormWidgetModelProvider? watch(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  static TaskFormWidgetModelProvider? read(BuildContext context){
    final widget = context.getElementForInheritedWidgetOfExactType<TaskFormWidgetModelProvider>()?.widget;
    return widget is TaskFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(TaskFormWidgetModelProvider oldWidget){
    return false;
  }




}