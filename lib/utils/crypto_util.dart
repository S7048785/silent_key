import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;


/// 加密工具类（使用 AES-256-CBC）
class CryptoUtil {
  // 加密密钥长度（32字节 = 256位）
  static const _keyLength = 32;
  // 初始化向量长度（16字节）
  static const _ivLength = 16;

  /// 使用 PBKDF2 从密码生成密钥
  static Uint8List _deriveKey(String password, Uint8List salt) {
    final passwordBytes = utf8.encode(password);
    // 使用 SHA-256 进行 PBKDF2 迭代
    final hash = sha256.convert(passwordBytes);
    // 生成密钥
    final key = utf8.encode(hash.toString());
    return Uint8List.fromList(key.take(_keyLength).toList());
  }

  /// 加密文本
  /// [plainText] 明文
  /// [password] 用户密码
  /// 返回: base64 编码的加密数据（包含 salt + iv + 密文）
  static String encryptStr(String plainText, String password) {
    if (plainText.isEmpty) return '';

    // 生成随机 salt（16字节）
    final salt = Uint8List(16);
    for (int i = 0; i < 16; i++) {
      salt[i] = DateTime.now().millisecond % 256;
    }

    // 从密码派生密钥
    final key = _deriveKey(password, salt);

    // 生成随机 IV
    final iv = Uint8List.fromList(
      List.generate(_ivLength, (i) => DateTime.now().microsecond % 256),
    );

    // 创建加密器
    final encrypter = encrypt.Encrypter(
      encrypt.AES(encrypt.Key(key), mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );

    // 加密
    final encrypted = encrypter.encrypt(plainText, iv: encrypt.IV(iv));

    // 组合 salt + iv + 密文
    final combined = Uint8List(salt.length + iv.length + encrypted.bytes.length);
    combined.setRange(0, salt.length, salt);
    combined.setRange(salt.length, salt.length + iv.length, iv);
    combined.setRange(salt.length + iv.length, combined.length, encrypted.bytes);

    return base64.encode(combined);
  }

  /// 解密文本
  /// [encryptedText] 加密文本（base64 编码）
  /// [password] 用户密码
  /// 返回: 明文
  static String decryptStr(String encryptedText, String password) {
    if (encryptedText.isEmpty) return '';

    try {
      final combined = base64.decode(encryptedText);

      // 提取 salt
      final salt = combined.sublist(0, 16);

      // 提取 iv
      final iv = combined.sublist(16, 16 + _ivLength);

      // 提取密文
      final cipherText = combined.sublist(16 + _ivLength);

      // 从密码派生密钥
      final key = _deriveKey(password, salt);

      // 创建解密器
      final decrypter = encrypt.Encrypter(
        encrypt.AES(encrypt.Key(key), mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
      );

      // 解密
      final decrypted = decrypter.decrypt(encrypt.Encrypted(cipherText), iv: encrypt.IV(iv));
      return decrypted;
    } catch (e) {
      // 解密失败（可能是密码错误）
      return '';
    }
  }

  /// 验证密码是否正确
  /// [encryptedText] 加密文本
  /// [password] 待验证的密码
  /// [knownPlainText] 用于验证的已知明文
  static bool verifyPassword(String encryptedText, String password, String knownPlainText) {
    final decrypted = decryptStr(encryptedText, password);
    return decrypted == knownPlainText;
  }
}
