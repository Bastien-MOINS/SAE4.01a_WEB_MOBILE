import 'package:app_mobile/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  //section tests d'intégration
  group('Tests AuthRepository', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test("Apres inscription, si c'est le même pseudo est mdp ça marche", () async {
      final authRepository = AuthRepository();
      const pseudo = "Nicolas";
      const mdp = "mdp123";
      await authRepository.register(pseudo, mdp);
      final resultat = await authRepository.login(pseudo, mdp);
      expect(resultat, isTrue);
    });

    test("Si mot de passe pas bon : Echec", () async {
      final authRepository = AuthRepository();
      await authRepository.register("Nicolas", "mdp123");
      final resultat = await authRepository.login("Nicolas", "aaaa");
      expect(resultat, isFalse);
    });

    test("La variable isConnected doit passer à true après s'être connécté et "
        "retourner à false quand on se déconnecte", () async {
      final authRepository = AuthRepository();
      await authRepository.register("Nicolas", "mdp123");
      expect(await authRepository.isConnected(), isFalse);

      await authRepository.login("Nicolas", "mdp123");
      expect(await authRepository.isConnected(), isTrue);

      await authRepository.disconnection();
      expect(await authRepository.isConnected(), isFalse);
    });

  });
}