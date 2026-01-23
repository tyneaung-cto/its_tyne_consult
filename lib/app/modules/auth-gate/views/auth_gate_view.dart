import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_gate_controller.dart';

class AuthGateView extends GetView<AuthGateController> {
  const AuthGateView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/splash.png',
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 24),

              // App title
              Text(
                'ItsTyne Consult',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Checking your session...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 32),

              // Loader
              SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
