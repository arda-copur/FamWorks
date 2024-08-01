import 'package:mobx/mobx.dart';
part 'settings_view_mobx.g.dart';

class SettingsViewModel = _SettingsViewModelBase with _$SettingsViewModel;

abstract class _SettingsViewModelBase with Store {
  
  @observable
  int myNumber = 4;
  
  @action
  void incrementNumber () {
     myNumber++;
  }
}
