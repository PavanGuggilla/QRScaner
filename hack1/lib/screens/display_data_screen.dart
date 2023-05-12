import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DisplayData extends StatelessWidget {
  static const routeName = '/displayDataScreen';

  @override
  Widget build(BuildContext context) {
    var id;
    List<Map> temp = [
      {
        'disposableId': '123',
        'counter': 1,
        'time':'',
      },
      {
        'disposableId': '124',
        'ipcsUsed': ['ad', 'ae'],
      },
      {
        'disposableId': '125',
        'ipcsUsed': ['ab', 'ac'],
      },
      {
        'disposableId': '126',
        'ipcsUsed': ['ad', 'ae'],
      },
    ];
    Map<String, int> data = {
      'IPC1': 1,
      'IPC2': 1,
      'IPC3': 1,
      'IPC4': 1,
      'IPC5': 1
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('MWISE scanner'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(color: Colors.blue),
                child: const Text('Disposable id'),
              ),
              const SizedBox(
                width: 40,
              ),
              Container(
                decoration: const BoxDecoration(color: Colors.blue),
                child: const Text('Disposable id'),
              ),
            ],
          ),
          SingleChildScrollView(
            child: GridView(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 3 / 2,
              ),
              children: [
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
