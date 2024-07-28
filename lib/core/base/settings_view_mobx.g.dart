// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_view_mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingsViewModel on _SettingsViewModelBase, Store {
  late final _$myNumberAtom =
      Atom(name: '_SettingsViewModelBase.myNumber', context: context);

  @override
  int get myNumber {
    _$myNumberAtom.reportRead();
    return super.myNumber;
  }

  @override
  set myNumber(int value) {
    _$myNumberAtom.reportWrite(value, super.myNumber, () {
      super.myNumber = value;
    });
  }

  late final _$_SettingsViewModelBaseActionController =
      ActionController(name: '_SettingsViewModelBase', context: context);

  @override
  void incrementNumber() {
    final _$actionInfo = _$_SettingsViewModelBaseActionController.startAction(
        name: '_SettingsViewModelBase.incrementNumber');
    try {
      return super.incrementNumber();
    } finally {
      _$_SettingsViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
myNumber: ${myNumber}
    ''';
  }
}
