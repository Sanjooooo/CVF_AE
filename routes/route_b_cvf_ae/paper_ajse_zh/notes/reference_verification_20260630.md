# Reference Verification Log, 2026-06-30

## Scope

- Checked `bib/references.bib`.
- Total entries: 27.
- DOI-resolvable entries after correction: 26.
- Entries without DOI after correction: 1.
- Verification route: DOI metadata requested through `https://doi.org/{doi}` using CSL JSON.
- Zotero local API status during this check: preference enabled, but API/connector not running on `127.0.0.1:23119`; no Zotero library write was performed.

## Corrections

- `Holm1979Sequential`: removed invalid DOI-like JSTOR stable identifier `10.2307/4615733`; added `url = {https://www.jstor.org/stable/4615733}`.
- `Deb2000ConstraintHandling`: normalized issue field from `2--4` to `2-4` to match DOI metadata.

## Checked Ambiguities

- `Kumar2025UAVReview`: DOI metadata resolves and matches title, journal, volume, issue, and pages. The DOI `issued` date is 2025, while ACM Computing Surveys volume 58 issue 3 is a 2026 volume; the current BibTeX year was kept as `2025` to match DOI `issued`.
- `Liu2025ECPO3D`: DOI metadata confirms the title uses `Crowned Porcupine`, while the original CPO paper uses `Crested Porcupine`; this is not a local typo.
- Scientific Reports UAV path-planning entries were checked through DOI metadata for title, journal, year, volume, and issue. No mismatch remained after the above corrections.

## Post-correction Status

- Re-run DOI check after edits: 27 entries total, 26 DOI OK, 1 no DOI, 0 metadata mismatch.
