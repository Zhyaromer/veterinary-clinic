import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/appointment_widgets.dart';
import '../../models/appointment.dart';
import '../../providers/auth_provider.dart';
import '../../services/appointments_firestore_service.dart';
import 'appointment_history_screen.dart';
import 'book_appointment_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final AppointmentsFirestoreService _appointmentsService =
      AppointmentsFirestoreService();

  Future<void> _deleteAppointment(Appointment appointment) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text(
          'Are you sure you want to cancel this appointment?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _appointmentsService.deleteAppointment(appointment.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment cancelled successfully'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to cancel appointment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToBookAppointment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BookAppointmentScreen()),
    );

    if (result is Appointment) {
      final user = context.read<AuthProvider>().user;
      if (user == null) return;

      try {
        await _appointmentsService.addAppointmentForUser(
          ownerId: user.uid,
          appointment: result,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment booked successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book appointment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<List<Appointment>>(
          stream: user == null
              ? const Stream<List<Appointment>>.empty()
              : _appointmentsService.getAppointmentsStreamForUser(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final allAppointments = snapshot.data ?? [];
            final todayStart = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            );

            final upcomingAppointments =
                allAppointments
                    .where((a) => !a.appointmentDate.isBefore(todayStart))
                    .toList()
                  ..sort((a, b) {
                    final cmp = a.appointmentDate.compareTo(b.appointmentDate);
                    if (cmp != 0) return cmp;
                    final aMins =
                        a.appointmentTime.hour * 60 + a.appointmentTime.minute;
                    final bMins =
                        b.appointmentTime.hour * 60 + b.appointmentTime.minute;
                    return aMins.compareTo(bMins);
                  });

            if (upcomingAppointments.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upcoming Appointments (0)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AppointmentHistoryScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.history),
                        label: const Text('History'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: EmptyAppointmentsWidget(
                      onBookAppointment: _navigateToBookAppointment,
                    ),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Appointments (${upcomingAppointments.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AppointmentHistoryScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.history),
                      label: const Text('History'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: upcomingAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = upcomingAppointments[index];
                      return AppointmentCard(
                        appointment: appointment,
                        onDelete: () => _deleteAppointment(appointment),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: BookAppointmentButton(
        onPressed: _navigateToBookAppointment,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
