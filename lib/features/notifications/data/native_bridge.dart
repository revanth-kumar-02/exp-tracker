import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/notification_payload.dart';
import '../services/transaction_ingestion_service.dart';

final nativeBridgeProvider = Provider<NativeBridge>((ref) {
  final ingestionService = ref.watch(transactionIngestionServiceProvider);
  final bridge = NativeBridge(ingestionService);
  bridge.initialize();
  return bridge;
});

class NotificationPermissionNotifier extends Notifier<bool> {
  @override
  bool build() {
    refreshPermission();
    return true;
  }

  Future<void> refreshPermission() async {
    final bridge = ref.read(nativeBridgeProvider);
    final granted = await bridge.isNotificationPermissionGranted();
    state = granted;
  }
}

final notificationPermissionProvider =
    NotifierProvider<NotificationPermissionNotifier, bool>(NotificationPermissionNotifier.new);

class NativeBridge {
  static const MethodChannel _methodChannel = MethodChannel('com.expensetracker/bridge');
  static const EventChannel _eventChannel = EventChannel('com.expensetracker/notifications');

  final TransactionIngestionService _ingestionService;
  bool _initialized = false;

  NativeBridge(this._ingestionService);

  void initialize() {
    if (_initialized) return;
    _initialized = true;

    _eventChannel.receiveBroadcastStream().listen(
      (dynamic event) {
        if (event is Map) {
          final payload = NotificationPayload.fromMap(event);
          _ingestionService.processNotification(payload);
        }
      },
      onError: (dynamic error) {
        // Stream listener error handler
      },
    );
  }

  Future<bool> isNotificationPermissionGranted() async {
    try {
      final bool? isGranted =
          await _methodChannel.invokeMethod<bool>('isNotificationPermissionGranted');
      return isGranted ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<void> openNotificationSettings() async {
    try {
      await _methodChannel.invokeMethod<void>('openNotificationSettings');
    } on PlatformException {
      // Fallback or ignore
    }
  }
}
