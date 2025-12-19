import 'package:bio_calc/logic/molecular_calc.dart';
import 'package:bio_calc/widgets/custom_text_field.dart';
import 'package:bio_calc/widgets/result_card.dart';
import 'package:bio_calc/logic/database_helper.dart';
import 'package:flutter/material.dart';

class LigationPage extends StatefulWidget {
  const LigationPage({super.key});

  @override
  State<LigationPage> createState() => _LigationPageState();
}

class _LigationPageState extends State<LigationPage> {
  final _vectorMassCtrl = TextEditingController();
  final _vectorLengthCtrl = TextEditingController();
  final _insertLengthCtrl = TextEditingController();
  final _molarRatioCtrl = TextEditingController(text: '3'); // Default 3:1 ratio

  final MolecularCalc _calc = MolecularCalc();

  String _result = '';

  void _calculate() {
    final double? vectorMass = double.tryParse(_vectorMassCtrl.text);
    final double? vectorLength = double.tryParse(_vectorLengthCtrl.text);
    final double? insertLength = double.tryParse(_insertLengthCtrl.text);
    final double? molarRatio = double.tryParse(_molarRatioCtrl.text);

    if (vectorMass == null ||
        vectorLength == null ||
        insertLength == null ||
        molarRatio == null) {
      setState(() {
        _result = 'Error: All fields must be valid numbers.';
      });
      return;
    }

    final double insertMass = _calc.calculateLigation(
      vectorMassNg: vectorMass,
      vectorLengthBp: vectorLength,
      insertLengthBp: insertLength,
      molarRatio: molarRatio,
    );

    final String formattedResult = 'Insert Mass Required: ${insertMass.toStringAsFixed(2)} ng';

    setState(() {
      _result = formattedResult;
    });

    // Save calculation to Database for History tab
    DatabaseHelper.instance.insertCalculation(
      type: 'Ligation',
      inputMap: {
        'vMass': vectorMass,
        'vLen': vectorLength,
        'iLen': insertLength,
        'ratio': molarRatio,
      },
      output: formattedResult,
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    _vectorMassCtrl.dispose();
    _vectorLengthCtrl.dispose();
    _insertLengthCtrl.dispose();
    _molarRatioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ligation Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _vectorMassCtrl,
              label: 'Vector Mass (ng)',
              hint: 'e.g., 50',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _vectorLengthCtrl,
              label: 'Vector Length (bp)',
              hint: 'e.g., 5000',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _insertLengthCtrl,
              label: 'Insert Length (bp)',
              hint: 'e.g., 1000',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _molarRatioCtrl,
              label: 'Insert:Vector Molar Ratio (e.g., 3 for 3:1)',
              hint: 'e.g., 3',
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 24),

            if (_result.isNotEmpty) ResultCard(result: _result),
          ],
        ),
      ),
    );
  }
}