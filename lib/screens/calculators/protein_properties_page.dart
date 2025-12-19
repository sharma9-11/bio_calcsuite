import 'package:bio_calc/logic/protein_calc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bio_calc/logic/database_helper.dart'; // Added DB Import

class ProteinPropertiesPage extends StatefulWidget {
  const ProteinPropertiesPage({super.key});

  @override
  State<ProteinPropertiesPage> createState() => _ProteinPropertiesPageState();
}

class _ProteinPropertiesPageState extends State<ProteinPropertiesPage> {
  final _controller = TextEditingController();
  final _calc = ProteinCalc();

  // We will store our results in a Map
  Map<String, double> _results = {};
  String _errorMessage = '';

  void _calculate() {
    final String sequence = _controller.text.trim().toUpperCase();

    if (sequence.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a protein sequence.';
        _results = {};
      });
      return;
    }
// This regex matches any character that is NOT A, C, D, E, F, G, H, I, K, L, M, n, P, Q, R, S, T, V, W, Y
    if (RegExp(r'[^ACDEFGHIKLMNPQRSTVWY]').hasMatch(sequence)) {
      setState(() {
        _errorMessage =
        'Invalid character detected. Please enter only standard amino acid letters.';
        _results = {};
      });
      return;
    }

    try {
      final double mw = _calc.calculateMolecularWeight(sequence);
      final double pi = _calc.calculateTheoreticalPI(sequence);
      final double gravy = _calc.calculateGravy(sequence);

      final double mwKda = mw / 1000.0;

      setState(() {
        _errorMessage = '';
        _results = {
          'Molecular Weight (kDa)': mwKda,
          'Theoretical pI': pi,
          'GRAVY Score': gravy,
        };
      });

      // Save calculation to Database for History tab
      DatabaseHelper.instance.insertCalculation(
        type: 'Protein Properties',
        inputMap: {
          'len': sequence.length,
          'sequence': sequence.length > 15
              ? '${sequence.substring(0, 15)}...'
              : sequence,
        },
        output: 'MW: ${mwKda.toStringAsFixed(2)} kDa, pI: ${pi.toStringAsFixed(2)}, GRAVY: ${gravy.toStringAsFixed(2)}',
      );

      FocusScope.of(context).unfocus();
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred during calculation.';
        _results = {};
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Protein Properties'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              maxLines: 8,
              minLines: 3,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
              ],
              decoration: InputDecoration(
                labelText: 'Protein Sequence (e.g., MGA...)',
                hintText: 'Enter your amino acid sequence here',
                border: const OutlineInputBorder(),
                errorText: _errorMessage.isEmpty ? null : _errorMessage,
              ),
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 16.0),

            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Analyze'),
            ),
            const SizedBox(height: 24.0),

            Text(
              'Results',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),

            if (_results.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Text(
                    'Results will appear here.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final key = _results.keys.elementAt(index);
                  final value = _results[key]!;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(key),
                    trailing: Text(
                      value.toStringAsFixed(2),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}