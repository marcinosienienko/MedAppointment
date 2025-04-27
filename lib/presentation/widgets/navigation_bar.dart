import 'package:flutter/material.dart';
import 'package:medical_app/presentation/pages/dashboard_page.dart';
import 'package:medical_app/presentation/pages/appointments_page.dart';
import 'package:medical_app/core/theme/app_colors.dart';
import 'package:medical_app/presentation/pages/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';
import 'package:medical_app/data/viewmodels/user_viewmodel.dart';

class BottomNavigation extends StatefulWidget {
  final int initialPageIndex;

  const BottomNavigation({super.key, required this.initialPageIndex});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int currentPageIndex;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialPageIndex;
  }

  final List<Widget> _pages = [
    const DashboardPage(), // Dashboard
    AppointmentsPage(), // Wizyty
    const ProfilePage(), // Profil
  ];

  @override
  Widget build(BuildContext context) {
    final appointmentsViewModel =
        Provider.of<AppointmentsViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) async {
          if (index == 1) {
            // Zakładka "Wizyty"
            final userId = userViewModel.currentUser?.id ?? '';
            await appointmentsViewModel.fetchAppointments(userId);
          }

          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: AppColors.primaryLight,
        backgroundColor: Colors.white,
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Wizyty',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outlined),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
