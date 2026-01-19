import 'package:flutter/foundation.dart';
import 'package:silent_key/stores/hive_service.dart';

/// 数据变更通知器
class DataNotifier extends ChangeNotifier {
  final HiveService _hiveService = hiveService;

  DataNotifier() {
    _initStreams();
  }

  void _initStreams() {
    _hiveService.categoriesStream.listen((_) {
      notifyListeners();
    });

    _hiveService.accountsStream.listen((_) {
      notifyListeners();
    });
  }

  // 手动触发更新
  void notifyDataChanged() {
    notifyListeners();
  }
}