
import 'package:flutter/material.dart';
import '../widgets/app_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Welcome to TrikeFind'),
    ),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            text: 'Login',
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Report a Concern',
            onPressed: () {
              Navigator.pushNamed(context, '/report');
            },
          ),
        ],
      ),
    ),
  );
}
