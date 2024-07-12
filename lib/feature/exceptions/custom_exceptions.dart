class AppExceptions implements Exception {
  final String message;
  final String? details;
  final String? code;

  AppExceptions(this.message, {this.details, this.code});

  @override
  String toString() {
    if (details != null && code != null) {
      return 'AppException: $message (Code: $code, Details: $details)';
    } else if (details != null) {
      return 'AppException: $message (Details: $details)';
    } else if (code != null) {
      return 'AppException: $message (Code: $code)';
    } else {
      return 'AppException: $message';
    }
  }

  String userMessage() {
 
    if (code == 'invalid-input') {
      return 'Girilen bilgiler geçersiz, lütfen tekrar deneyin.';
    } else if (code == 'network-error') {
      return 'Bağlantı hatası, lütfen internet bağlantınızı kontrol edin.';
    } else {
      return 'Beklenmeyen bir hata oluştu, lütfen daha sonra tekrar deneyin.';
    }
  }
}


class NetworkException extends AppExceptions {
  NetworkException({String? details})
      : super('Ağ hatası oluştu', details: details, code: 'network-error');
}
