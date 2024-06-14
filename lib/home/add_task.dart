import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/home/bloc/tasks/task_bloc.dart';
import 'package:todo_bloc/home/bloc/tasks/task_event.dart';
import 'package:todo_bloc/home/bloc/users/user_state.dart';
import 'package:todo_bloc/main.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  User? _selectedUser;
  late Future<List<User>> _usersFuture;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _usersFuture = dbHelper.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (v) {
                    if (v.toString().isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (v) {
                    if (v.toString().isEmpty) {
                      return 'Description cannot be empty';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: FutureBuilder(
                    future: _usersFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No users found'));
                      } else {
                        final users = snapshot.data!;
                        return Column(
                          children: [
                            DropdownButtonFormField<User>(
                              decoration: const InputDecoration(
                                labelText: 'Select User',
                                border: OutlineInputBorder(),
                              ),
                              value: _selectedUser,
                              onChanged: (User? newValue) {
                                _selectedUser = newValue;
                              },
                              items: users
                                  .map<DropdownMenuItem<User>>((User user) {
                                return DropdownMenuItem<User>(
                                  value: user,
                                  child: Text(user.name),
                                );
                              }).toList(),
                            ),
                            // Display selected user details
                            if (_selectedUser != null)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Selected User: ${_selectedUser!.name}'),
                                    Text('Email: ${_selectedUser!.email}'),
                                  ],
                                ),
                              ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (_selectedUser == null) {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Container(
                              constraints: const BoxConstraints(
                                  minHeight: 100, maxHeight: 100),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_2_outlined,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      'Please select a user',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        final title = _titleController.text;
                        final description = _descriptionController.text;

                        if (title.isNotEmpty &&
                            description.isNotEmpty &&
                            _selectedUser != null) {
                          final response = await dbHelper.insertTask(data: {
                            'title': title,
                            'description': description,
                            'user_id': _selectedUser!.id,
                          });

                          BlocProvider.of<TaskBloc>(context).add(AddTask(
                              id: response,
                              title: title,
                              description: description,
                              assignedUser: _selectedUser!));
                          Navigator.pop(context);
                        }
                      }
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
