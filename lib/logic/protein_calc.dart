import 'dart:math';
import 'package:bio_calc/logic/protein_constants.dart';
class ProteinCalc {
  double calculateMolecularWeight(String sequence) {
    String seq = sequence.toUpperCase().trim();
    if (seq.isEmpty) {
      return 0.0;
    }

    double totalWeight = 0.0;
    for (int i = 0; i < seq.length; i++) {
      String aminoAcid = seq[i];
      totalWeight += ProteinConstants.molecularWeights[aminoAcid] ?? 0.0;
    }
    return totalWeight + 18.01528;
  }

  double calculateGravy(String sequence) {
    String seq = sequence.toUpperCase().trim();
    if (seq.isEmpty) {
      return 0.0;
    }

    double totalHydropathy = 0.0;
    int validResidues = 0;

    for (int i = 0; i < seq.length; i++) {
      String aminoAcid = seq[i];
      if (ProteinConstants.hydropathyIndex.containsKey(aminoAcid)) {
        totalHydropathy += ProteinConstants.hydropathyIndex[aminoAcid]!;
        validResidues++;
      }
    }

    if (validResidues == 0) {
      return 0.0;
    }

    return totalHydropathy / validResidues.toDouble();
  }

  double _calculateNetCharge(String sequence, double pH) {
    String seq = sequence.toUpperCase().trim();
    double charge = 0.0;

    charge += 1 / (1 + pow(10, pH - ProteinConstants.pKaValues['N_term']!));

    charge -= 1 / (1 + pow(10, ProteinConstants.pKaValues['C_term']! - pH));

    for (int i = 0; i < seq.length; i++) {
      String aa = seq[i];
      switch (aa) {
        case 'K': // Lysine
          charge += 1 / (1 + pow(10, pH - ProteinConstants.pKaValues['K']!));
          break;
        case 'R': // Arginine
          charge += 1 / (1 + pow(10, pH - ProteinConstants.pKaValues['R']!));
          break;
        case 'H': // Histidine
          charge += 1 / (1 + pow(10, pH - ProteinConstants.pKaValues['H']!));
          break;
        case 'D': // Aspartic Acid
          charge -= 1 / (1 + pow(10, ProteinConstants.pKaValues['D']! - pH));
          break;
        case 'E': // Glutamic Acid
          charge -= 1 / (1 + pow(10, ProteinConstants.pKaValues['E']! - pH));
          break;
        case 'C': // Cysteine
          charge -= 1 / (1 + pow(10, ProteinConstants.pKaValues['C']! - pH));
          break;
        case 'Y': // Tyrosine
          charge -= 1 / (1 + pow(10, ProteinConstants.pKaValues['Y']! - pH));
          break;
      }
    }
    return charge;
  }
double calculateTheoreticalPI(String sequence) {
    String seq = sequence.toUpperCase().trim();
    if (seq.isEmpty) {
      return 0.0;
    }

    double minPH = 0.0;
    double maxPH = 14.0;
    double midPH = 7.0;
    double charge = _calculateNetCharge(seq, midPH);

    for (int i = 0; i < 100; i++) {
      if (charge > 0.0) {
        minPH = midPH;
      } else {
        maxPH = midPH;
      }
      midPH = (minPH + maxPH) / 2.0;
      charge = _calculateNetCharge(seq, midPH);

      if (charge.abs() < 0.001) {
        break;
      }
    }
    return midPH;
  }
}
