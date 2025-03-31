import 'package:equatable/equatable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthToken extends Equatable {
  const AuthToken({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
    );
  }

  final String accessToken;
  final String refreshToken;

  bool get isExpired {
    final decodedToken = JwtDecoder.decode(accessToken);
    final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      (decodedToken['exp'] as int? ?? 0) * 1000,
    );
    return DateTime.now().isAfter(expiresAt);
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  AuthToken copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthToken(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
