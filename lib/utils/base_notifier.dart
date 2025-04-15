import 'package:flutter/material.dart';

class BaseNotifier<T> extends ValueNotifier<T> {
  BaseNotifier(super.value);

  T get currentState => super.value;

  void emit(T value) {
    if (hasListeners) {
      super.value = value;
    }
  }

  void update() {
    if (hasListeners) {
      notifyListeners();
    }
  }
}
