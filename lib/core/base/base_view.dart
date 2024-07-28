import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

class BaseView<T extends Store> extends StatefulWidget {
  final T viewModel; // view'in viewModel'i
  final Function(T model)? viewModelInit; // init
  final Function(T model)? viewModelDispose; // dispose
  final Widget Function(BuildContext context, T model) viewBuilder; // ekranın builder'ı. view'in context'ini ve viewModel'ini alsın

  const BaseView({
    Key? key,
    required this.viewModel,
    this.viewModelInit,
    this.viewModelDispose,
    required this.viewBuilder,
  }) : super(key: key);

  @override
  State<BaseView> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends Store> extends State<BaseView<T>> {
  @override
  void initState() {
    super.initState();
    if (widget.viewModelInit != null) widget.viewModelInit!(widget.viewModel);
  }

  @override
  void dispose() {
    if (widget.viewModelDispose != null) widget.viewModelDispose!(widget.viewModel);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.viewBuilder(context, widget.viewModel);
  }
}
