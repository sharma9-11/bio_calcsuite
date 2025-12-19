Bio-Calc Suite 

A Comprehensive Mobile Toolkit for Bioinformatics & Molecular Biology

Bio-Calc Suite is a high-performance, offline-first mobile application designed for life science researchers, students, and bioinformaticians. It replaces fragmented web-based utilities with a unified, scientifically accurate dashboard for daily laboratory calculations and sequence analysis.

* Key Features

 *Molecular Calculators

Molarity Calculator: Calculate mass required for solutions with automatic mL to Liter conversion.

Dilution (C1V1 = C2V2): Quick calculation for stock dilutions and final concentrations.

Ligation Calculator: Determine the exact mass of insert DNA needed based on vector mass and molar ratios (e.g., 3:1).

 *Sequence & Oligo Analysis

Oligo/Primer Analysis: Real-time calculation of sequence length, GC content (%), and Melting Temperature ($T_m$) using the Marmur-Doty and Wallace formulas.

Sequence Manipulation: Instant Reverse Complement, RNA Transcription, and 6-Frame Translation of DNA sequences.

 *Protein Properties

Molecular Weight: Accurate calculation of Protein MW in kDa.

Theoretical pI: Determination of the isoelectric point using iterative algorithms.

GRAVY Score: Hydropathy analysis based on the Kyte-Doolittle scale.

 *Searchable Reference Module

Genetic Code: Interactive mRNA codon map with highlighting for Start and Stop codons.

Amino Acid Database: Comprehensive data on all 20 standard amino acids (pI, MW, Polarity).

Lab Buffer Recipes: A searchable database of standard recipes (PBS, TAE, RIPA, SDS-PAGE, etc.).

 *Tech Stack

Framework: Flutter

Language: Dart

Architecture: Logic-UI Separation (Clean Architecture principles)

 *Project Structure

lib/
├── logic/             # Core scientific engines (Calculators, Tools)
├── screens/
│   ├── calculators/   # UI for Molarity, Protein, Oligo, etc.
│   ├── app_shell.dart # Main navigation container
│   ├── home_page.dart # Dashboard with Info/Credits
│   └── reference_page.dart # Searchable Reference modules
├── widgets/           # Reusable UI components (ResultCard, CustomTextField)
└── main.dart          # App entry point


* Developer

Sajal Sharma Biomolecular Calculation Dashboard Project

 *License

Distributed under the MIT License. See LICENSE for more information.
