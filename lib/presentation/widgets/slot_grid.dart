import 'package:flutter/material.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';

class SlotGrid extends StatelessWidget {
  final SlotViewModel slotViewModel;

  const SlotGrid({Key? key, required this.slotViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: slotViewModel.slots.isNotEmpty
          ? GridView.builder(
              key: ValueKey(slotViewModel.selectedDay),
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: slotViewModel.slots.length,
              itemBuilder: (context, index) {
                final slot = slotViewModel.slots[index];
                final isSelected = slotViewModel.selectedSlot == slot;
                final isAvailable = slotViewModel.isSlotAvailable(slot);

                return GestureDetector(
                  onTap: isAvailable
                      ? () {
                          if (isSelected) {
                            slotViewModel.clearSelectedSlot();
                          } else {
                            slotViewModel.selectSlot(slot);
                          }
                        }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue
                          : (isAvailable ? Colors.grey[300] : Colors.red[200]),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${slot.startTime.toString().padLeft(2, '0')}',
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        if (!isAvailable)
                          Text(
                            'Zajęty',
                            style: TextStyle(
                                color: Colors.red[800],
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                'Brak dostępnych slotów na ten dzień',
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
            ),
    );
  }
}
