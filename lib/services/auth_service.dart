class AuthService {
  static String? emailCadastrado;
  static String? senhaCadastrada;

  static void cadastrar(String email, String senha) {
    emailCadastrado = email;
    senhaCadastrada = senha;
  }

  static bool login(String email, String senha) {
    return email == emailCadastrado &&
           senha == senhaCadastrada;
  }
}