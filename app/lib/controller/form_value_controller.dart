import 'package:flutter/foundation.dart';

// Central form value controller to store key -> value and notify listeners.
class FormValueController {
  final Map<String, dynamic> _values = {};
  final ValueNotifier<Map<String, dynamic>> changes = ValueNotifier({});

  void setValue(String key, dynamic value) {
    _values[key] = value;
    changes.value = Map<String, dynamic>.from(_values);
  }

  T? value<T>(String key) {
    final v = _values[key];
    if (v == null) return null;
    return v as T;
  }

  Map<String, dynamic> all() => Map<String, dynamic>.from(_values);

  void remove(String key) {
    _values.remove(key);
    changes.value = Map<String, dynamic>.from(_values);
  }

  void dispose() {
    changes.dispose();
  }
}
