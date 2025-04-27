import 'package:flutter/material.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';
import 'package:medical_app/presentation/widgets/buttons/primary_button.dart';

class ReserveButton extends StatelessWidget {
  final SlotViewModel slotViewModel;
  final AppointmentsViewModel appointmentsViewModel;
  final String userId;

  const ReserveButton(
      {Key? key,
      required this.slotViewModel,
      required this.appointmentsViewModel,
      required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100, left: 16.0, right: 16.0),
      child: PrimaryButton(
        text: 'Zarezerwuj wizytę',
        onPressed: slotViewModel.selectedSlot == null
            ? null
            : () async {
                await appointmentsViewModel.handleAppointmentReservation(
                    context, userId, slotViewModel);
              },
      ),
    );
  }
}
