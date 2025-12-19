import 'package:flutter/material.dart';
import 'package:bio_calc/logic/molecular_calc.dart';
import 'package:bio_calc/widgets/custom_text_field.dart';
import 'package:bio_calc/widgets/result_card.dart';
import 'package:bio_calc/logic/database_helper.dart';

class DilutionPage extends StatefulWidget {
  const DilutionPage({super.key});

  @override
  State<DilutionPage> createState() => _DilutionPageState();
}

class _DilutionPageState extends State<DilutionPage> {
  final _c1Controller = TextEditingController();
  final _c2Controller = TextEditingController();
  final _v2Controller = TextEditingController();
  final _calc = MolecularCalc();
  String _result = '0.00';

  void _calculate() {
    final double? c1 = double.tryParse(_c1Controller.text);
    final double? c2 = double.tryParse(_c2Controller.text);
    final double? v2 = double.tryParse(_v2Controller.text);

    if (c1 == null || c2 == null || v2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid numbers in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (c2 > c1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Final concentration (C2) cannot be greater than initial (C1)'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final double v1 = _calc.calculateDilution(
      c1: c1,
      c2: c2,
      v2: v2,
    );

    final String formattedResult = 'V1: ${v1.toStringAsFixed(3)}';

    setState(() {
      _result = formattedResult;
    });

    // Save to database history
    DatabaseHelper.instance.insertCalculation(
      type: 'Dilution',
      inputMap: {
        'C1': c1,
        'C2': c2,
        'V2': v2,
      },
      output: formattedResult,
    );

    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    // Clean up controllers
    _c1Controller.dispose();
    _c2Controller.dispose();
    _v2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dilution (C1V1 = C2V2)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _c1Controller,
              label: 'Initial Concentration (C1)',
              unit: 'any',
              hint: 'e.g., 10.0',
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _c2Controller,
              label: 'Final Concentration (C2)',
              unit: 'any',
              hint: 'e.g., 1.5',
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _v2Controller,
              label: 'Final Volume (V2)',
              unit: 'e.g., mL',
              hint: 'e.g., 1000',
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: Theme.of(context).textTheme.titleLarge,
              ),
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 24.0),
            if (_result.isNotEmpty) ResultCard(result: _result),
          ],
        ),
      ),
    );
  }
}