import 'package:bio_calc/screens/calculators/dilution_page.dart';
import 'package:bio_calc/screens/calculators/ligation_page.dart';
import 'package:bio_calc/screens/calculators/molarity_page.dart';
import 'package:bio_calc/screens/calculators/oligo_analysis_page.dart';
import 'package:bio_calc/screens/calculators/protein_properties_page.dart';
import 'package:bio_calc/screens/calculators/sequence_manip_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Bio-Calc Suite',
      applicationVersion: 'v1.0.0',
      applicationIcon: Icon(
        Icons.biotech,
        size: 50,
        color: Theme.of(context).primaryColor,
      ),
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            'A comprehensive offline toolkit for life science researchers and bioinformatics students.',
          ),
        ),
        const SizedBox(height: 15),
        const Text('Developer: Sajal Sharma', style: TextStyle(fontWeight: FontWeight.bold)),
        const Text('Project: Biomolecular Calculation Dashboard'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bio-Calc Suite'),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                padding: const EdgeInsets.only(top: 12.0),
                children: [
                  _CalculatorCard(
                    title: 'Molarity',
                    icon: Icons.science,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MolarityPage())),
                  ),
                  _CalculatorCard(
                    title: 'Dilution',
                    icon: Icons.opacity,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DilutionPage())),
                  ),
                  _CalculatorCard(
                    title: 'Primer Analysis',
                    icon: Icons.auto_awesome,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OligoAnalysisPage())),
                  ),
                  _CalculatorCard(
                    title: 'Sequence Tools',
                    icon: Icons.flip,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SequenceManipPage())),
                  ),
                  _CalculatorCard(
                    title: 'Protein Properties',
                    icon: Icons.hub,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProteinPropertiesPage())),
                  ),
                  _CalculatorCard(
                    title: 'Ligation',
                    icon: Icons.link,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LigationPage())),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'By : Sajal Sharma',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalculatorCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _CalculatorCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}