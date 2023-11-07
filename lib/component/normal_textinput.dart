import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CstInput extends StatefulWidget {
  final String text;
  final double fontSize;
  final String type;
  final String hinText;
  final TextEditingController controller; // Tambahkan TextEditingController

  CstInput({
    Key? key,
    required this.text,
    this.fontSize = 16,
    this.type = 'Password',
    required this.hinText,
    required this.controller, // Inisialisasi TextEditingController
  }) : super(key: key);

  @override
  _CstInputState createState() => _CstInputState();
}

class _CstInputState extends State<CstInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.text, style: TextStyle(fontSize: widget.fontSize)),
          SizedBox(height: 6),
          TextField(
            controller: widget.controller, // Gunakan TextEditingController di sini
            keyboardType: widget.type == 'Password'
                ? TextInputType.visiblePassword
                : widget.type == 'Email'
                ? TextInputType.emailAddress
                : TextInputType.name,
            obscureText: widget.type == 'Password',
            style: TextStyle(fontSize: widget.fontSize),
            decoration: InputDecoration(
              hintText: widget.hinText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
