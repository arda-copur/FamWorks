import 'package:flutter/material.dart';

class BottomProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  final String _imageUrl ='https://cf.ltkcdn.net/family/images/std/200821-800x533r1-family.jpg';
  String get imageUrl => _imageUrl;
  final String _imageFileName = 'fam.jpg';
  String get imageFileName => _imageFileName;
  final String _homeLabel = "Ev";
  String get homeLabel => _homeLabel;
  final String _activityLabel = "Aktivite";
  String get activityLabel => _activityLabel;
  final String _chatLabel = "Sohbet";
  String get chatLabel => _chatLabel;
  final String _profileLabel = "Profil";
  String get profileLabel => _profileLabel;
  final String _pastTasks = "Geçmiş Görevler";
  String get pastTasks => _pastTasks;
  final String _pastActivities = "Geçmiş Aktiviteler";
  String get pastActivities => _pastActivities;
  final String _famSummary = "Aile Özeti";
  String get famSummary => _famSummary;
  final String _exit = "Çıkış";
  String get exit => _exit;

  void _onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  get onItemTapped => _onItemTapped;
}
