import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/appointment.dart';
import '../../providers/auth_provider.dart';
import '../../services/appointments_firestore_service.dart';
import '../../widgets/appointment_widgets.dart';

class AppointmentHistoryScreen extends StatelessWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Appointment History'),
          backgroundColor: const Color(0xFF4A6FA5),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('Please sign in to view history.')),
      );
    }

    final AppointmentsFirestoreService service = AppointmentsFirestoreService();
    final todayStart = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Appointment History'),
        backgroundColor: const Color(0xFF4A6FA5),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<List<Appointment>>(
          stream: service.getAppointmentsStreamForUser(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final all = snapshot.data ?? [];
            final history = all
                .where((a) => a.appointmentDate.isBefore(todayStart))
                .toList();

            if (history.isEmpty) {
              return const Center(
                child: Text(
                  'No past appointments yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final appointment = history[index];
                return AppointmentCard(appointment: appointment);
              },
            );
          },
        ),
      ),
    );
  }
}
