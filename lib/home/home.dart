import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/home/bloc/navigation/navigation_bloc.dart';
import 'package:todo_bloc/home/bloc/navigation/navigation_event.dart';
import 'package:todo_bloc/home/bloc/navigation/navigation_state.dart';
import 'package:todo_bloc/home/tasks.dart';
import 'package:todo_bloc/home/users.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            if (state is TabSelected) {
              switch (state.index) {
                case 0:
                  return const TaskListScreen();
                case 1:
                  return const UserListScreen();

                default:
                  return const Center(child: Text('Invalid Page'));
              }
            }
            return const Center(child: Text('Invalid Page'));
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          int currentIndex = 0;
          if (state is TabSelected) {
            currentIndex = state.index;
          }
          return BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              BlocProvider.of<NavigationBloc>(context)
                  .add(TabTapped(index: index));
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.task_alt_outlined),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                label: 'Users',
              ),
            ],
          );
        },
      ),
    );
  }
}
