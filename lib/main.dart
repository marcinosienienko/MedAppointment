import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/data/repositories/auth_repository.dart';
import 'package:medical_app/data/repositories/user_repository.dart';
import 'package:medical_app/data/viewmodels/doctor_viewmodel.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';
import 'package:medical_app/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/presentation/pages/login_page.dart';
import 'package:medical_app/presentation/pages/profile_page.dart';
import 'package:medical_app/presentation/pages/register_page.dart';
import 'package:medical_app/presentation/widgets/navigation_bar.dart';
import 'package:medical_app/core/theme/app_colors.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:medical_app/data/viewmodels/register_page_viewmodel.dart';
import 'package:medical_app/data/viewmodels/login_page_viewmodel.dart';
import 'package:medical_app/data/viewmodels/auth_view_model.dart';
import 'package:medical_app/presentation/pages/dashboard_page.dart';
import 'package:medical_app/data/viewmodels/user_viewmodel.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';
import 'package:medical_app/presentation/pages/prescriptions_page.dart';
import 'package:medical_app/presentation/pages/referrals_page.dart';
import 'package:medical_app/data/services/secure_encryption_service.dart';
import 'package:medical_app/data/repositories/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('pl_PL', null);

  final encryptionService = SecureEncryptionService();

  await encryptionService.saveAESKeyAndIV();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => AuthRepository()),
        Provider(create: (context) => UserRepository()),
        ChangeNotifierProvider(create: (_) => SlotViewModel()),
        ChangeNotifierProvider(
            create: (_) => DoctorViewModel()..fetchDoctors()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(context.read<UserRepository>()),
        ),
        ChangeNotifierProvider(create: (_) => AppointmentsViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Appointments',
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primary,
          selectionColor: AppColors.primary.withOpacity(0.5),
          selectionHandleColor: AppColors.primary,
        ),
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => BottomNavigation(initialPageIndex: 0),
        '/profile': (context) => ProfilePage(),
        '/dashboard': (context) => DashboardPage(),
        '/prescriptions': (context) => PrescriptionsPage(),
        '/referrals': (context) => ReferralsPage(),
        //'/doctorlist': (context) => DoctorListScreen(),
        //'/test-page': (context) => TestFirestorePage()
      },
    );
  }
}
