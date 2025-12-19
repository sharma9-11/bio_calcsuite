import 'package:flutter/material.dart';
import 'package:bio_calc/logic/molecular_calc.dart';
import 'package:bio_calc/widgets/custom_text_field.dart';
import 'package:bio_calc/widgets/result_card.dart';
import 'package:bio_calc/logic/database_helper.dart';

class MolarityPage extends StatefulWidget {
  const MolarityPage({super.key});

  @override
  State<MolarityPage> createState() => _MolarityPageState();
}

class _MolarityPageState extends State<MolarityPage> {
  final _fwController = TextEditingController();
  final _concController = TextEditingController();
  final _volController = TextEditingController();

  final _calc = MolecularCalc();

  String _result = '0.00';

  Future<void> _calculate() async {
    final double? fw = double.tryParse(_fwController.text);
    final double? conc = double.tryParse(_concController.text);
    final double? vol = double.tryParse(_volController.text);

    if (fw == null || conc == null || vol == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid numbers in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (fw <= 0) {
      setState(() => _result = 'Error: Formula Weight must be > 0.');
      return;
    }

    // Call the logic function from MolecularCalc
    // Note: We convert mL to Liters here (vol / 1000) to match calculateMolarity
    final double mass = _calc.calculateMassForMolarity(

      formulaWeight: fw,

      desiredMolarity: conc,

      finalVolumeML: vol,

    );

    final String formattedResult = 'Mass Required: ${mass.toStringAsFixed(3)} g';

    setState(() {
      _result = formattedResult;
    });

    // Save calculation to Database for History tab
    await DatabaseHelper.instance.insertCalculation(
      type: 'Molarity',
      inputMap: {
        'FW': fw,
        'Conc': conc,
        'Vol': vol,
      },
      output: formattedResult,
    );

    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _fwController.dispose();
    _concController.dispose();
    _volController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Molarity Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _fwController,
              label: 'Formula Weight',
              unit: 'g/mol',
              hint: 'e.g., 58.44',
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _concController,
              label: 'Desired Concentration',
              unit: 'M',
              hint: 'e.g., 1.5',
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _volController,
              label: 'Final Volume',
              unit: 'mL',
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