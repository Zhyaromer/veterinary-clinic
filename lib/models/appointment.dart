import 'package:flutter/material.dart';

class Appointment {
  final String id;
  final String petName;
  final String ownerName;
  final String phoneNumber;
  final String email;
  final String petType;
  final String petBreed;
  final String petAge;
  final DateTime appointmentDate;
  final TimeOfDay appointmentTime;
  final String reason;
  final String symptoms;
  final bool emergency;
  final String vetPreference; 
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.petName,
    required this.ownerName,
    required this.phoneNumber,
    required this.email,
    required this.petType,
    required this.petBreed,
    required this.petAge,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.reason,
    required this.symptoms,
    required this.emergency,
    required this.vetPreference, 
    required this.createdAt,
  });

  String get formattedDate {
    final day = appointmentDate.day.toString().padLeft(2, '0');
    final month = appointmentDate.month.toString().padLeft(2, '0');
    final year = appointmentDate.year.toString();
    return '$day/$month/$year';
  }

  String get formattedTime {
    final hour = appointmentTime.hourOfPeriod;
    final minute = appointmentTime.minute.toString().padLeft(2, '0');
    final period = appointmentTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Color get statusColor {
    final now = DateTime.now();
    if (appointmentDate.isBefore(DateTime(now.year, now.month, now.day))) {
      return Colors.grey; 
    } else if (appointmentDate.day == now.day &&
        appointmentDate.month == now.month &&
        appointmentDate.year == now.year) {
      return Colors.green; 
    } else {
      return Colors.blue; 
    }
  }

  String get statusText {
    final now = DateTime.now();
    if (appointmentDate.isBefore(DateTime(now.year, now.month, now.day))) {
      return 'Completed';
    } else if (appointmentDate.day == now.day &&
        appointmentDate.month == now.month &&
        appointmentDate.year == now.year) {
      return 'Today';
    } else {
      final difference = appointmentDate
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
      return 'In $difference days';
    }
  }
}
