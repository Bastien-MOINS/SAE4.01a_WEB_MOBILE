import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:app_mobile/screens/home_screen.dart";
import "package:app_mobile/repositories/auth_repository.dart";
import "package:app_mobile/repositories/flight_repository.dart";
import "package:app_mobile/models/api.dart";

import "home_screen_test.mocks.dart";

@GenerateMocks([FlightRepository, Api, AuthRepository])
void main() {
  late MockFlightRepository mockFlightRepo;
  late MockAuthRepository mockAuthRepo;
  late MockApi mockApi;

  setUp(() {
    mockFlightRepo = MockFlightRepository();
    mockAuthRepo = MockAuthRepository();
    mockApi = MockApi();
    SharedPreferences.setMockInitialValues({});
  });

  group("Tests HomeScreen", () {
    testWidgets("Affichage du texte 'Veuillez vous connecter' quand ont est connecté", (WidgetTester tester) async {
      when(mockAuthRepo.isConnected()).thenAnswer((_) async => false);
      await tester.pumpWidget(MaterialApp(
        home: HomeScreen(
          authRepository: mockAuthRepo,
          flightRepository: mockFlightRepo,
          api: mockApi,
        )
      ));
      await tester.pumpAndSettle();
      expect(find.text("Veuillez vous connecter"), findsOneWidget);
    });

    testWidgets("Affichage du texte 'Mes prochains vols' quand ont est connecté", (WidgetTester tester) async {
      when(mockAuthRepo.isConnected()).thenAnswer((_) async => true);
      when(mockFlightRepo.getSavedFlights()).thenAnswer((_) async => []);
      when(mockApi.getAirportsMap()).thenAnswer((_) async => {});
      when(mockApi.getCompagniesMap()).thenAnswer((_) async => {});
      await tester.pumpWidget(MaterialApp(
        home: HomeScreen(
          authRepository: mockAuthRepo,
          flightRepository: mockFlightRepo,
          api: mockApi,
        )
      ));
      await tester.pumpAndSettle();
      expect(find.text("Mes prochains vols"), findsOneWidget);
    });
  });
}