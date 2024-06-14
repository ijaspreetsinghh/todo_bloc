abstract class NavigationState {}

class NavigationInitial extends NavigationState {}

class TabSelected extends NavigationState {
  final int index;

  TabSelected({required this.index});
}
