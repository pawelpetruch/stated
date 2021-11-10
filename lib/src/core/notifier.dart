import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core.dart';

/// UI friendly implementation of Listenable
/// ChangeNotifier notifies listeners a bit too eagerly
mixin Notifier on Disposer implements Listenable {
  VoidCallback? __notify;

  VoidCallback get _notify =>
      __notify ??= Tasks.scheduled(this._notifyListeners);

  bool _isInit = false;

  @protected
  @nonVirtual
  void notify([VoidCallback? callback]) {
    callback?.call();
    _notify();
  }

  void _ensureInit() {
    if (_isInit) {
      return;
    }
    _isInit = true;
    addDispose(_disposeNotifier);
  }

  void _disposeNotifier() {
    assert(_debugAssertNotDisposed());
    _listeners = null;
  }

  List<VoidCallback>? _listeners = [];

  @protected
  bool get hasListeners {
    assert(_debugAssertNotDisposed());
    return _listeners!.isNotEmpty;
  }

  @override
  void addListener(VoidCallback listener) {
    _ensureInit();
    assert(_debugAssertNotDisposed());
    _listeners!.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    _listeners?.remove(listener);
  }

  @protected
  void _notifyListeners() {
    assert(_debugAssertNotDisposed());
    if (_listeners!.isEmpty) return;

    final localListeners = (_listeners ?? []).toList();

    for (final entry in localListeners) {
      try {
        entry();
      } catch (_) {}
    }
  }

  bool _debugAssertNotDisposed() {
    assert(() {
      if (_listeners == null) {
        throw Exception(
          'A $runtimeType was used after being disposed.\n'
          'Once you have called _disposeNotifier() on a $runtimeType, it can no longer be used.',
        );
      }
      return true;
    }());
    return true;
  }
}