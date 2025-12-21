import 'package:flutter/material.dart';
import '../widgets/appointment_widgets.dart';
import '../models/appointment.dart';
import 'book_appointment_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _loadAppointments() {
    setState(() {
      appointments = [
        Appointment(
          id: '1',
          petName: 'Max',
          ownerName: 'John Doe',
          phoneNumber: '+1234567890',
          email: 'john@email.com',
          petType: 'Dog',
          petBreed: 'Golden Retriever',
          petAge: '3 years',
          appointmentDate: DateTime.now().add(const Duration(days: 2)),
          appointmentTime: const TimeOfDay(hour: 10, minute: 30),
          reason: 'Annual Checkup',
          symptoms: 'None',
          emergency: false,
          vetPreference: 'Dr. Smith',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Appointment(
          id: '2',
          petName: 'Whiskers',
          ownerName: 'Jane Smith',
          phoneNumber: '+0987654321',
          email: 'jane@email.com',
          petType: 'Cat',
          petBreed: 'Siamese',
          petAge: '5 years',
          appointmentDate: DateTime.now().add(const Duration(days: 5)),
          appointmentTime: const TimeOfDay(hour: 14, minute: 0),
          reason: 'Vaccination',
          symptoms: 'Slight lethargy',
          emergency: true,
          vetPreference: 'Any',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Appointment(
          id: '3',
          petName: 'jack',
          ownerName: 'Jane Smith',
          phoneNumber: '+0987654321',
          email: 'jane@email.com',
          petType: 'Cat',
          petBreed: 'Siamese',
          petAge: '5 years',
          appointmentDate: DateTime.now().add(const Duration(days: -225)),
          appointmentTime: const TimeOfDay(hour: 14, minute: 0),
          reason: 'Vaccination',
          symptoms: 'Slight lethargy',
          emergency: true,
          vetPreference: 'Any',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Appointment(
          id: '4',
          petName: 'angela',
          ownerName: 'Jane Smith',
          phoneNumber: '+0987654321',
          email: 'jane@email.com',
          petType: 'Cat',
          petBreed: 'Siamese',
          petAge: '5 years',
          appointmentDate: DateTime.now().add(const Duration(days: -115)),
          appointmentTime: const TimeOfDay(hour: 14, minute: 0),
          reason: 'Vaccination',
          symptoms: 'Slight lethargy',
          emergency: true,
          vetPreference: 'Any',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
    });
  }

  void _addAppointment(Appointment newAppointment) {
    setState(() {
      appointments.add(newAppointment);
    });
  }

  void _deleteAppointment(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text(
          'Are you sure you want to cancel this appointment?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                appointments.removeWhere((appt) => appt.id == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointment cancelled successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: appointments.isEmpty
            ? EmptyAppointmentsWidget(
                onBookAppointment: () => _navigateToBookAppointment(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming Appointments (${appointments.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];
                        return AppointmentCard(
                          appointment: appointment,
                          onDelete: () => _deleteAppointment(appointment.id),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: appointments.isNotEmpty
          ? BookAppointmentButton(onPressed: () => _navigateToBookAppointment())
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _navigateToBookAppointment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookAppointmentScreen()),
    );

    if (result != null && result is Appointment) {
      _addAppointment(result);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment booked successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
