import 'package:employee_mobile/models/attendance_history.dart';
import 'package:employee_mobile/viewmodels/attendance_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttendanceHistoryPage extends StatelessWidget {
  const AttendanceHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Attendance History'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ChangeNotifierProvider<AttendanceHistoryViewModel>(
        create: (_) => AttendanceHistoryViewModel()..fetchAttendanceHistory(),
        child: Consumer<AttendanceHistoryViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () async {
                await viewModel.fetchAttendanceHistory();
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: viewModel.history.length,
                itemBuilder: (context, index) {
                  final history = viewModel.history[index];

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Attendance ${index + 1}',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat('EEEE, d MMMM yyyy')
                                  .format(history.checkInTime),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () =>
                              _dialogBuilder(context, index, history),
                          icon: Icon(
                            Icons.info_rounded,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(
      BuildContext context, int index, AttendanceHistory history) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Attendance ${index + 1} Details',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Date: \n'
            '${DateFormat('EEEE, d MMMM yyyy').format(history.checkInTime)}\n'
            '\nCheck In: \n'
            '${DateFormat('Hm').format(history.checkInTime)}\n'
            '\nCheck Out: \n'
            '${history.checkOutTime.year > 1 ? DateFormat('Hm').format(history.checkOutTime) : '--:--'}',
            style:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
