import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 0, 0),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> units = ['Weight', 'Currency', 'Temperature', 'Length', 'Area'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Converter'),
      ),
      body: ListView.builder(
        itemCount: units.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(units[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConversionScreen(unit: units[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ConversionScreen extends StatefulWidget {
  final String unit;

  const ConversionScreen({super.key, required this.unit});

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  TextEditingController inputValueController = TextEditingController();
  String result = '';

  List<String> values = [];
  String selectedFromValue = '';
  String selectedToValue = '';

  @override
  void initState() {
    super.initState();
    initializeValues();
  }

  void initializeValues() {
    switch (widget.unit) {
      case 'Weight':
        values = ['Kilogram', 'Gram', 'Pound'];
        selectedFromValue = 'Kilogram';
        selectedToValue = 'Gram';
        break;
      case 'Currency':
        values = ['USD', 'EUR', 'RUB'];
        selectedFromValue = 'RUB';
        selectedToValue = 'USD';
        break;
      case 'Temperature':
        values = ['Celsius', 'Fahrenheit', 'Kelvin'];
        selectedFromValue = 'Celsius';
        selectedToValue = 'Fahrenheit';
        break;
      case 'Length':
        values = ['Meter', 'Kilometer', 'Mile'];
        selectedFromValue = 'Meter';
        selectedToValue = 'Kilometer';
        break;
      case 'Area':
        values = ['Square Meter', 'Square Kilometer', 'Square Mile'];
        selectedFromValue = 'Square Meter';
        selectedToValue = 'Square Kilometer';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.unit),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedFromValue,
                    onChanged: (value) {
                      setState(() {
                        if (value == selectedToValue){
                          selectedToValue = selectedFromValue;
                        }
                        selectedFromValue = value!;
                      });
                    },
                    items: values
                        .map<DropdownMenuItem<String>>(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: () {
                    setState(() {
                      String temp = selectedFromValue;
                      selectedFromValue = selectedToValue;
                      selectedToValue = temp;
                    });
                  },
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedToValue,
                    onChanged: (value) {
                      setState(() {
                        if (value == selectedFromValue){
                          selectedFromValue = selectedToValue;
                        }
                        selectedToValue = value!;
                      });
                    },
                    items: values
                        .map<DropdownMenuItem<String>>(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: inputValueController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[^0-9.-]')),
              ],
              decoration: const InputDecoration(labelText: 'Enter value'),
              onEditingComplete: () {
                convert();
              },
            ),
            ElevatedButton(
              onPressed: () {
                convert();
              },
              child: const Text('Convert'),
            ),
            const Text('Result:'),
            Text(result),
          ],
        ),
      ),
    );
  }

  void convert() {
    if (inputValueController.text.isEmpty) {
      setState(() {
        result = 'Please enter a value.';
      });
      return;
    }

    double? inputValue = double.tryParse(inputValueController.text);
    if (inputValue == null) {
      setState(() {
        result = 'Invalid input. Please enter a valid number.';
      });
      return;
    }

    double conversionResult = 0;

    switch (widget.unit) {
      case 'Weight':
        if (selectedFromValue == 'Kilogram' && selectedToValue == 'Gram') {
          conversionResult = inputValue * 1000;
        } else if (selectedFromValue == 'Gram' &&
            selectedToValue == 'Kilogram') {
          conversionResult = inputValue / 1000;
        } else if (selectedFromValue == 'Pound' &&
            selectedToValue == 'Kilogram') {
          conversionResult = inputValue * 0.453592;
        } else if (selectedFromValue == 'Kilogram' &&
            selectedToValue == 'Pound') {
          conversionResult = inputValue / 0.453592;
        }
        break;
      case 'Currency':
        if (selectedFromValue == 'USD' && selectedToValue == 'EUR') {
          double exchangeRate = 0.85;
          conversionResult = inputValue * exchangeRate;
        } else if (selectedFromValue == 'EUR' && selectedToValue == 'USD') {
          double exchangeRate = 1.18;
          conversionResult = inputValue * exchangeRate;
        } else if (selectedFromValue == 'USD' && selectedToValue == 'RUB') {
          double exchangeRate = 73.50;
          conversionResult = inputValue * exchangeRate;
        } else if (selectedFromValue == 'RUB' && selectedToValue == 'USD') {
          double exchangeRate = 0.014;
          conversionResult = inputValue * exchangeRate;
        }
        break;
      case 'Temperature':
        if (selectedFromValue == 'Celsius' && selectedToValue == 'Fahrenheit') {
          conversionResult = (inputValue * 9 / 5) + 32;
        } else if (selectedFromValue == 'Fahrenheit' && selectedToValue == 'Celsius') {
          conversionResult = (inputValue - 32) * 5 / 9;
        } else if (selectedFromValue == 'Celsius' && selectedToValue == 'Kelvin') {
          conversionResult = inputValue + 273.15;
        } else if (selectedFromValue == 'Kelvin' && selectedToValue == 'Celsius') {
          conversionResult = inputValue - 273.15;
        }
        break;
      case 'Length':
        if (selectedFromValue == 'Meter' && selectedToValue == 'Kilometer') {
          conversionResult = inputValue / 1000;
        } else if (selectedFromValue == 'Kilometer' && selectedToValue == 'Meter') {
          conversionResult = inputValue * 1000;
        } else if (selectedFromValue == 'Mile' && selectedToValue == 'Kilometer') {
          conversionResult = inputValue * 1.60934;
        } else if (selectedFromValue == 'Kilometer' && selectedToValue == 'Mile') {
          conversionResult = inputValue / 1.60934;
        }
        break;
      case 'Area':
        if (selectedFromValue == 'Square Meter' && selectedToValue == 'Square Kilometer') {
          conversionResult = inputValue / 1000000;
        } else if (selectedFromValue == 'Square Kilometer' && selectedToValue == 'Square Meter') {
          conversionResult = inputValue * 1000000;
        } else if (selectedFromValue == 'Square Kilometer' && selectedToValue == 'Square Mile') {
          conversionResult = inputValue / 2.58999;
        } else if (selectedFromValue == 'Square Mile' && selectedToValue == 'Square Kilometer') {
          conversionResult = inputValue * 2.58999;
        }
        break;
    }

    setState(() {
      String resultString = '$inputValue $selectedFromValue = $conversionResult $selectedToValue';
      resultString = resultString.replaceAll(RegExp(r'\.0\b'), '');
      result = resultString;
    });
  }
}