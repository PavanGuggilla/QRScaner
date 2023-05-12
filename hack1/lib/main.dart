import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hack1/screens/display_data_screen.dart';
import 'package:hack1/widgets/alertWindow.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanNeedleQRCode = 'Unknown';
  String _outputString = 'Unknown';
  
  String _scanDeviceQRCode = 'Unknown';

  var counter = {
    'PLNRHKCOHLFW': 12,
    'BECWMXGHGVCH': 65,
    'BMGVTKDVBCLA': 77,
    'FTUMERHYRYPH': 99,
    'QQBZESNEGFNM': 0,
    'HYQEPSGEZVSR': 9,
    'JJNACOQQZKKM': 4,
    'TPUTCHMTVPGV': 78,
    'UQSQZQHCOMGL': 100,
    'VKWXZSBBGQWT': 98
  };
  var pairingKey = {};
  var start_date = DateTime.now().subtract(Duration(minutes: 62));
  var end_date;

  @override
  void initState() {
    super.initState();
  }

  void getData(String s) {
    int? count = counter[s];

    setState(() {
      count = counter[s];
    });
  }

  void addNeedle(BuildContext context, String s) {
    end_date = DateTime.now();
    final duration = end_date.difference(start_date);
    final minutes = duration.inMinutes;

    if (counter.containsKey(s)) {
      if ((counter[s]) == 100) {
        print('Exceeded 100 times');

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('An error occured'),
            content: const Text('Exceeded 100 times.Dispose the needle'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay'))
            ],
          ),
        );
      } else if (minutes <= 60) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('An error occured'),
            content: Text(
                "Please wait for an hour as the dispoasble is used ${minutes == 0 ? 'few seconds' : ' $minutes minutes'}  ago"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay'))
            ],
          ),
        );
      } else {
        start_date = DateTime.now();
        counter[s] = (counter[s]! + 1);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Successfully updated'),
        ));
      }
    } else {
      counter.putIfAbsent(s, () => 1);
    }

    setState(() {
      counter[s];
    });
  }

  void reduceNeedle(BuildContext context, String s) {
    if (!counter.containsKey(s)) {
      AlertWindow();
      /*
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('An error occured'),
            content: const Text('Needle does not exist'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay'))
            ],
          ),
        );
        */
    } else {
      counter[s] = (counter[s]! - 1);
    }
    setState(() {
      counter[s];
    });
  }

  Future<void> scanQRForNeedle() async {
    String barcodeScanRes;

    String inputString;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    String subString ;
    subString = barcodeScanRes.substring(4, 12);
    String outString = '';
    for (int i = 0; i < subString.length; i++) {
      int asciiValue = subString.codeUnitAt(i);
      int shiftedValue = (asciiValue - 89) % 26 + 65;
      outString += String.fromCharCode(shiftedValue);
    }
    print(outString);

     setState(() {
       _scanNeedleQRCode = barcodeScanRes;
      _outputString = outString;
      counter[barcodeScanRes];
    });

  }

  Future<void> scanQRForDevice() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    setState(() {
      _scanDeviceQRCode = barcodeScanRes;
    });

    addNeedle(context, barcodeScanRes);
    setState(() {
      counter[barcodeScanRes];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          DisplayData.routeName: (context) => DisplayData(),
        },
        home: Scaffold(
            appBar: AppBar(title: const Text('Medtronic Disposable Scanner')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                alignment: Alignment.topCenter,
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(children: [
                          SizedBox(
                            width: 100,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 20, color: Colors.transparent),
                                color: Colors.transparent),
                            child: Text(
                                'Please follow below steps: \n1. Scan the disposable 2D Matrix code from this \n     application\n2. Then a 12 digit code is generated\n3. Enter this captcha code in the IPC system\n4. IPC system will check for the valid \n     disposable ID and if it is valid then it proceeds \n     for Surgery',
                                style: const TextStyle(fontSize: 15)),
                          ),

                          // Text('Please follow below steps:'),
                          // Text('1. Scan the disposable 2D Matrix code from this application'),
                          // Text('2. Then a 12 digit code is generated'),
                          // Text('3. Enter this captcha code in the IPC system'),
                          // Text('4. IPC system will check for the valid disposable ID and if it is valid then IPC proceeds for Surgery'),

                          ElevatedButton(
                              onPressed: () => scanQRForNeedle(),
                              child: const Text('Scan Disposable QR')),
                        ]),
                        Column(
                          children: [
                            /*
                            ElevatedButton(
                                onPressed: () => getData(_scanNeedleQRCode),
                                child: const Text('Get count')),
                            Text('${counter[_scanNeedleQRCode]}',
                                style: const TextStyle(fontSize: 15)),
                                */
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () => getData(_scanNeedleQRCode),
                            child: const Text('Disposable count')),
                        Text('${counter[_scanNeedleQRCode]}',
                            style: const TextStyle(fontSize: 15)),
                        SizedBox(width: 50,),
                        ElevatedButton(
                            onPressed: () => addNeedle(context, _scanNeedleQRCode),
                            child: const Text('Add')),
                      ],
                    ),
                    Text(
                      'CODE : $_outputString',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 100,
                    ),
                    const SizedBox(
                      width: 100,
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    const SizedBox(
                      width: 100,
                    )
                  ],
                ),
              );
            })));
  }
}
