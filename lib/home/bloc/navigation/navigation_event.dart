abstract class NavigationEvent {}

class TabTapped extends NavigationEvent {
  final int index;

  TabTapped({required this.index});
}
