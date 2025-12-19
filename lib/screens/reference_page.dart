import 'package:flutter/material.dart';

class ReferencePage extends StatelessWidget {
  const ReferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scientific Reference'),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Genetic Code', icon: Icon(Icons.grid_on)),
              Tab(text: 'Amino Acids', icon: Icon(Icons.biotech)),
              Tab(text: 'Lab Buffers', icon: Icon(Icons.blender)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CodonTable(), // Now has search logic
            AminoAcidReference(),
            BufferRecipes(),
          ],
        ),
      ),
    );
  }
}

/// --- Tab 1: Genetic Code Table with Search ---
class CodonTable extends StatefulWidget {
  const CodonTable({super.key});

  @override
  State<CodonTable> createState() => _CodonTableState();
}

class _CodonTableState extends State<CodonTable> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _allCodons = [
    {'c': 'AUG', 'a': 'Met (M) - START'},
    {'c': 'UUU', 'a': 'Phe (F)'}, {'c': 'UUC', 'a': 'Phe (F)'},
    {'c': 'UUA', 'a': 'Leu (L)'}, {'c': 'UUG', 'a': 'Leu (L)'},
    {'c': 'UCU', 'a': 'Ser (S)'}, {'c': 'UCC', 'a': 'Ser (S)'},
    {'c': 'UCA', 'a': 'Ser (S)'}, {'c': 'UCG', 'a': 'Ser (S)'},
    {'c': 'UAU', 'a': 'Tyr (Y)'}, {'c': 'UAC', 'a': 'Tyr (Y)'},
    {'c': 'UAA', 'a': 'STOP'}, {'c': 'UAG', 'a': 'STOP'},
    {'c': 'UGU', 'a': 'Cys (C)'}, {'c': 'UGC', 'a': 'Cys (C)'},
    {'c': 'UGA', 'a': 'STOP'}, {'c': 'UGG', 'a': 'Trp (W)'},
    {'c': 'CUU', 'a': 'Leu (L)'}, {'c': 'CUC', 'a': 'Leu (L)'},
    {'c': 'CUA', 'a': 'Leu (L)'}, {'c': 'CUG', 'a': 'Leu (L)'},
    {'c': 'CCU', 'a': 'Pro (P)'}, {'c': 'CCC', 'a': 'Pro (P)'},
    {'c': 'CCA', 'a': 'Pro (P)'}, {'c': 'CCG', 'a': 'Pro (P)'},
    {'c': 'CAU', 'a': 'His (H)'}, {'c': 'CAC', 'a': 'His (H)'},
    {'c': 'CAA', 'a': 'Gln (Q)'}, {'c': 'CAG', 'a': 'Gln (Q)'},
    {'c': 'AUU', 'a': 'Ile (I)'}, {'c': 'AUC', 'a': 'Ile (I)'},
    {'c': 'AUA', 'a': 'Ile (I)'},
    {'c': 'GUU', 'a': 'Val (V)'}, {'c': 'GUC', 'a': 'Val (V)'},
    {'c': 'GUA', 'a': 'Val (V)'}, {'c': 'GUG', 'a': 'Val (V)'},
    {'c': 'GCU', 'a': 'Ala (A)'}, {'c': 'GCC', 'a': 'Ala (A)'},
    {'c': 'GCA', 'a': 'Ala (A)'}, {'c': 'GCG', 'a': 'Ala (A)'},
    {'c': 'CGU', 'a': 'Arg (R)'}, {'c': 'CGC', 'a': 'Arg (R)'},
    {'c': 'CGA', 'a': 'Arg (R)'}, {'c': 'CGG', 'a': 'Arg (R)'},

    {'c': 'ACU', 'a': 'Thr (T)'}, {'c': 'ACC', 'a': 'Thr (T)'},
    {'c': 'ACA', 'a': 'Thr (T)'}, {'c': 'ACG', 'a': 'Thr (T)'},

    {'c': 'AAU', 'a': 'Asn (N)'}, {'c': 'AAC', 'a': 'Asn (N)'},
    {'c': 'AAA', 'a': 'Lys (K)'}, {'c': 'AAG', 'a': 'Lys (K)'},

    {'c': 'AGU', 'a': 'Ser (S)'}, {'c': 'AGC', 'a': 'Ser (S)'},
    {'c': 'AGA', 'a': 'Arg (R)'}, {'c': 'AGG', 'a': 'Arg (R)'},

    {'c': 'GAU', 'a': 'Asp (D)'}, {'c': 'GAC', 'a': 'Asp (D)'},
    {'c': 'GAA', 'a': 'Glu (E)'}, {'c': 'GAG', 'a': 'Glu (E)'},

    {'c': 'GGU', 'a': 'Gly (G)'}, {'c': 'GGC', 'a': 'Gly (G)'},
    {'c': 'GGA', 'a': 'Gly (G)'}, {'c': 'GGG', 'a': 'Gly (G)'},
  ];

  List<Map<String, String>> _filteredCodons = [];

  @override
  void initState() {
    super.initState();
    _filteredCodons = _allCodons;
  }

  void _filterCodons(String query) {
    setState(() {
      _filteredCodons = _allCodons.where((item) {
        final codon = item['c']!.toLowerCase();
        final acid = item['a']!.toLowerCase();
        final search = query.toLowerCase();
        return codon.contains(search) || acid.contains(search);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            onChanged: _filterCodons,
            decoration: InputDecoration(
              hintText: 'Search Codons (e.g. AUG, STOP, Phe)',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
        Expanded(
          child: _filteredCodons.isEmpty
              ? const Center(child: Text('No matching codons found.'))
              : GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _filteredCodons.length,
            itemBuilder: (context, index) {
              final item = _filteredCodons[index];
              final isStop = item['a'] == 'STOP';
              final isStart = item['a']!.contains('START');

              return Card(
                elevation: 0,
                color: isStop
                    ? Colors.red[50]
                    : (isStart ? Colors.green[50] : Colors.blueGrey[50]),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['c']!,
                        style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        item['a']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isStop
                              ? Colors.red[700]
                              : (isStart
                              ? Colors.green[700]
                              : Colors.blueGrey[800]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// --- Tab 2: Amino Acid Properties with Search ---
class AminoAcidReference extends StatefulWidget {
  const AminoAcidReference({super.key});

  @override
  State<AminoAcidReference> createState() => _AminoAcidReferenceState();
}

class _AminoAcidReferenceState extends State<AminoAcidReference> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _allAA = [
    {'n': 'Alanine', 's': 'Ala', 'c': 'A', 'p': 'Non-polar', 'mw': '89.1', 'pI': '6.00'},
    {'n': 'Arginine', 's': 'Arg', 'c': 'R', 'p': 'Basic (+)', 'mw': '174.2', 'pI': '10.76'},
    {'n': 'Asparagine', 's': 'Asn', 'c': 'N', 'p': 'Polar', 'mw': '132.1', 'pI': '5.41'},
    {'n': 'Aspartic Acid', 's': 'Asp', 'c': 'D', 'p': 'Acidic (-)', 'mw': '133.1', 'pI': '2.77'},
    {'n': 'Cysteine', 's': 'Cys', 'c': 'C', 'p': 'Polar', 'mw': '121.2', 'pI': '5.07'},
    {'n': 'Glutamic Acid', 's': 'Glu', 'c': 'E', 'p': 'Acidic (-)', 'mw': '147.1', 'pI': '3.22'},
    {'n': 'Glutamine', 's': 'Gln', 'c': 'Q', 'p': 'Polar', 'mw': '146.2', 'pI': '5.65'},
    {'n': 'Glycine', 's': 'Gly', 'c': 'G', 'p': 'Non-polar', 'mw': '75.1', 'pI': '5.97'},
    {'n': 'Histidine', 's': 'His', 'c': 'H', 'p': 'Basic (+)', 'mw': '155.2', 'pI': '7.59'},
    {'n': 'Isoleucine', 's': 'Ile', 'c': 'I', 'p': 'Non-polar', 'mw': '131.2', 'pI': '6.02'},
    {'n': 'Leucine', 's': 'Leu', 'c': 'L', 'p': 'Non-polar', 'mw': '131.2', 'pI': '5.98'},
    {'n': 'Lysine', 's': 'Lys', 'c': 'K', 'p': 'Basic (+)', 'mw': '146.2', 'pI': '9.74'},
    {'n': 'Methionine', 's': 'Met', 'c': 'M', 'p': 'Non-polar', 'mw': '149.2', 'pI': '5.74'},
    {'n': 'Phenylalanine', 's': 'Phe', 'c': 'F', 'p': 'Non-polar', 'mw': '165.2', 'pI': '5.48'},
    {'n': 'Proline', 's': 'Pro', 'c': 'P', 'p': 'Non-polar', 'mw': '115.1', 'pI': '6.30'},
    {'n': 'Serine', 's': 'Ser', 'c': 'S', 'p': 'Polar', 'mw': '105.1', 'pI': '5.68'},
    {'n': 'Threonine', 's': 'Thr', 'c': 'T', 'p': 'Polar', 'mw': '119.1', 'pI': '5.60'},
    {'n': 'Tryptophan', 's': 'Trp', 'c': 'W', 'p': 'Non-polar', 'mw': '204.2', 'pI': '5.89'},
    {'n': 'Tyrosine', 's': 'Tyr', 'c': 'Y', 'p': 'Polar', 'mw': '181.2', 'pI': '5.66'},
    {'n': 'Valine', 's': 'Val', 'c': 'V', 'p': 'Non-polar', 'mw': '117.1', 'pI': '5.96'},
    {'n': 'Selenocysteine', 's': 'Sec', 'c': 'U', 'p': 'Polar', 'mw': '168.1', 'pI': '5.47'},
    {'n': 'Pyrrolysine', 's': 'Pyl', 'c': 'O', 'p': 'Basic (+)', 'mw': '255.3', 'pI': '9.75'},
    {'n': 'Ornithine', 's': 'Orn', 'c': '-', 'p': 'Basic (+)', 'mw': '132.2', 'pI': '9.70'},
    {'n': 'Citrulline', 's': 'Cit', 'c': '-', 'p': 'Polar', 'mw': '175.2', 'pI': '5.98'},
    {'n': 'Homocysteine', 's': 'Hcy', 'c': '-', 'p': 'Polar', 'mw': '135.2', 'pI': '5.05'},
    {'n': 'β-Alanine', 's': 'bAla', 'c': '-', 'p': 'Non-polar', 'mw': '89.1', 'pI': '6.80'},
    {'n': 'γ-Aminobutyric Acid', 's': 'GABA', 'c': '-', 'p': 'Non-polar', 'mw': '103.1', 'pI': '7.30'},
    {'n': 'Taurine', 's': 'Tau', 'c': '-', 'p': 'Polar', 'mw': '125.1', 'pI': '6.00'},
    {'n': 'Hydroxyproline', 's': 'Hyp', 'c': '-', 'p': 'Polar', 'mw': '131.1', 'pI': '6.30'},
    {'n': 'Hydroxylysine', 's': 'Hyl', 'c': '-', 'p': 'Basic (+)', 'mw': '162.2', 'pI': '9.60'},
    {'n': 'Norleucine', 's': 'Nle', 'c': '-', 'p': 'Non-polar', 'mw': '131.2', 'pI': '6.00'},
    {'n': 'Norvaline', 's': 'Nva', 'c': '-', 'p': 'Non-polar', 'mw': '117.1', 'pI': '6.00'},
    {'n': 'Sarcosine', 's': 'Sar', 'c': '-', 'p': 'Non-polar', 'mw': '89.1', 'pI': '6.98'},
    {'n': 'β-Hydroxyaspartic Acid', 's': 'bAsp', 'c': '-', 'p': 'Acidic (-)', 'mw': '149.1', 'pI': '2.80'},
    {'n': 'β-Hydroxyglutamic Acid', 's': 'bGlu', 'c': '-', 'p': 'Acidic (-)', 'mw': '163.1', 'pI': '3.20'},
    {'n': 'α-Aminoadipic Acid', 's': 'Aad', 'c': '-', 'p': 'Acidic (-)', 'mw': '161.2', 'pI': '3.00'},
    {'n': 'α-Aminobutyric Acid', 's': 'AABA', 'c': '-', 'p': 'Non-polar', 'mw': '103.1', 'pI': '6.50'},
    {'n': 'Canavanine', 's': 'Can', 'c': '-', 'p': 'Basic (+)', 'mw': '176.2', 'pI': '9.90'},
    {'n': 'Alloisoleucine', 's': 'aIle', 'c': '-', 'p': 'Non-polar', 'mw': '131.2', 'pI': '6.02'},
    {'n': 'D-Alanine', 's': 'D-Ala', 'c': '-', 'p': 'Non-polar', 'mw': '89.1', 'pI': '6.00'},
    {'n': 'D-Serine', 's': 'D-Ser', 'c': '-', 'p': 'Polar', 'mw': '105.1', 'pI': '5.68'},
    {'n': 'D-Aspartic Acid', 's': 'D-Asp', 'c': '-', 'p': 'Acidic (-)', 'mw': '133.1', 'pI': '2.77'},
    {'n': 'D-Glutamic Acid', 's': 'D-Glu', 'c': '-', 'p': 'Acidic (-)', 'mw': '147.1', 'pI': '3.22'},
    {'n': 'D-Valine', 's': 'D-Val', 'c': '-', 'p': 'Non-polar', 'mw': '117.1', 'pI': '5.96'},
    {'n': 'D-Leucine', 's': 'D-Leu', 'c': '-', 'p': 'Non-polar', 'mw': '131.2', 'pI': '5.98'},
    {'n': 'D-Isoleucine', 's': 'D-Ile', 'c': '-', 'p': 'Non-polar', 'mw': '131.2', 'pI': '6.02'},
    {'n': 'D-Phenylalanine', 's': 'D-Phe', 'c': '-', 'p': 'Non-polar', 'mw': '165.2', 'pI': '5.48'},
    {'n': 'D-Tryptophan', 's': 'D-Trp', 'c': '-', 'p': 'Non-polar', 'mw': '204.2', 'pI': '5.89'},
    {'n': 'D-Tyrosine', 's': 'D-Tyr', 'c': '-', 'p': 'Polar', 'mw': '181.2', 'pI': '5.66'},
    {'n': 'Phosphoserine', 's': 'pSer', 'c': '-', 'p': 'Polar', 'mw': '185.1', 'pI': '2.60'},
    {'n': 'Phosphothreonine', 's': 'pThr', 'c': '-', 'p': 'Polar', 'mw': '199.1', 'pI': '2.70'},
    {'n': 'Phosphotyrosine', 's': 'pTyr', 'c': '-', 'p': 'Polar', 'mw': '261.2', 'pI': '2.20'},
    {'n': 'N-Acetylcysteine', 's': 'NAC', 'c': '-', 'p': 'Polar', 'mw': '163.2', 'pI': '5.20'},
    {'n': 'N-Acetylmethionine', 's': 'NAM', 'c': '-', 'p': 'Non-polar', 'mw': '191.2', 'pI': '5.60'},
    {'n': 'Homoserine', 's': 'Hse', 'c': '-', 'p': 'Polar', 'mw': '119.1', 'pI': '5.70'},
    {'n': 'Homophenylalanine', 's': 'hPhe', 'c': '-', 'p': 'Non-polar', 'mw': '179.2', 'pI': '5.50'},
    {'n': 'Azetidine-2-carboxylic Acid', 's': 'Aze', 'c': '-', 'p': 'Non-polar', 'mw': '101.1', 'pI': '6.20'},
    {'n': 'Thialysine', 's': 'ThLys', 'c': '-', 'p': 'Basic (+)', 'mw': '162.3', 'pI': '9.60'},
    {'n': 'Diaminobutyric Acid', 's': 'Dab', 'c': '-', 'p': 'Basic (+)', 'mw': '118.1', 'pI': '8.80'},
    {'n': 'Diaminopropionic Acid', 's': 'Dap', 'c': '-', 'p': 'Basic (+)', 'mw': '104.1', 'pI': '8.40'},
    {'n': 'Aminolevulinic Acid', 's': 'ALA', 'c': '-', 'p': 'Polar', 'mw': '131.1', 'pI': '6.40'}

  ];

  List<Map<String, String>> _filteredAA = [];

  @override
  void initState() {
    super.initState();
    _filteredAA = _allAA;
  }

  void _filterAA(String query) {
    setState(() {
      _filteredAA = _allAA.where((aa) {
        final name = aa['n']!.toLowerCase();
        final short = aa['s']!.toLowerCase();
        final code = aa['c']!.toLowerCase();
        final search = query.toLowerCase();
        return name.contains(search) || short.contains(search) || code.contains(search);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            onChanged: _filterAA,
            decoration: InputDecoration(
              hintText: 'Search amino acids (e.g. A, Ala, Alanine)',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
        Expanded(
          child: _filteredAA.isEmpty
              ? const Center(child: Text('No results found.'))
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: _filteredAA.length,
            itemBuilder: (context, index) {
              final aa = _filteredAA[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(aa['c']!, style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(aa['n']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${aa['s']} | ${aa['p']}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _PropertyChip(label: 'MW', value: '${aa['mw']} Da'),
                          _PropertyChip(label: 'pI', value: aa['pI']!),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PropertyChip extends StatelessWidget {
  final String label, value;
  const _PropertyChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

/// --- Tab 3: Lab Buffer Recipes with Search ---
class BufferRecipes extends StatefulWidget {
  const BufferRecipes({super.key});

  @override
  State<BufferRecipes> createState() => _BufferRecipesState();
}

class _BufferRecipesState extends State<BufferRecipes> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allBuffers = [
    {
      'name': 'PBS (10X Stock)',
      'use': 'Phosphate Buffered Saline - Cell culture & IHC',
      'recipe': '80g NaCl, 2g KCl, 14.4g Na2HPO4, 2.4g KH2PO4 in 800mL dH2O. Adjust pH to 7.4, fill to 1L.'
    },
    {
      'name': 'TAE Buffer (50X Stock)',
      'use': 'Tris-Acetate-EDTA - DNA Electrophoresis',
      'recipe': '242g Tris base, 57.1mL Glacial Acetic Acid, 100mL 0.5M EDTA (pH 8.0) in 1L dH2O.'
    },
    {
      'name': 'TBE Buffer (10X Stock)',
      'use': 'Tris-Borate-EDTA - Polyacrylamide & DNA Electrophoresis',
      'recipe': '108g Tris base, 55g Boric Acid, 40mL 0.5M EDTA (pH 8.0) in 1L dH2O.'
    },
    {
      'name': 'TE Buffer (1X)',
      'use': 'Tris-EDTA - DNA/RNA Solubilization',
      'recipe': '10mM Tris-Cl (pH 8.0), 1mM EDTA.'
    },
    {
      'name': 'RIPA Buffer',
      'use': 'Protein Lysis - Radio-Immunoprecipitation Assay',
      'recipe': '150mM NaCl, 1% NP-40, 0.5% Sodium Deoxycholate, 0.1% SDS, 50mM Tris (pH 8.0).'
    },
    {
      'name': 'SSC Buffer (20X Stock)',
      'use': 'Saline-Sodium Citrate - Southern/Northern Blotting',
      'recipe': '175.3g NaCl, 88.2g Sodium Citrate in 800mL dH2O. Adjust pH to 7.0, fill to 1L.'
    },
    {
      'name': 'LB Medium (Luria-Bertani)',
      'use': 'Bacterial Culture (Broth)',
      'recipe': '10g Tryptone, 5g Yeast Extract, 10g NaCl per 1L dH2O. Autoclave to sterilize.'
    },
    {
      'name': 'TBS (10X Stock)',
      'use': 'Tris-Buffered Saline - Western Blotting Wash',
      'recipe': '24.2g Tris base, 80g NaCl in 800mL dH2O. Adjust pH to 7.6, fill to 1L.'
    },
    {
      'name': 'SDS-PAGE Running Buffer (10X)',
      'use': 'Protein Electrophoresis - Laemmli Running Buffer',
      'recipe': '30.3g Tris base, 144g Glycine, 10g SDS in 1L dH2O.'
    },
    {
      'name': '6X DNA Loading Dye',
      'use': 'Agarose Gel Loading & Visual Tracking',
      'recipe': '0.25% Bromophenol Blue, 0.25% Xylene Cyanol FF, 30% Glycerol in dH2O.'
    },
    {
      'name': 'HEPES Buffer (1X)',
      'use': 'Cell culture buffering',
      'recipe': '10–25mM HEPES, adjust pH to 7.2–7.5 with NaOH.'
    },
    {
      'name': 'MOPS Buffer (10X)',
      'use': 'RNA electrophoresis',
      'recipe': '200mM MOPS, 50mM Sodium Acetate, 10mM EDTA (pH 7.0).'
    },
    {
      'name': 'SOC Medium',
      'use': 'Bacterial recovery after transformation',
      'recipe': '20g Tryptone, 5g Yeast Extract, 0.5g NaCl, 2.5mL 1M KCl, 10mL 1M MgCl2, 20mL 1M Glucose per 1L.'
    },
    {
      'name': 'TB Medium',
      'use': 'High-density bacterial culture',
      'recipe': '12g Tryptone, 24g Yeast Extract, 4mL Glycerol per 1L.'
    },
    {
      'name': 'PBS-T',
      'use': 'Immunostaining wash buffer',
      'recipe': '1X PBS + 0.05% Tween-20.'
    },
    {
      'name': 'Blocking Buffer (5% Milk)',
      'use': 'Western blot blocking',
      'recipe': '5% Skim milk powder in 1X TBS or PBS.'
    },
    {
      'name': 'Blocking Buffer (5% BSA)',
      'use': 'Phospho-protein Western blot',
      'recipe': '5% BSA in 1X TBS-T.'
    },
    {
      'name': 'Transfer Buffer (Wet)',
      'use': 'Protein transfer in Western blot',
      'recipe': '25mM Tris, 192mM Glycine, 20% Methanol.'
    },
    {
      'name': 'Towbin Transfer Buffer',
      'use': 'SDS-PAGE protein transfer',
      'recipe': '25mM Tris, 192mM Glycine, 20% Methanol.'
    },
    {
      'name': 'Laemmli Sample Buffer (2X)',
      'use': 'Protein denaturation',
      'recipe': '4% SDS, 20% Glycerol, 0.02% Bromophenol Blue, 125mM Tris-HCl (pH 6.8), 10% β-ME.'
    },
    {
      'name': 'Native PAGE Buffer',
      'use': 'Non-denaturing protein electrophoresis',
      'recipe': '25mM Tris, 192mM Glycine (no SDS).'
    },
    {
      'name': 'Tris-HCl Buffer (1M)',
      'use': 'General pH buffering',
      'recipe': '121.1g Tris base per 1L, adjust pH with HCl.'
    },
    {
      'name': 'Carbonate-Bicarbonate Buffer',
      'use': 'ELISA plate coating',
      'recipe': '15mM Na2CO3, 35mM NaHCO3, pH 9.6.'
    },
    {
      'name': 'Glycine Buffer',
      'use': 'Antibody stripping',
      'recipe': '0.2M Glycine, pH 2.5.'
    },
    {
      'name': 'Stripping Buffer (Mild)',
      'use': 'Western blot reprobing',
      'recipe': '62.5mM Tris-HCl pH 6.8, 2% SDS, 100mM β-ME.'
    },
    {
      'name': 'IP Lysis Buffer',
      'use': 'Immunoprecipitation',
      'recipe': '50mM Tris-HCl pH 7.5, 150mM NaCl, 1% NP-40.'
    },
    {
      'name': 'ChIP Lysis Buffer',
      'use': 'Chromatin immunoprecipitation',
      'recipe': '50mM HEPES pH 7.5, 140mM NaCl, 1% Triton X-100.'
    },
    {
      'name': 'Nuclear Extraction Buffer',
      'use': 'Nuclear protein isolation',
      'recipe': '20mM HEPES, 400mM NaCl, 1mM EDTA, 1mM DTT.'
    },
    {
      'name': 'Cytoplasmic Lysis Buffer',
      'use': 'Cytosolic protein extraction',
      'recipe': '10mM HEPES, 10mM KCl, 0.1% NP-40.'
    },
    {
      'name': 'Alkaline Lysis Buffer I',
      'use': 'Plasmid isolation',
      'recipe': '50mM Glucose, 25mM Tris-HCl pH 8.0, 10mM EDTA.'
    },
    {
      'name': 'Alkaline Lysis Buffer II',
      'use': 'Plasmid isolation',
      'recipe': '0.2N NaOH, 1% SDS.'
    },
    {
      'name': 'Alkaline Lysis Buffer III',
      'use': 'Plasmid isolation',
      'recipe': '3M Potassium Acetate, pH 5.5.'
    },
    {
      'name': 'DNA Elution Buffer',
      'use': 'DNA purification',
      'recipe': '10mM Tris-HCl, pH 8.5.'
    },
    {
      'name': 'RNA Lysis Buffer',
      'use': 'RNA extraction',
      'recipe': '4M Guanidinium Thiocyanate, 25mM Sodium Citrate.'
    },
    {
      'name': 'Denhardt’s Solution (50X)',
      'use': 'Hybridization blocking',
      'recipe': '1% Ficoll, 1% PVP, 1% BSA.'
    },
    {
      'name': 'Hybridization Buffer',
      'use': 'Southern/Northern blot',
      'recipe': '50% Formamide, 5X SSC, 0.1% SDS.'
    },
    {
      'name': 'Fixation Buffer (PFA)',
      'use': 'Cell fixation',
      'recipe': '4% Paraformaldehyde in PBS.'
    },
    {
      'name': 'Permeabilization Buffer',
      'use': 'Immunofluorescence',
      'recipe': '0.1–0.5% Triton X-100 in PBS.'
    },
    {
      'name': 'Mounting Medium',
      'use': 'Microscopy sample mounting',
      'recipe': '90% Glycerol, 10% PBS.'
    },
    {
      'name': 'Calcium-Free PBS',
      'use': 'Cell detachment',
      'recipe': 'PBS without CaCl2 and MgCl2.'
    },
    {
      'name': 'Trypsin-EDTA',
      'use': 'Cell passaging',
      'recipe': '0.25% Trypsin, 1mM EDTA.'
    },
    {
      'name': 'Freezing Medium',
      'use': 'Cell cryopreservation',
      'recipe': '90% FBS, 10% DMSO.'
    },
    {
      'name': 'Wash Buffer (ELISA)',
      'use': 'ELISA plate washing',
      'recipe': 'PBS + 0.05% Tween-20.'
    },
    {
      'name': 'Substrate Buffer (ALP)',
      'use': 'ELISA detection',
      'recipe': '1M Diethanolamine, 0.5mM MgCl2, pH 9.8.'
    },
    {
      'name': 'Substrate Buffer (HRP)',
      'use': 'ELISA detection',
      'recipe': 'Citrate-Phosphate buffer pH 5.0.'
    },
    {
      'name': 'Citrate Buffer',
      'use': 'Antigen retrieval',
      'recipe': '10mM Sodium Citrate, pH 6.0.'
    },
    {
      'name': 'Phosphate Buffer',
      'use': 'General buffering',
      'recipe': '50mM Sodium Phosphate, pH 7.0.'
    },
    {
      'name': 'Borate Buffer',
      'use': 'Alkaline reactions',
      'recipe': '50mM Boric Acid, pH 8.5.'
    },
    {
      'name': 'MES Buffer',
      'use': 'Protein studies (acidic)',
      'recipe': '50mM MES, pH 6.0.'
    },
    {
      'name': 'PIPES Buffer',
      'use': 'Cell biology assays',
      'recipe': '50mM PIPES, pH 6.8.'
    },
    {
      'name': 'Saline Solution (0.9%)',
      'use': 'General washing',
      'recipe': '9g NaCl per 1L dH2O.'
    },
    {
      'name': 'Glycine-SDS Elution Buffer',
      'use': 'IP elution',
      'recipe': '0.1M Glycine, 0.1% SDS, pH 2.5.'
    },
    {
      'name': 'Urea Lysis Buffer',
      'use': 'Protein solubilization',
      'recipe': '8M Urea, 50mM Tris-HCl, pH 8.0.'
    }

  ];

  List<Map<String, dynamic>> _filteredBuffers = [];

  @override
  void initState() {
    super.initState();
    _filteredBuffers = _allBuffers;
  }

  void _filterBuffers(String query) {
    setState(() {
      _filteredBuffers = _allBuffers
          .where((buffer) =>
      buffer['name'].toLowerCase().contains(query.toLowerCase()) ||
          buffer['use'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            onChanged: _filterBuffers,
            decoration: InputDecoration(
              hintText: 'Search buffers (e.g. DNA, Blotting...)',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
        Expanded(
          child: _filteredBuffers.isEmpty
              ? const Center(child: Text('No matching buffers found.'))
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: _filteredBuffers.length,
            itemBuilder: (context, index) {
              final buffer = _filteredBuffers[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ExpansionTile(
                  title: Text(
                    buffer['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  subtitle: Text(buffer['use'], style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Recipe:', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                          const SizedBox(height: 8),
                          Text(buffer['recipe'], style: const TextStyle(fontSize: 15, height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}