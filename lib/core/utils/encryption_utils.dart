import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// 암호화 유틸리티 (기본 구현, 향후 Android Keystore 통합 예정)
class EncryptionUtils {
  EncryptionUtils._();

  /// 간단한 해시 생성 (SHA-256)
  static String hash(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Base64 인코딩
  static String encodeBase64(String input) {
    return base64Encode(utf8.encode(input));
  }

  /// Base64 디코딩
  static String decodeBase64(String encoded) {
    return utf8.decode(base64Decode(encoded));
  }

  /// 데이터를 바이트로 변환
  static Uint8List stringToBytes(String input) {
    return Uint8List.fromList(utf8.encode(input));
  }

  /// 바이트를 문자열로 변환
  static String bytesToString(Uint8List bytes) {
    return utf8.decode(bytes);
  }

  /// 무작위 바이트 생성 (IV 등에 사용)
  static Uint8List generateRandomBytes(int length) {
    final random = DateTime.now().microsecondsSinceEpoch.toString();
    final hash = sha256.convert(utf8.encode(random));
    return Uint8List.fromList(hash.bytes.take(length).toList());
  }

  /// 데이터 무결성 검증용 HMAC 생성
  static String generateHmac(String data, String key) {
    final hmac = Hmac(sha256, utf8.encode(key));
    final digest = hmac.convert(utf8.encode(data));
    return digest.toString();
  }

  /// HMAC 검증
  static bool verifyHmac(String data, String key, String hmac) {
    final computedHmac = generateHmac(data, key);
    return computedHmac == hmac;
  }
}

/// 암호화된 데이터 (향후 AES-256-GCM 구현 시 사용)
class EncryptedData {
  final String ciphertext;
  final String iv;
  final String? tag;
  final Map<String, dynamic>? metadata;

  const EncryptedData({
    required this.ciphertext,
    required this.iv,
    this.tag,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'ciphertext': ciphertext,
      'iv': iv,
      if (tag != null) 'tag': tag,
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory EncryptedData.fromJson(Map<String, dynamic> json) {
    return EncryptedData(
      ciphertext: json['ciphertext'],
      iv: json['iv'],
      tag: json['tag'],
      metadata: json['metadata'],
    );
  }
}

