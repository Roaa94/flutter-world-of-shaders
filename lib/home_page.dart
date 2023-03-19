import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Examples'),
            TextButton(
              child: const Text('Video Grid'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
