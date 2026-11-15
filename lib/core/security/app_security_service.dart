import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSecurityService {
  static const _storage = FlutterSecureStorage();
  static const _keyAppLockEnabled = 'app_lock_enabled';
  static const _keyAppLockPin = 'app_lock_pin';

  Future<bool> isLockEnabled() async {
    try {
      final val = await _storage.read(key: _keyAppLockEnabled);
      return val == 'true';
    } catch (_) {
      return false;
    }
  }

  Future<void> setLockEnabled(bool enabled) async {
    await _storage.write(key: _keyAppLockEnabled, value: enabled.toString());
  }

  Future<bool> hasPin() async {
    try {
      final pin = await _storage.read(key: _keyAppLockPin);
      return pin != null && pin.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> savePin(String pin) async {
    await _storage.write(key: _keyAppLockPin, value: pin);
    await setLockEnabled(true);
  }

  Future<bool> verifyPin(String enteredPin) async {
    try {
      final savedPin = await _storage.read(key: _keyAppLockPin);
      if (savedPin == null) return true; // No PIN set yet
      return savedPin == enteredPin;
    } catch (_) {
      return false;
    }
  }

  Future<void> removePin() async {
    await _storage.delete(key: _keyAppLockPin);
    await setLockEnabled(false);
  }
}
