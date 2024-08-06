import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/database.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  final _controller = TextEditingController();
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello,",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Saurabh Wankhede",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple[100],
                            borderRadius: BorderRadius.circular(12)),
                        child: const CircleAvatar(child: Icon(Icons.person)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 0,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.deepPurple[100],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.redAccent,
                        ),
                        border: InputBorder.none,
                        hintText: 'Search Task '),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'ToDo List',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.green),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 550,
                        width: 700,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple[100],
                                  borderRadius: BorderRadius.circular(5)),
                              child: ListView.builder(
                                itemCount: db.toDoList.length,
                                itemBuilder: (context, index) {
                                  return ToDoTile(
                                    taskName: db.toDoList[index][0],
                                    taskCompleted: db.toDoList[index][1],
                                    onChanged: (value) =>
                                        checkBoxChanged(value, index),
                                    deleteFunction: (context) =>
                                        deleteTask(index),
                                  );
                                },
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
