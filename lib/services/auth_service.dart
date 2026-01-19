import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:silent_key/stores/hive_service.dart';
import 'package:silent_key/utils/crypto_util.dart';

/// 认证服务 - 管理用户主密码
class AuthService extends GetxService {
  static const String _settingsBoxName = 'settings';
  static const String _masterPasswordKey = 'master_password';
  static const String _passwordHintKey = 'password_hint';

  // 密码验证标记（用于检测是否已登录）
  static const String _authTokenKey = 'auth_token';

  // 存储密钥用于验证密码正确性
  static const String _verifyKey = 'verify_key';

  // 是否已登录
  final isLoggedIn = false.obs;

  // 当前登录用户的密码（内存中，不持久化）
  String? _currentPassword;

  late Box _settingsBox;

  Future<AuthService> init() async {
    if (!Hive.isBoxOpen(_settingsBoxName)) {
      _settingsBox = await Hive.openBox(_settingsBoxName);
    } else {
      _settingsBox = Hive.box(_settingsBoxName);
    }
    return this;
  }

  /// 检查是否设置过主密码
  bool hasMasterPassword() {
    return _settingsBox.containsKey(_masterPasswordKey);
  }

  /// 设置主密码（首次设置或重置）
  Future<bool> setMasterPassword(String password, {String? hint}) async {
    try {
      // 存储验证密钥（使用固定前缀，便于验证密码正确性）
      final verifyText = 'SilentKey_Verify_$password';
      final encryptedVerify = CryptoUtil.encryptStr(verifyText, password);

      await _settingsBox.put(_masterPasswordKey, encryptedVerify);
      if (hint != null) {
        await _settingsBox.put(_passwordHintKey, hint);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 验证密码是否正确
  bool verifyPassword(String password) {
    if (!hasMasterPassword()) return false;

    final storedVerify = _settingsBox.get(_masterPasswordKey) as String;
    final verifyText = 'SilentKey_Verify_$password';
    final decrypted = CryptoUtil.decryptStr(storedVerify, password);

    return decrypted == verifyText;
  }

  /// 登录
  bool login(String password) {
    if (verifyPassword(password)) {
      _currentPassword = password;
      isLoggedIn.value = true;
      // 生成一个临时令牌存储在内存中
      return true;
    }
    return false;
  }

  /// 登出
  void logout() {
    _currentPassword = null;
    isLoggedIn.value = false;
  }

  /// 获取当前密码（用于加解密）
  String? getCurrentPassword() {
    return _currentPassword;
  }

  /// 加密数据
  String? encrypt(String plainText) {
    if (_currentPassword == null || plainText.isEmpty) return null;
    return CryptoUtil.encryptStr(plainText, _currentPassword!);
  }

  /// 解密数据
  String? decrypt(String encryptedText) {
    if (_currentPassword == null || encryptedText.isEmpty) return null;
    return CryptoUtil.decryptStr(encryptedText, _currentPassword!);
  }

  /// 获取密码提示
  String? getPasswordHint() {
    return _settingsBox.get(_passwordHintKey) as String?;
  }

  /// 修改主密码
  Future<bool> changeMasterPassword(String oldPassword, String newPassword) async {
    if (!verifyPassword(oldPassword)) return false;
    if (oldPassword == newPassword) {
      return true; // 密码相同，无需更改
    }

    // 先重新加密所有账号密码
    final reencryptSuccess = await hiveService.reencryptAllPasswords(oldPassword, newPassword);
    if (!reencryptSuccess) {
      return false;
    }

    // 重新设置密码
    final hint = getPasswordHint();
    await _settingsBox.delete(_masterPasswordKey);
    await _settingsBox.delete(_passwordHintKey);

    final success = await setMasterPassword(newPassword, hint: hint);
    if (success) {
      // 更新当前密码
      _currentPassword = newPassword;
    }
    return success;
  }

  /// 清除所有数据（用于重置应用）
  Future<void> clearAllData() async {
    await _settingsBox.clear();
    logout();
  }
}

/// 全局认证服务实例
final authService = AuthService();
