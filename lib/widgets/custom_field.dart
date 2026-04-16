import 'package:flutter/material.dart';
import '../main.dart';

class CustomField extends StatefulWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const CustomField({
    super.key,
    required this.icon,
    required this.hint,
    this.obscure = false,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            widget.icon,
            color: Colors.grey.shade500,
            size: 22,
          ),
          suffixIcon: widget.obscure
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey.shade500,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : widget.suffixIcon,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          filled: true,
          fillColor: Colors.grey.shade100,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: kPrimary,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: kPrimary,
              width: 1.8,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}