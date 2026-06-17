# File Organization

This project now separates route-specific research materials from shared MATLAB infrastructure.

## Top-Level Layout

- `routes/route_a_cove_ae/`
  - Historical Route A materials for the COVE-AE reset/diagnostic line.
  - Contains prior diagnostic and ablation result folders under `results/`.
  - Kept for traceability, not as the current paper direction.

- `routes/route_b_cvf_ae/`
  - Current Route B materials for the `CVF-AE` strong-innovation line.
  - Contains the active CVF-AE project plan, todo list, and paper outline under `docs/`.
  - Future CVF-AE-specific code, diagnostics, and results should be placed here when they are created.

- `docs/`
  - Shared project log and general project documentation.
  - `PROJECT_LOG.md` remains the chronological record for the whole project.

- MATLAB `.m` files in the project root
  - Shared runnable MATLAB infrastructure.
  - These files are intentionally kept at the root for now so existing MATLAB scripts continue to run without path changes.
  - Route-specific implementations should be separated only when the corresponding path setup is added.

- `cec2017_framework/`, `experiments/`, `legacy_docs/`
  - Existing auxiliary or legacy assets.

## Current Rule

Do not mix new CVF-AE route-B materials into route-A result folders.

Use:

- Route A historical results: `routes/route_a_cove_ae/results/`
- Route B planning/docs: `routes/route_b_cvf_ae/docs/`
- Future Route B results: `routes/route_b_cvf_ae/results/`

## MATLAB Path Note

The route split currently organizes documents and results. Core MATLAB functions remain in the project root to avoid breaking scripts that call functions by name from the current folder.

If future code is moved into route-specific folders, add an explicit path setup script first.
