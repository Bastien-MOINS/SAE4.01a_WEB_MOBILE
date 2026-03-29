import "package:app_mobile/screens/connection_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group("Tests InscrConectScreen", () {

    testWidgets("Vérifie l'affichage initial(mode connexion)", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InscrConectScreen()));
      expect(find.text("Connexion"), findsWidgets);
      expect(find.text("Pseudo"), findsOneWidget);
      expect(find.text("Mot de passe"), findsOneWidget);
      expect(find.text("Pas de compte ? S'inscrire"), findsOneWidget);
    });

    testWidgets("Test le changement entre la page connexion et inscription", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InscrConectScreen()));
      final toggleButton = find.text("Pas de compte ? S'inscrire");
      await tester.tap(toggleButton);
      await tester.pumpAndSettle();
      expect(find.text("Inscription"), findsWidgets);
      expect(find.text("Déjà un compte ? Se connecter"), findsOneWidget);
    });

    testWidgets("Affiche une erreur si les champs sont vides au clic", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InscrConectScreen()));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      // Texte affiché deux fois, dans le hintText, et le RequiredValidator(errorText:)
      expect(find.text("Entrez votre pseudo"), findsNWidgets(2));
      expect(find.text("Entrez votre mot de passe"), findsNWidgets(2));
    });

    testWidgets("Simule et vérifie si tout marche", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InscrConectScreen()));
      final pseudoField = find.widgetWithText(TextFormField, "Pseudo");
      await tester.enterText(pseudoField, "Nicolas");
      expect(find.text("Nicolas"), findsOneWidget);
    });
  });
}