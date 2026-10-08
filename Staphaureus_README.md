# Staphaureus: Comparative Genomic Survey of Membrane Transporters Across *Staphylococcus*

Independent research project, University of York (dir. Gavin Thomas), 2025 to 2026.

A comparative genomics pipeline testing whether *Staphylococcus* lineages carry distinct membrane transporter repertoires shaped by niche-specific carbon source availability (the "sugar-nutrition" hypothesis).

## Key results

| | |
|---|---|
| Genomes surveyed | 72 (*Staphylococcus* and *Mammaliicoccus*) |
| TCDB transporter families annotated | 100+ (via TransAAP) |
| Transporters per genome | 269 to 440 |
| MFS copies per genome | median ~34 (range 22 to 58) |
| YggT (single-copy reference locus) | invariant at exactly 1 copy in all 72 genomes |
| GntP paralog groups | reclassified from 10 provisional tree-based clades into **7** flanking-gene-validated groups via WebFlaGs synteny analysis |
| Ancestral GntP paralog | present in **68/72** genomes |
| Accessory GntP paralogs | 6 groups, concentrated almost exclusively in the *Saprophyticus*/*xylosus* clade |

Findings support a niche-specific "sugar-nutrition" hypothesis: different *Staphylococcus* lineages appear to tailor their transporter repertoires to the carbon sources available in their ecological niche, consistent with independent transcriptomic evidence.

## Pipeline

1. **Annotation:** transporter proteins identified across 72 genomes via TransAAP, covering 100+ TCDB families.
2. **Extraction (Python):** a custom script parses annotated genome files, resolves non-standard locus tags to species identities, and extracts transporter protein sequences by family (MFS, GntP, ThrE, and the single-copy YggT reference locus).
3. **Family identification and quantification (R):** transporter family distributions quantified and visualised across the genome set.
4. **Alignment and phylogenetics:** multiple sequence alignment via MAFFT/MUSCLE; Neighbour-Joining trees built and annotated in Jalview and iTOL.
5. **Synteny validation (WebFlaGs):** gene neighbourhood analysis used to validate or reclassify tree-based paralog groupings, distinguishing true ancestral linkage from convergent tree topology.

## Repository structure

```
Staphaureus/
├── dev/        analysis scripts (Python extraction pipeline, R quantification and plotting)
├── figures/    output trees, distribution plots
└── README.md
```

*(Update this section to match your actual file names inside `dev/`, listing the specific `.py` and `.R` scripts and what each one does, so a reader can find the right file without opening every one.)*

## Requirements

- Python 
- R 
- [Jalview](https://www.jalview.org/), [iTOL](https://itol.embl.de/), [WebFlaGs](https://server.atkinson-lab.com/webflags)

*(Add a `requirements.txt` for Python packages and note any R package dependencies if you want this fully reproducible by someone else.)*

## Attribution

Independent research report conducted as part of the MSc Bioinformatics programme, University of York, under the direction of Gavin Thomas. This repository contains my individual analysis and code.
