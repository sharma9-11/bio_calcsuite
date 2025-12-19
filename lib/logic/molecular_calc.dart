import 'dart:math';
class MolecularCalc {
  double calculateMassForMolarity({
    required double formulaWeight,
    required double desiredMolarity,
    required double finalVolumeML,
  }) {
    final double volumeL = finalVolumeML / 1000.0;
    return desiredMolarity * formulaWeight * volumeL;
  }

  double calculateGCContent(String sequence) {
    if (sequence.isEmpty) return 0.0;

    final cleanSeq = sequence.toUpperCase();
    int gcCount = 0;

    for (int i = 0; i < cleanSeq.length; i++) {
      if (cleanSeq[i] == 'G' || cleanSeq[i] == 'C') {
        gcCount++;
      }
    }
    return gcCount / cleanSeq.length;
  }

  double calculateTm(String sequence,
      {double primerConcNM = 50.0, double saltConcMM = 50.0}) {
    String seq = sequence.toUpperCase().trim();
    if (seq.isEmpty) {
      return 0.0;
    }

    int aCount = 'A'.allMatches(seq).length;
    int tCount = 'T'.allMatches(seq).length;
    int gCount = 'G'.allMatches(seq).length;
    int cCount = 'C'.allMatches(seq).length;

    if (seq.length < 14) {
      return (2.0 * (aCount + tCount)) + (4.0 * (gCount + cCount));
    } else {
      // Salt-adjusted formula hai ulta fulta nhi krio
      // Tm = 81.5 + 0.41(%GC) - 675/N + 16.6 * log10[salt]

      double percentGC = (gCount + cCount) / seq.length;
      double saltConcL = saltConcMM / 1000.0;
      double tm = 81.5 + (0.41 * (percentGC * 100.0)) - (675.0 / seq.length) + (16.6 * (log(saltConcL) / log(10)));
      return tm;
    }
  }

  /// Calculates the initial volume (V1) required for a dilution.
  /// Formula: C1 * V1 = C2 * V2  =>  V1 = (C2 * V2) / C1
  double calculateDilution({
    required double c1, // Initial Concentration
    required double c2, // Final Concentration
    required double v2, // Final Volume
  }) {
    if (c1 == 0) {
      return 0.0;
    }
    return (c2 * v2) / c1;
  }
  double calculateLigation({
    required double vectorMassNg,
    required double vectorLengthBp,
    required double insertLengthBp,
    required double molarRatio,
  }) {
    if (vectorLengthBp <= 0 || insertLengthBp <= 0 || vectorMassNg < 0) {
      return 0.0;
    }
    double massInsert =
        molarRatio * (vectorMassNg * insertLengthBp) / vectorLengthBp;
    return massInsert;
  }

}

