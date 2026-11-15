import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_security_service.dart';

final appSecurityServiceProvider = Provider<AppSecurityService>((ref) {
  return AppSecurityService();
});

class SecurityLockState {
  final bool isLockEnabled;
  final bool isAppUnlocked;

  const SecurityLockState({
    required this.isLockEnabled,
    required this.isAppUnlocked,
  });

  SecurityLockState copyWith({
    bool? isLockEnabled,
    bool? isAppUnlocked,
  }) {
    return SecurityLockState(
      isLockEnabled: isLockEnabled ?? this.isLockEnabled,
      isAppUnlocked: isAppUnlocked ?? this.isAppUnlocked,
    );
  }
}

class SecurityLockNotifier extends Notifier<SecurityLockState> {
  late final AppSecurityService _service;

  @override
  SecurityLockState build() {
    _service = ref.watch(appSecurityServiceProvider);
    _loadInitialState();
    return const SecurityLockState(isLockEnabled: false, isAppUnlocked: true);
  }

  Future<void> _loadInitialState() async {
    final enabled = await _service.isLockEnabled();
    state = SecurityLockState(
      isLockEnabled: enabled,
      isAppUnlocked: !enabled,
    );
  }

  Future<void> enableLockWithPin(String pin) async {
    await _service.savePin(pin);
    state = state.copyWith(isLockEnabled: true, isAppUnlocked: true);
  }

  Future<void> disableLock() async {
    await _service.removePin();
    state = const SecurityLockState(isLockEnabled: false, isAppUnlocked: true);
  }

  Future<bool> unlockWithPin(String pin) async {
    final valid = await _service.verifyPin(pin);
    if (valid) {
      state = state.copyWith(isAppUnlocked: true);
      return true;
    }
    return false;
  }

  void lockAppNow() {
    if (state.isLockEnabled) {
      state = state.copyWith(isAppUnlocked: false);
    }
  }
}

final securityLockProvider =
    NotifierProvider<SecurityLockNotifier, SecurityLockState>(
  SecurityLockNotifier.new,
);
