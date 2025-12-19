import 'package:bio_calc/logic/genetic_code.dart'; // <-- Imports the file above
import 'dart:core';

class SequenceTools {
  String transcribe(String dna) {
    return dna.replaceAll('T', 'U');
  }

  String _complement(String dna) {
    return dna.runes.map((rune) {
      String char = String.fromCharCode(rune);
      switch (char) {
        case 'A':
          return 'T';
        case 'T':
          return 'A';
        case 'G':
          return 'C';
        case 'C':
          return 'G';
        default:
          return char; // Return unknown characters as-is
      }
    }).join('');
  }

  /// Returns the reverse complement of a DNA sequence. (e.g., ATGC -> GCAT)
  String reverseComplement(String dna) {
    String reversed = dna.split('').reversed.join('');
    return _complement(reversed);
  }

  /// Translates a single RNA strand into a protein sequence.
  String _translateRna(String rna) {
    String protein = '';

    // The loop now correctly increments by 3 (i += 3)
    for (int i = 0; i < (rna.length - 2); i += 3) {
      String codon = rna.substring(i, i + 3);
      // This will now work, as it matches the variable in the other file
      String aminoAcid = geneticCode[codon] ?? '?';
      if (aminoAcid == '*') {
        break; // Stop on stop codon
      }
      protein += aminoAcid;
    }
    return protein;
  }

  /// Returns all 6 reading frames for a DNA sequence.
  Map<String, String> translateSixFrames(String dna) {
    String upperDna = dna.toUpperCase();

    // 1. Get the 5' - 3' RNA strand (from the DNA you entered)
    String rna5to3 = transcribe(upperDna);

    // 2. Get the 3' - 5' RNA strand
    String revCompDna = reverseComplement(upperDna);
    String rna3to5 = transcribe(revCompDna);

    // 3. Translate all 6 frames
    return {
      // 5' - 3' Frames
      '5f1': _translateRna(rna5to3.substring(0)),
      '5f2': _translateRna(rna5to3.substring(1)),
      '5f3': _translateRna(rna5to3.substring(2)),
      // 3' - 5' Frames
      '3f1': _translateRna(rna3to5.substring(0)),
      '3f2': _translateRna(rna3to5.substring(1)),
      '3f3': _translateRna(rna3to5.substring(2)),
    };
  }
}