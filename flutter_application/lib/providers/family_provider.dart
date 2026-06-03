import 'dart:async';

import 'package:flutter/material.dart';

import '../services/user_service.dart';

class FamilyProvider extends ChangeNotifier {
  final UserService _userService = UserService();

  List<Map<String, dynamic>> _children = [];
  StreamSubscription<List<Map<String, dynamic>>>? _childrenSubscription;

  List<Map<String, dynamic>> get children => List.unmodifiable(_children);

  bool get hasChildren => _children.isNotEmpty;

  void listenToLinkedChildren() {
  _childrenSubscription?.cancel();

  _childrenSubscription =
      _userService.getLinkedChildrenStream().listen(
    (children) {
      _children = children;
      notifyListeners();
    },
    onError: (error) {
      debugPrint('FamilyProvider listen error: $error');
      _children = [];
      notifyListeners();
    },
  );
}

  Future<void> linkChild(String childId) async {
    await _userService.linkChildToParent(childId);
    listenToLinkedChildren();
  }

  @override
  void dispose() {
    _childrenSubscription?.cancel();
    super.dispose();
  }
}
