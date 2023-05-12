import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AlertWindow extends StatelessWidget {
  const AlertWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      shape: const CircleBorder(),
      title: const  Text("Dsipose"),
      content: const Text("Exceeded 100 times usage.Dispose the needle"),
      actions: [
        TextButton(onPressed:() => Navigator.of(context).pop(), child: const Text("OK"))
 
      ],
    );
  }
}