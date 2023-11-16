import 'package:flutter/material.dart';

class DriverNavigator<T> {
  final BuildContext context;
  bool rootNav = false;

  DriverNavigator.of(
      this.context, {
        bool rootNavigator = false,
      }) {
    FocusManager.instance.primaryFocus?.unfocus(); // close any focus primary
    rootNav = rootNavigator;
  }

  final int _delay = 50;

  Future<T?> push(Widget child) {
    return Navigator.of(context, rootNavigator: rootNav).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => child,
        transitionDuration: Duration(milliseconds: _delay),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
  }

  Future<T?> pushReplacement(Widget child) {
    return Navigator.of(context, rootNavigator: rootNav).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => child,
        transitionDuration: Duration(milliseconds: _delay),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
  }

  Future<T?> pushAndRemoveUntil(Widget child) {
    return Navigator.of(context, rootNavigator: rootNav).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => child,
        transitionDuration: Duration(milliseconds: _delay),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
          (route) => false,
    );
  }

  void pop([result]) {
    Navigator.of(context, rootNavigator: rootNav).pop(result);
  }

  Future<bool> maybePop([result]) async {
    return await Navigator.of(context, rootNavigator: rootNav).maybePop(result);
  }
}