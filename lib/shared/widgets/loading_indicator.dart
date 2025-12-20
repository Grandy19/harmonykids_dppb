import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final Color color;

  const CustomLoading({
    super.key, 
    this.color = const Color(0xFF0D253F), 
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 24, 
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: color,
        ),
      ),
    );
  }
}