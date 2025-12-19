class ProteinConstants {

  /* isme hai 20 amino acids ka hisaab kitaab

  ExPASy ProtParam liya hai data shyd glt ho so cross check
*/
static const Map<String, double> molecularWeights= {
    'A': 71.0788,
    'R': 156.1875,
    'N': 114.1038,
    'D': 115.0886,
    'C': 103.1388,
    'E': 129.1155,
    'Q': 128.1307,
    'G': 57.0519,
    'H': 137.1411,
    'I': 113.1594,
    'L': 113.1594,
    'K': 128.1741,
    'M': 131.1926,
    'F': 147.1766,
    'P': 97.1167,
    'S': 87.0782,
    'T': 101.1051,
    'W': 186.2132,
    'Y': 163.1760,
    'V': 99.1326,
  };
// Based on "EMBOSS" pKa values, which are commonly used.
  static const Map<String, double> pKaValues = {
    'N_term': 9.69,
    'C_term': 2.34,
    'K': 10.53, // Lysine
    'R': 12.48, // Arginine
    'H': 6.00, // Histidine
    'D': 3.86, // Aspartic Acid
    'E': 4.25, // Glutamic Acid
    'C': 8.33, // Cysteine
    'Y': 10.07, // Tyrosine
  };

  static const Map<String, double> hydropathyIndex = {
    'A': 1.800,
    'R': -4.500,
    'N': -3.500,
    'D': -3.500,
    'C': 2.500,
    'E': -3.500,
    'Q': -3.500,
    'G': -0.400,
    'H': -3.200,
    'I': 4.500,
    'L': 3.800,
    'K': -3.900,
    'M': 1.900,
    'F': 2.800,
    'P': -1.600,
    'S': -0.800,
    'T': -0.700,
    'W': -0.900,
    'Y': -1.300,
    'V': 4.200,
  };
}
