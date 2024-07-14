// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workely_app/allmodules/task_class.dart';

class Homepages extends StatefulWidget {
  const Homepages({super.key});
  @override
  State<StatefulWidget> createState() {
    return _Homepagestate();
  }
}

class _Homepagestate extends State<Homepages> {
  late double _deviceheight, _devicewight;
  String? _newTaskContent;
  Box? _box;

  @override
  void initState() {
    super.initState();
  }

  _Homepagestate();
  @override
  Widget build(BuildContext context) {
    _deviceheight = MediaQuery.of(context).size.height;
    _devicewight = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        toolbarHeight: _deviceheight * 0.20,
        backgroundColor: Colors.green,
        title: const Text(
          "DAILY WORKS TO DO !!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: _taskview(),
      floatingActionButton: _addflotingbutton(),
    );
  }

  Widget _taskview() {
    return FutureBuilder(
      future: Hive.openBox("tasks"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _box = snapshot.data;
          return _taskslist();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _taskslist() {
    List tasks = _box!.values.toList();
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          var task = Task.fromMap(tasks[index]);
          return ListTile(
            title: Text(
              task.content,
              style: TextStyle(
                decoration: task.done ? TextDecoration.lineThrough : null,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              task.timestamp.toString(),
            ),
            trailing: Icon(
              task.done
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank,
              color: Colors.red,
            ),
            onTap: () {
              task.done = !task.done;
              _box!.putAt(
                index,
                task.toMap(),
              );
              setState(() {});
            },
            onLongPress: () {
              _box!.deleteAt(index);
              setState(() {});
            },
          );
        });
  }

  Widget _addflotingbutton() {
    return FloatingActionButton(
      onPressed: _displayAddTaskpopup,
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  void _displayAddTaskpopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(" Add your Task here"),
            content: TextField(
              onSubmitted: (_) {
                if (_newTaskContent != null) {
                  var task = Task(
                      content: _newTaskContent!,
                      timestamp: DateTime.now(),
                      done: false);
                  _box!.add(task.toMap());
                  setState(() {
                    _newTaskContent = null;
                    Navigator.pop(context);
                  });
                }
              },
              onChanged: (value) {
                setState(() {
                  _newTaskContent = value;
                });
              },
            ),
          );
        });
  }
}
