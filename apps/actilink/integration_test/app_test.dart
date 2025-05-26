import 'dart:developer';

import 'package:actilink/auth/logic/auth_state.dart';
import 'package:actilink/auth/view/welcome_screen.dart';
import 'package:actilink/events/logic/events_cubit.dart';
import 'package:actilink/events/logic/events_state.dart';
import 'package:actilink/events/logic/hobby_cubit.dart';
import 'package:actilink/events/logic/hobby_state.dart';
import 'package:actilink/home/main_shell.dart';
import 'package:actilink/venues/logic/venues_cubit.dart';
import 'package:actilink/venues/logic/venues_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ui/ui.dart';

import 'bloc/controllable_auth_cubit.dart';
import 'helpers/helpers.dart';

// Mock classes for cubits

class MockEventsCubit extends MockCubit<EventsState> implements EventsCubit {}

class MockHobbiesCubit extends MockCubit<HobbiesState>
    implements HobbiesCubit {}

class MockVenuesCubit extends MockCubit<VenuesState> implements VenuesCubit {}

class BuildContextFake extends Fake implements BuildContext {}

class AuthStateFake extends Fake implements AuthState {}

class EventsStateFake extends Fake implements EventsState {}

class HobbiesStateFake extends Fake implements HobbiesState {}

class VenuesStateFake extends Fake implements VenuesState {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(BuildContextFake());
    registerFallbackValue(AuthStateFake());
    registerFallbackValue(EventsStateFake());
    registerFallbackValue(HobbiesStateFake());
    registerFallbackValue(VenuesStateFake());
  });

  late ControllableAuthCubit mockAuthCubit;
  late MockEventsCubit mockEventsCubit;
  late MockHobbiesCubit mockHobbiesCubit;
  late MockVenuesCubit mockVenuesCubit;

  setUp(() {
    mockAuthCubit = ControllableAuthCubit();
    mockEventsCubit = MockEventsCubit();
    mockHobbiesCubit = MockHobbiesCubit();
    mockVenuesCubit = MockVenuesCubit();

    // Ensure we always start from the welcome screen by setting auth state to unauthenticated
    mockAuthCubit.emit(const AuthUnauthenticated());

    // --- Initial State Stubbing ---
    when(() => mockEventsCubit.state).thenReturn(const EventsState());
    when(() => mockHobbiesCubit.state).thenReturn(const HobbiesState());
    when(() => mockVenuesCubit.state).thenReturn(const VenuesState());

    // --- Method Stubbing for Other Cubits (Fetch Data) ---
    mockEventsCubit.whenFunctionEmit(
      () => mockEventsCubit.fetchEvents(),
      const EventsState(status: EventsStatus.success),
    );

    mockHobbiesCubit.whenFunctionEmit(
      () => mockHobbiesCubit.fetchHobbies(),
      const HobbiesState(status: HobbiesStatus.success),
    );

    mockVenuesCubit.whenFunctionEmit(
      () => mockVenuesCubit.fetchVenues(),
      const VenuesState(status: VenuesStatus.success),
    );
  });

  tearDown(() async {
    try {
      await mockAuthCubit.close();
      await mockEventsCubit.close();
      await mockHobbiesCubit.close();
      await mockVenuesCubit.close();
    } catch (e) {
      log('Error during tearDown: $e');
    }
  });

  group('App Navigation Flows', () {
    testWidgets('Login flow: Welcome -> Login -> Events Tab',
        (WidgetTester tester) async {
      await tester.pumpApp(
        authCubit: mockAuthCubit,
        eventsCubit: mockEventsCubit,
        hobbiesCubit: mockHobbiesCubit,
        venuesCubit: mockVenuesCubit,
      );
      await tester.pumpAndSettle();

      // 1. Welcome Screen: Tap "I already have an account"
      expect(find.byType(WelcomeScreen), findsOneWidget);
      final iHaveAccountButton =
          find.widgetWithText(AppButton, 'I already have an account');
      expect(iHaveAccountButton, findsOneWidget);
      await tester.tap(iHaveAccountButton);
      await tester.pumpAndSettle(); // To show SelectUserTypeModalLogin

      // 2. SelectUserTypeModalLogin: Tap "Regular User"
      expect(find.text('Welcome Back'), findsOneWidget);
      final regularUserLoginButton =
          find.widgetWithText(AppButton, 'Regular User');
      expect(regularUserLoginButton, findsOneWidget);
      await tester.tap(regularUserLoginButton);
      await tester.pumpAndSettle(); // To show LoginModal

      // 3. LoginModal: Enter credentials and sign in
      expect(find.text('Sign into your account'), findsOneWidget);
      final emailField = findAppTextFieldByLabel('Email');
      final passwordField = findAppTextFieldByLabel('Password');
      await tester.enterText(emailField, 'correct@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      final signInButton = find.widgetWithText(AppButton, 'Sign In');
      await tester.tap(signInButton);
      await tester.pumpAndSettle(
        const Duration(seconds: 2),
      ); // Process login and navigate

      // 4. Verify Navigation to MainShell (Events tab)
      expect(
        find.byType(MainShell),
        findsOneWidget,
        reason: 'MainShell should be visible after login',
      );
      final bottomNavBar = find.byType(BottomNavigationBar);
      expect(bottomNavBar, findsOneWidget);
      final navBarWidget = tester.widget<BottomNavigationBar>(bottomNavBar);
      expect(
        navBarWidget.currentIndex,
        equals(0),
        reason: 'Events tab (index 0) should be selected',
      );

      expect(mockAuthCubit.isLoggedIn, isTrue);
      expect(mockAuthCubit.user?.email, equals('correct@example.com'));
    });

    testWidgets('Registration flow: Welcome -> Register -> Events Tab',
        (WidgetTester tester) async {
      await tester.pumpApp(
        authCubit: mockAuthCubit,
        eventsCubit: mockEventsCubit,
        hobbiesCubit: mockHobbiesCubit,
        venuesCubit: mockVenuesCubit,
      );
      await tester.pumpAndSettle();

      final getStartedButton = find.widgetWithText(AppButton, 'Get started');
      expect(getStartedButton, findsOneWidget);
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle(); // To show SelectUserTypeModalRegister

      // 2. SelectUserTypeModalRegister: Tap "Regular User"
      expect(find.text('Create an Account'), findsOneWidget);
      final regularUserRegisterButton =
          find.widgetWithText(AppButton, 'Regular User');
      expect(regularUserRegisterButton, findsOneWidget);
      await tester.tap(regularUserRegisterButton);
      await tester.pumpAndSettle(); // To show RegisterModal

      // 3. RegisterModal: Enter details and sign up
      expect(find.text('Create an Account'), findsOneWidget);
      final emailField = findAppTextFieldByLabel('Email');
      final usernameField = findAppTextFieldByLabel('Username');
      final passwordField = findAppTextFieldByLabel('Password');
      final confirmPasswordField = findAppTextFieldByLabel('Confirm Password');
      await tester.enterText(usernameField, 'New Registered User');
      await tester.enterText(emailField, 'register@example.com');
      await tester.enterText(passwordField, 'Newpassword123.');
      await tester.enterText(confirmPasswordField, 'Newpassword123.');
      await tester.pumpAndSettle();

      final signUpButton = find.widgetWithText(AppButton, 'Sign Up');
      await tester.tap(signUpButton);
      await tester.pumpAndSettle(
        const Duration(seconds: 2),
      ); // Process registration and navigate

      // 4. Verify Navigation to MainShell (Events tab)
      expect(find.byType(MainShell), findsOneWidget);
      final bottomNavBar = find.byType(BottomNavigationBar);
      expect(bottomNavBar, findsOneWidget);
      final navBarWidget = tester.widget<BottomNavigationBar>(bottomNavBar);
      expect(navBarWidget.currentIndex, equals(0));

      expect(mockAuthCubit.isLoggedIn, isTrue);
      expect(mockAuthCubit.user?.email, equals('register@example.com'));
    });

    testWidgets('Business Login flow: Welcome -> Business Login -> Events Tab',
        (WidgetTester tester) async {
      await tester.pumpApp(
        authCubit: mockAuthCubit,
        eventsCubit: mockEventsCubit,
        hobbiesCubit: mockHobbiesCubit,
        venuesCubit: mockVenuesCubit,
      );
      await tester.pumpAndSettle();

      // 1. Welcome Screen: Tap "I already have an account"
      final iHaveAccountButton =
          find.widgetWithText(AppButton, 'I already have an account');
      await tester.tap(iHaveAccountButton);
      await tester.pumpAndSettle();

      // 2. SelectUserTypeModalLogin: Tap "Business Client"
      expect(find.text('Welcome Back'), findsOneWidget);
      final businessLoginButton =
          find.widgetWithText(AppButton, 'Business Account');
      await tester.tap(businessLoginButton);
      await tester.pumpAndSettle();

      // 3. BusinessLoginModal: Enter credentials and sign in
      expect(find.text('Sign into your Business Account'), findsOneWidget);
      final emailField = findAppTextFieldByLabel('Email');
      final passwordField = findAppTextFieldByLabel('Password');
      await tester.enterText(emailField, 'business@example.com');
      await tester.enterText(passwordField, 'business123');
      final signInButton = find.widgetWithText(AppButton, 'Sign In');
      await tester.tap(signInButton);
      await tester.pumpAndSettle(
        const Duration(seconds: 2),
      ); // Process login and navigate

      // 4. Verify Navigation to MainShell (Events tab)
      expect(find.byType(MainShell), findsOneWidget);
      final bottomNavBar = find.byType(BottomNavigationBar);
      expect(bottomNavBar, findsOneWidget);
      final navBarWidget = tester.widget<BottomNavigationBar>(bottomNavBar);
      expect(navBarWidget.currentIndex, equals(0));

      expect(mockAuthCubit.isLoggedIn, isTrue);
      expect(mockAuthCubit.user?.email, equals('business@example.com'));
    });

    testWidgets(
        'Business Registration flow: Welcome -> Business Register -> Events Tab',
        (WidgetTester tester) async {
      await tester.pumpApp(
        authCubit: mockAuthCubit,
        eventsCubit: mockEventsCubit,
        hobbiesCubit: mockHobbiesCubit,
        venuesCubit: mockVenuesCubit,
      );
      await tester.pumpAndSettle();

      // 1. Welcome Screen: Tap "Get Started"
      final getStartedButton = find.widgetWithText(AppButton, 'Get started');
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle();

      // 2. SelectUserTypeModalRegister: Tap "Business Account"
      expect(find.text('Create an Account'), findsOneWidget);
      final businessRegisterButton =
          find.widgetWithText(AppButton, 'Business Account');
      await tester.tap(businessRegisterButton);
      await tester.pumpAndSettle();

      // 3. BusinessRegisterModal: Enter details and sign up
      expect(find.text('Create a Business Account'), findsOneWidget);
      final emailField = findAppTextFieldByLabel('Email');
      final usernameField = findAppTextFieldByLabel('Username');
      final taxIdField = findAppTextFieldByLabel('Tax ID');
      final passwordField = findAppTextFieldByLabel('Password');
      final confirmPasswordField = findAppTextFieldByLabel('Confirm Password');
      await tester.enterText(usernameField, 'New Business');
      await tester.enterText(emailField, 'newbusiness@example.com');
      await tester.enterText(taxIdField, 'PL789012');
      await tester.enterText(passwordField, 'Newbusiness123.');
      await tester.enterText(confirmPasswordField, 'Newbusiness123.');
      final signUpButton = find.widgetWithText(AppButton, 'Sign Up');
      await tester.tap(signUpButton);
      await tester.pumpAndSettle(
        const Duration(seconds: 2),
      ); // Process registration and navigate

      // 4. Verify Navigation to MainShell (Events tab)
      expect(find.byType(MainShell), findsOneWidget);
      final bottomNavBar = find.byType(BottomNavigationBar);
      expect(bottomNavBar, findsOneWidget);
      final navBarWidget = tester.widget<BottomNavigationBar>(bottomNavBar);
      expect(navBarWidget.currentIndex, equals(0));

      expect(mockAuthCubit.isLoggedIn, isTrue);
      expect(mockAuthCubit.user?.email, equals('newbusiness@example.com'));
    });

    testWidgets('Error handling in login flow', (WidgetTester tester) async {
      await tester.pumpApp(
        authCubit: mockAuthCubit,
        eventsCubit: mockEventsCubit,
        hobbiesCubit: mockHobbiesCubit,
        venuesCubit: mockVenuesCubit,
      );
      await tester.pumpAndSettle();

      // Navigate to login
      final iHaveAccountButton =
          find.widgetWithText(AppButton, 'I already have an account');
      await tester.tap(iHaveAccountButton);
      await tester.pumpAndSettle();

      final regularUserLoginButton =
          find.widgetWithText(AppButton, 'Regular User');
      await tester.tap(regularUserLoginButton);
      await tester.pumpAndSettle();

      // Enter wrong credentials
      final emailField = findAppTextFieldByLabel('Email');
      final passwordField = findAppTextFieldByLabel('Password');
      await tester.enterText(emailField, 'wrong@example.com');
      await tester.enterText(passwordField, 'wrongpassword');
      await tester.pumpAndSettle();

      final signInButton = find.widgetWithText(AppButton, 'Sign In');
      await tester.tap(signInButton);

      // Verify loading state
      await tester.pump();
      expect(find.widgetWithText(AppButton, 'Signing In...'), findsOneWidget);

      // Verify error is shown
      await tester.pumpAndSettle(
        const Duration(seconds: 2),
      );
      expect(find.text('Invalid credentials'), findsOneWidget);
      expect(find.byType(MainShell), findsNothing);
    });
  });
}
