enum DomainError {
  unexpected,
  invalidCredentials,
}

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return 'Credenciais inválidas';
      default:
        return 'Um erro desconhecido ocorreu. Tente novamente ou entre em contato conosco';
    }
  }
}
