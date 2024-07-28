import 'package:fam_works/core/base/base_state.dart';
import 'package:fam_works/core/base/base_view.dart';
import 'package:fam_works/core/base/settings_view_mobx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends BaseState<SettingsView> {
  //base statei entegre ettik
  late SettingsViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView<SettingsViewModel>(
      viewBuilder: (context, model) {
        return Scaffold(
          body: Column(
            children: [
              Observer(
                  builder: (_) => Text(
                        '${viewModel.myNumber}',
                        style: const TextStyle(fontSize: 20),
                      )),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () => viewModel.incrementNumber()),
        );
      },
      viewModelInit: (model) {
        viewModel = model; //late viewModeli, initte doldurduk
      },
      viewModel: SettingsViewModel(), 
      viewModelDispose: (model) {
        
      },
    );
  }

}
