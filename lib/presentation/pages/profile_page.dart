import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../data/viewmodels/auth_view_model.dart';
import '../../data/viewmodels/user_viewmodel.dart';
import '../../presentation/widgets/buttons/primary_button.dart';
import '../../presentation/widgets/inputs/base_input.dart';
import '../../presentation/widgets/user_info_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController apartmentNumberController =
      TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController peselController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userViewModel =
        Provider.of<UserViewModel>(context, listen: false).currentUser;

    if (userViewModel != null) {
      phoneNumberController.text = userViewModel.phoneNumber;
      streetController.text = userViewModel.street ?? '';
      houseNumberController.text = userViewModel.houseNumber ?? '';
      apartmentNumberController.text = userViewModel.apartmentNumber ?? '';
      cityController.text = userViewModel.city ?? '';
      peselController.text = userViewModel.pesel ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context);
    final user = userViewModel.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: user != null
            ? Text('Witaj, ${user.firstName}!')
            : const Text('Profil użytkownika'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white,
        child: user != null
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Avatar użytkownika
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blueGrey,
                          backgroundImage: user.avatarUrl != null
                              ? NetworkImage(user.avatarUrl!)
                              : null,
                          child: user.avatarUrl == null
                              ? Text(
                                  '${user.firstName[0]}${user.lastName[0]}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (isEditing)
                        _buildEditForm(userViewModel)
                      else
                        UserInfoCard(user: user),
                      const SizedBox(height: 24),
                      if (!isEditing)
                        PrimaryButton(
                          text: 'Edytuj dane',
                          onPressed: () {
                            setState(() {
                              isEditing = true;
                            });
                          },
                        ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: authViewModel.isLoading
                            ? 'Wylogowywanie...'
                            : 'Wyloguj',
                        onPressed: authViewModel.isLoading
                            ? null
                            : () async {
                                final success = await authViewModel.logout();
                                if (success) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/login',
                                    (route) => false,
                                  );
                                }
                              },
                      ),
                    ],
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget _buildEditForm(UserViewModel userViewModel) {
    return Column(
      children: [
        BaseTextField(
          controller: phoneNumberController,
          hintText: 'Numer telefonu',
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(9),
          ],
        ),
        const SizedBox(height: 16),
        BaseTextField(
          controller: streetController,
          hintText: 'Ulica',
          prefixIcon: Icons.location_on,
        ),
        const SizedBox(height: 16),
        BaseTextField(
          controller: houseNumberController,
          hintText: 'Numer domu',
          prefixIcon: Icons.home,
        ),
        const SizedBox(height: 16),
        BaseTextField(
          controller: apartmentNumberController,
          hintText: 'Numer mieszkania',
          prefixIcon: Icons.apartment,
        ),
        const SizedBox(height: 16),
        BaseTextField(
          controller: cityController,
          hintText: 'Miasto',
          prefixIcon: Icons.location_city,
        ),
        const SizedBox(height: 16),
        BaseTextField(
          controller: peselController,
          hintText: 'PESEL',
          prefixIcon: Icons.security,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: 'Zapisz',
                onPressed: () async {
                  await userViewModel.updateUserProfile(
                    phoneNumber: phoneNumberController.text,
                    street: streetController.text,
                    houseNumber: houseNumberController.text,
                    apartmentNumber: apartmentNumberController.text,
                    city: cityController.text,
                    pesel: peselController.text,
                  );
                  await userViewModel.fetchUserData();
                  setState(() {
                    isEditing = false;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: PrimaryButton(
                text: 'Anuluj',
                color: Colors.grey,
                textColor: Colors.black,
                onPressed: () {
                  setState(() {
                    isEditing = false;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
