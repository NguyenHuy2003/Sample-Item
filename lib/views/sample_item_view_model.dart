import 'package:flutter/material.dart';
import 'package:sample_item/models/sample_item.dart';

import 'sample_item_services.dart';

class SampleItemViewModel extends ChangeNotifier {
  static final _instance = SampleItemViewModel._internal();
  factory SampleItemViewModel() => _instance;
  SampleItemViewModel._internal() {
    services.loodItem().then((values) {
      if (values is List<SampleItem>) {
        items.clear();
        items.addAll(values);
        notifyListeners();
      }
    });
  }
  final services = SampleItemServices();
  final List<SampleItem> items = [];

  Future addItem(String name) async {
    var item = SampleItem(name: name);
    items.add(item);
    notifyListeners();

    services.addItem(item);
    return item;
  }

  Future removeItem(String id) async {
    items.removeWhere((item) => item.id == id);
    notifyListeners();

    services.removeItem(id);
  }

  Future updateItem(String id, String newName) async {
    try {
      final item = items.firstWhere((item) => item.id == id);
      item.name.value = newName;

      await services.updateItem(item);
    } catch (e) {
      debugPrint("Không tìm thấy mục với ID $id");
    }
  }
}
