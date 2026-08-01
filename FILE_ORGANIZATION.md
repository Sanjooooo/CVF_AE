# File organization

The active workspace is organized around the CVF-AE Route B paper and its frozen
formal results. Route A, CEC frameworks, superseded Route B code, historical
results, and deprecated paper figures are stored in the local cleanup archive.

## Active layout

- `routes/route_b_cvf_ae/paper_ajse_zh/`
  - Current Chinese manuscript, tables, figures, bibliography, and quality notes.
- `routes/route_b_cvf_ae/results/`
  - Five retained current result directories: selected-seven formal comparison,
    selected-seven paper artifacts, corrected formal ablation, corrected ablation
    paper artifacts, and the internal template-initialization ablation.
- `routes/route_b_cvf_ae/experiments/`
  - Internal template-initialization ablation and its isolated initialization
    override.
- `routes/route_b_cvf_ae/docs/`
  - Route B project history, manuscript notes, and the maintained execution-chain
    definition in `CVF_AE_ACTIVE_PIPELINE.md`.
- MATLAB `.m` files in the project root
  - Functions required by the current selected-seven comparison, corrected
    ablation, and paper-artifact chains. They remain at the root so MATLAB can run
    the maintained entry points without additional path setup.

## Local archive

`archive/cleanup_20260801/` preserves migrated content by category and original
relative path. Nothing in this archive is required by the current Route B call
chain. Binary archive files may remain ignored by Git and should therefore be
treated as local recovery material.

The checksum-verified backup of current formal `.mat` records is stored outside
the repository at `D:/MATLAB/Project/COVE_AE_matlab_formal_mat_backup_20260801/`.

## Maintenance rule

New formal runs must use the maintained entry points documented in
`routes/route_b_cvf_ae/docs/CVF_AE_ACTIVE_PIPELINE.md`. Do not restore historical
comparison algorithms or split-result fallbacks into the selected-seven pipeline
unless the experimental protocol is intentionally revised.
