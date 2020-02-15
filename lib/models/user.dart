class User {
  static const String PriorityHigh = 'high importance';
  static const String PriorityMedium = 'importance';
  static const String PriorityLow = 'low importance';

  String firstName = '';
  String lastName = '';
  Map<String, bool> priority = {
    PriorityHigh: false,
    PriorityMedium: false,
    PriorityLow: false
  };
  bool newsletter = false;

  save() {
    print('saving user using a web service');
  }
}