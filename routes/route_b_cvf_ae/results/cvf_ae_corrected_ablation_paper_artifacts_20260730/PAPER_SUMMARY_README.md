# Corrected ablation paper summary

This directory provides the lightweight, paper-facing summary of the corrected
CVF-AE ablation experiment. The exported `Scene` field follows the manuscript's
Scene 1--3 labels.

- `paper_table_ablation.csv`: aggregate results for 3 scenes, 6 variants, and 30
  independent runs per scene-variant pair.
- `corrected_ablation_overhead.csv`: aggregate evaluation counts and CVF trigger
  statistics used for the overhead analysis.

Per-run `.mat` records and the complete summary workspaces are intentionally not
stored in Git. They are retained in the formal local result directory and in the
separate checksum-verified backup created on 2026-08-01.
