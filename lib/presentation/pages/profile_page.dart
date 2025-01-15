import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/data/viewmodels/auth_view_model.dart';
import 'package:medical_app/data/viewmodels/user_vievmodel.dart';
import 'package:medical_app/presentation/widgets/buttons/PrimaryButton.dart';
import 'package:medical_app/presentation/widgets/inputs/name_input.dart';
import 'package:medical_app/presentation/widgets/inputs/phone_number_input.dart';
import 'package:medical_app/presentation/widgets/inputs/base_input.dart';
import 'package:medical_app/presentation/widgets/user_info_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
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
      firstNameController.text = userViewModel.firstName;
      lastNameController.text = userViewModel.lastName;
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
        automaticallyImplyLeading: false,
        title: const Text('Profil użytkownika'),
        backgroundColor: Colors.blue,
      ),
      body: user != null
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
                      Column(
                        children: [
                          NameInput(
                            controller: firstNameController,
                            hintText: 'Imię',
                            validationType: ValidationType.name,
                            prefixIcon: Icons.person,
                          ),
                          const SizedBox(height: 16),
                          NameInput(
                            controller: lastNameController,
                            hintText: 'Nazwisko',
                            validationType: ValidationType.surname,
                            prefixIcon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          PhoneNumberInput(controller: phoneNumberController),
                          const SizedBox(height: 16),
                          BaseTextField(
                            controller: streetController,
                            hintText: 'Ulica',
                            prefixIcon: Icons.location_on,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[a-zA-Z\s]*$')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Podaj ulicę';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          BaseTextField(
                            controller: houseNumberController,
                            hintText: 'Numer domu',
                            prefixIcon: Icons.home,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[0-9a-zA-Z/]*$')),
                            ],
                          ),
                          const SizedBox(height: 16),
                          BaseTextField(
                            controller: apartmentNumberController,
                            hintText: 'Numer mieszkania',
                            prefixIcon: Icons.apartment,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[0-9a-zA-Z/]*$')),
                            ],
                          ),
                          const SizedBox(height: 16),
                          BaseTextField(
                            controller: cityController,
                            hintText: 'Miasto',
                            prefixIcon: Icons.location_city,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[a-zA-Z\s]*$')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Podaj miasto';
                              }
                              return null;
                            },
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Podaj numer PESEL';
                              }
                              if (value.length != 11) {
                                return 'PESEL musi mieć 11 cyfr';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(
                                  onPressed: () async {
                                    print("Dane do aktualizacji: ${{
                                      'firstName': firstNameController.text,
                                      'lastName': lastNameController.text,
                                      'phoneNumber': phoneNumberController.text,
                                      'street': streetController.text,
                                      'houseNumber': houseNumberController.text,
                                      'apartmentNumber':
                                          apartmentNumberController.text,
                                      'city': cityController.text,
                                      'pesel': peselController.text,
                                    }}");

                                    await userViewModel.updateUserProfile(
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      phoneNumber: phoneNumberController.text,
                                      street: streetController.text,
                                      houseNumber: houseNumberController.text,
                                      apartmentNumber:
                                          apartmentNumberController.text,
                                      city: cityController.text,
                                      pesel: peselController.text,
                                    );
                                    await userViewModel.fetchUserData();

                                    setState(() {
                                      isEditing = false;
                                    });
                                  },
                                  text: 'Zapisz',
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
                      )
                    else
                      UserInfoCard(user: user),
                    const SizedBox(height: 24),
                    if (!isEditing)
                      PrimaryButton(
                        text: 'Uzupełnij dane',
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
    );
  }
}
