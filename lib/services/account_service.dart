class AccountService {

  Map<String, String> account = {
    'utente1@email.com': 'musica123',
    'utente2@email.com': 'musica123',
    'utente3@email.com': 'musica123',
    'utente4@email.com': 'musica123',
  };

  // Verifica le credenziali
  bool verificaAccesso(String email, String password) {

    if (account.containsKey(email) && account[email] == password) {
      return true;
    } else {
      return false;
    }

  }

}