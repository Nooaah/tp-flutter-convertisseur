import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _nombreSaisi = 0.0;
  String _uniteDepart = '';
  String _uniteArrivee = '';
  String _uniteTemp = '';
  String _message = '';

  final Map<String, int> _mesuresMap = {
    'mètre(s)': 0,
    'kilomètre(s)': 1,
    'gramme(s)': 2,
    'kilogramme(s)': 3,
    'pied(s)': 4,
    'mile(s)': 5,
    'livre(s)': 6,
    'once(s)': 7
  };

  final dynamic _formules = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 0, 0, 0.0625, 1],
  };

  final TextStyle styleEntree = TextStyle(
    fontSize: 20,
    color: Colors.green[900],
  );
  final TextStyle styleLabel = TextStyle(
    fontSize: 17,
    color: Colors.grey[700],
  );

  @override
  void initState() {
    _nombreSaisi = 0.0;
    _uniteTemp = '';
    _uniteDepart = _mesuresMap.keys.first;
    _uniteArrivee = _mesuresMap.keys.elementAt(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
      )),
      title: 'Convertisseur de mesures',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Convertisseur de Mesures'),
          backgroundColor: Colors.green,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.swap_vert),
          tooltip: 'Échanger',
          onPressed: () {
            setState(() {
              _uniteTemp = _uniteArrivee;
              _uniteArrivee = _uniteDepart;
              _uniteDepart = _uniteTemp;
            });
            if (_nombreSaisi == 0) {
              return;
            } else {
              convertir(_nombreSaisi, _uniteDepart, _uniteArrivee);
            }
          },
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            Spacer(flex: 2),
            Text('Valeur à convertir', style: styleEntree),
            Spacer(),
            TextField(
                keyboardType: TextInputType.number,
                style: styleEntree,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: "Saisissez la mesure à convertir",
                    contentPadding: const EdgeInsets.all(10.0)),
                onChanged: (text) {
                  var vr = double.tryParse(text);
                  if (vr != null) {
                    setState(() {
                      _nombreSaisi = vr;
                    });
                  }
                }),
            Spacer(flex: 2),
            Text('Depuis', style: styleLabel),
            Spacer(),
            DropdownButton(
              value: _uniteDepart,
              items: _mesuresMap.keys.map((String unite) {
                return DropdownMenuItem<String>(
                  value: unite,
                  child: Text(unite),
                );
              }).toList(),
              onChanged: (String? unite) {
                setState(() {
                  _uniteDepart = unite ?? _mesuresMap.keys.first;
                });
              },
            ),
            Spacer(),
            Text('Vers', style: styleLabel),
            Spacer(),
            DropdownButton(
              value: _uniteArrivee,
              items: _mesuresMap.keys.map((String unite) {
                return DropdownMenuItem<String>(
                  value: unite,
                  child: Text(unite),
                );
              }).toList(),
              onChanged: (String? unite) {
                setState(() {
                  _uniteArrivee = unite ?? _mesuresMap.keys.first;
                });
              },
            ),
            Spacer(flex: 2),
            ElevatedButton(
              onPressed: () {
                if (_nombreSaisi == 0) {
                  return;
                } else {
                  convertir(_nombreSaisi, _uniteDepart, _uniteArrivee);
                }
              },
              child: Text('Convertir',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            Spacer(flex: 2),
            Text(_message, textAlign: TextAlign.center, style: styleLabel),
            Spacer(flex: 8),
          ]),
        ),
      ),
    );
  }

  void convertir(double valeur, String depuis, String vers) {
    int numDepuis = _mesuresMap[depuis] ?? 0;
    int numVers = _mesuresMap[vers] ?? 0;
    var multiplicateur = _formules[numDepuis.toString()][numVers];
    var resultat = valeur * multiplicateur;

    var message;
    if (resultat == 0) {
      message = 'Cette conversion ne peut être réalisée';
    } else {
      message =
          '${valeur.toString()} $depuis\nest égal à\n${resultat.toString()} $vers';
    }
    setState(() {
      _message = message;
    });
  }
}
