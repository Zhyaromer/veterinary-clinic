import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_clinic/providers/auth_provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isChecking = false;

  void _checkEmailVerified(AuthProvider authProvider) async {
    setState(() {
      _isChecking = true;
    });

    // Clear previous error messages
    authProvider.clearErrorMessage();

    await authProvider.refreshEmailVerificationStatus();

    setState(() {
      _isChecking = false;
    });

    if (mounted) {
      if (authProvider.isEmailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Email verified successfully! Welcome to VetCare.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (authProvider.errorMessage == null) {
        // Email not verified yet, but no error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Email not verified yet. Please click the verification link in your email and try again.',
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  void _resendEmail(AuthProvider authProvider) async {
    final success = await authProvider.resendVerificationEmail();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Verification email resent! Check your inbox.'
                : authProvider.errorMessage ??
                    'Failed to resend verification email.',
          ),
          backgroundColor:
              success ? Colors.green : const Color.fromARGB(255, 244, 67, 54),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF4A6FA5).withOpacity(0.9),
                  const Color(0xFF6B9F8C).withOpacity(0.9),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mail_outline,
                        size: 60,
                        color: Color(0xFF4A6FA5),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Title
                    const Text(
                      'Verify Your Email',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'We\'ve sent a verification link to\n${authProvider.user?.email}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Content Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Instructions Section
                            const Text(
                              'What\'s Next?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A6FA5),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Step 1
                            // _buildStep(
                            //   number: '1',
                            //   title: 'Check Your Email',
                            //   description:
                            //       'Look for our verification email from Firebase in your inbox. Check spam/junk folder if you don\'t see it.',
                            // ),
                            // const SizedBox(height: 12),

                            // _buildStep(
                            //   number: '2',
                            //   title: 'Click the Verification Link',
                            //   description:
                            //       'Click the link in the email to verify your email address. This must be done in your email app/browser.',
                            // ),
                            // const SizedBox(height: 12),

                            // _buildStep(
                            //   number: '3',
                            //   title: 'Return & Check Status',
                            //   description:
                            //       'Come back to this app and click "I\'ve Verified My Email" to confirm your verification.',
                            // ),
                            // const SizedBox(height: 12),

                            // _buildStep(
                            //   number: '2',
                            //   title: 'Click the Link',
                            //   description:
                            //       'Click the verification link in the email to confirm your address.',
                            // ),
                            // const SizedBox(height: 12),

                            // _buildStep(
                            //   number: '3',
                            //   title: 'Access Your Account',
                            //   description:
                            //       'Return to this app and click "I\'ve Verified" to continue.',
                            // ),
                            const SizedBox(height: 28),

                            // Helpful Tip
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue),
                              ),
                              child: const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.blue,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Tip: Check your spam/junk folder. Verification emails sometimes end up there. The link in the email must be clicked to verify.',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Error Message (if any)
                            if (authProvider.errorMessage != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red),
                                ),
                                child: Text(
                                  authProvider.errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            if (authProvider.errorMessage != null)
                              const SizedBox(height: 16),

                            // Verified Status
                            if (authProvider.isEmailVerified)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Email verified successfully!',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (authProvider.isEmailVerified)
                              const SizedBox(height: 16),

                            // Check Email Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: authProvider.isEmailVerified ||
                                        _isChecking ||
                                        authProvider.isCheckingVerification
                                    ? null
                                    : () =>
                                        _checkEmailVerified(authProvider),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF4A6FA5),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: (_isChecking ||
                                        authProvider.isCheckingVerification)
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : Text(
                                        authProvider.isEmailVerified
                                            ? 'Email Verified ✓'
                                            : 'I\'ve Verified My Email',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Resend Email Button
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: authProvider.isLoading
                                    ? null
                                    : () => _resendEmail(authProvider),
                                child: Text(
                                  authProvider.isLoading
                                      ? 'Sending...'
                                      : 'Didn\'t receive the email? Resend',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4A6FA5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Logout Button
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () =>
                                    authProvider.signOut(),
                                child: const Text(
                                  'Use Different Email',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF4A6FA5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A6FA5),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.7),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
