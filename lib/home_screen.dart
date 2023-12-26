import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app_4/boxes/boxes.dart';
import 'package:notes_app_4/models/notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titlecontroller = TextEditingController();
  final descontroller = TextEditingController();

  Future<void> _showDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Notes'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titlecontroller,
                decoration: const InputDecoration(
                  hintText: 'Enter Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextField(
                controller: descontroller,
                decoration: const InputDecoration(
                  hintText: 'Enter Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final data = NotesModel(
                title: titlecontroller.text,
                description: descontroller.text,
              );
              final box = Boxes.getData();
              box.add(data);

              data.save();

              titlecontroller.clear();
              descontroller.clear();

              // print(box);
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _editDialog(
    NotesModel notesModel,
    String title,
    String description,
  ) {
    titlecontroller.text = title;
    descontroller.text = description;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Notes'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titlecontroller,
                decoration: const InputDecoration(
                  hintText: 'Edit Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextField(
                controller: descontroller,
                decoration: const InputDecoration(
                  hintText: 'Edit Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              notesModel.title = titlecontroller.text;
              notesModel.description = descontroller.text;

              notesModel.save();

              titlecontroller.clear();
              descontroller.clear();

              Navigator.of(context).pop();
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Database'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22.0,
                  vertical: 8.0,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 15.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              data[index].title,
                              style: const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                _editDialog(
                                  data[index],
                                  titlecontroller.text,
                                  descontroller.text,
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                delete(data[index]);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                        Text(
                          data[index].description,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
