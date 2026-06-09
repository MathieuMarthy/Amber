import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final bool isDynamic;

  const HomePage({super.key, required this.isDynamic});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Column(
        children: [
          Spacer(),
          Center(
            child: Text(
              "Salut !",
              style: TextStyle(
                fontSize: 26,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
