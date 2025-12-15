//settings_page.dart

import 'package:flutter/material.dart';
import 'package:vet_clinic/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool remindersEnabled = true;
  bool darkModeEnabled = false;
  String selectedLanguage = 'English';

  void Logout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _headerCard(),
          const SizedBox(height: 28),

          _sectionTitle('Preferences'),
          _settingsSwitch(
            icon: Icons.notifications_active_outlined,
            title: 'Notifications',
            subtitle: 'Enable system notifications',
            value: notificationsEnabled,
            onChanged: (val) => setState(() => notificationsEnabled = val),
          ),
          _settingsSwitch(
            icon: Icons.alarm_outlined,
            title: 'Appointment Reminders',
            subtitle: 'Receive visit reminders',
            value: remindersEnabled,
            onChanged: (val) => setState(() => remindersEnabled = val),
          ),
          _settingsSwitch(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Reduce eye strain',
            value: darkModeEnabled,
            onChanged: (val) => setState(() => darkModeEnabled = val),
          ),

          const SizedBox(height: 26),

          _sectionTitle('General'),
          _settingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: selectedLanguage,
            onTap: _selectLanguage,
          ),

          _settingsTile(
            icon: Icons.info_outline_rounded,
            title: 'About App',
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),

          const SizedBox(height: 30),

          _sectionTitle('Security'),
          _settingsTile(
            icon: Icons.lock_outline_rounded,
            title: 'Privacy & Security',
            subtitle: 'Session & data protection',
            onTap: () {},
          ),

          const SizedBox(height: 40),

          _logoutButton(),
        ],
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF01A292), Color(0xFF3CBFAE)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: const [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.pets_rounded, size: 30, color: Color(0xFF01A292)),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vet Clinic Center',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Care • Trust • Health',
                style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.900)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _cardDecoration(),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _settingsSwitch({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _cardDecoration(),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: SwitchListTile(
          secondary: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle),
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  void _selectLanguage() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption('English'),
            _languageOption('Arabic'),
            _languageOption('French'),
          ],
        );
      },
    );
  }

  Widget _languageOption(String language) {
    return ListTile(
      title: Text(language),
      trailing: selectedLanguage == language
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () {
        setState(() => selectedLanguage = language);
        Navigator.pop(context);
      },
    );
  }

  Widget _logoutButton() {
    return GestureDetector(
      onTap: () {
        Logout();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Log Out',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
