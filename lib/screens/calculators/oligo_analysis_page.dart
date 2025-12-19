import 'package:flutter/material.dart';
import 'package:bio_calc/logic/molecular_calc.dart';
import 'package:flutter/services.dart';
import 'package:bio_calc/logic/database_helper.dart'; // Added DB Import

class OligoAnalysisPage extends StatefulWidget {
  const OligoAnalysisPage({super.key});

  @override
  State<OligoAnalysisPage> createState() => _OligoAnalysisPageState();
}

class _OligoAnalysisPageState extends State<OligoAnalysisPage> {
  final _seqController = TextEditingController();

  final _calc = MolecularCalc();

  String _tmResult = '0.0';
  String _gcResult = '0.0';
  String _length = '0';

  void _analyze() {
    final String sequence = _seqController.text.trim();

    if (sequence.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a DNA sequence'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final validChars = RegExp(r'^[ATGCatgc]+$');
    if (!validChars.hasMatch(sequence)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sequence contains invalid characters. Only A, T, G, C are allowed.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }


    final double tm = _calc.calculateTm(sequence);
    final double gc = _calc.calculateGCContent(sequence);
    final int len = sequence.length;

    setState(() {
      _tmResult = tm.toStringAsFixed(2);
      _gcResult = (gc * 100).toStringAsFixed(2);
      _length = len.toString();
    });

    // Save to database history
    DatabaseHelper.instance.insertCalculation(
      type: 'Oligo Analysis',
      inputMap: {
        'sequence': sequence.length > 20
            ? '${sequence.substring(0, 20)}...'
            : sequence,
        'len': len
      },
      output: 'Tm: ${_tmResult}°C, GC: ${_gcResult}%',
    );

    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _seqController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oligo/Primer Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _seqController,
              decoration: InputDecoration(
                labelText: 'DNA Sequence',
                hintText: 'Enter sequence (e.g., ATGC...)\n\n',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              ),
              maxLines: 8,
              minLines: 3,
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[ATGCatgc]')),
              ],
              style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _analyze,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: Theme.of(context).textTheme.titleLarge,
              ),
              child: const Text('Analyze'),
            ),
            const SizedBox(height: 24.0),
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _ResultRow(label: 'Length:', value: _length, unit: 'bp'),
                    const Divider(),
                    _ResultRow(label: 'GC Content:', value: _gcResult, unit: '%'),
                    const Divider(),
                    _ResultRow(label: 'Melting Temp (Tm):', value: _tmResult, unit: '°C'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                'Tm calculation assumes default parameters (50mM salt). Short oligo (2+4) formula is used for sequences < 14bp.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textTheme.titleMedium),
          Text(
            '$value $unit',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}