import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';
import 'package:medical_app/data/viewmodels/appointments_viewmodel.dart';
import 'package:medical_app/data/viewmodels/user_viewmodel.dart';
import 'package:medical_app/presentation/widgets/calendar_widget.dart';
import 'package:medical_app/presentation/widgets/slot_grid.dart';
import 'package:medical_app/presentation/widgets/buttons/reserve_button.dart';

class CalendarPage extends StatefulWidget {
  final String doctorId;

  CalendarPage({required this.doctorId});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final slotViewModel = Provider.of<SlotViewModel>(context, listen: false);
      slotViewModel.setCurrentDoctorId(widget.doctorId);
      slotViewModel.clearSelectedSlot();
    });
  }

  @override
  Widget build(BuildContext context) {
    final slotViewModel = Provider.of<SlotViewModel>(context);
    final appointmentsViewModel =
        Provider.of<AppointmentsViewModel>(context, listen: false);
    final userId =
        Provider.of<UserViewModel>(context, listen: false).currentUser?.id ??
            '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalendarz wizyt'),
      ),
      body: Column(
        children: [
          CalendarWidget(slotViewModel: slotViewModel),
          Expanded(child: SlotGrid(slotViewModel: slotViewModel)),
          ReserveButton(
              slotViewModel: slotViewModel,
              appointmentsViewModel: appointmentsViewModel,
              userId: userId),
        ],
      ),
    );
  }
}
