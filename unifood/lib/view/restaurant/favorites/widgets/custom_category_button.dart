import 'package:flutter/material.dart';

class CustomCategoryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isSelected;

  const CustomCategoryButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final Color buttonColor = isSelected ? const Color(0xFFE2D2B4) : Colors.white;

    return SizedBox(
      width: screenWidth * 0.27,
      height: screenHeight * 0.04,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: screenHeight * 0.012,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
