# Raw Data

## File

`frontier_2023.xlsx` — 49,869 rows × 18 columns, 10-minute resolution,
calendar year 2023.

## Source

**Frontier HPC & Facility dataset**
Oak Ridge National Laboratory (ORNL)

- figshare DOI: [10.6084/m9.figshare.24391240.v4](https://doi.org/10.6084/m9.figshare.24391240.v4)
- Reference: Sun et al., *Scientific Data* 11, 1077 (2024)
- License: CC BY 4.0 (see figshare for details)

## Columns

| Column | Unit | Description |
| --- | --- | --- |
| Date/Time | timestamp | 10-minute interval |
| SubLoop1-Coolant Return Temp | °C | Return temp from subloop 1 |
| SubLoop1-Coolant Flow | gpm | Flow within subloop 1 |
| SubLoop2-Coolant Return Temp | °C | Return temp from subloop 2 |
| SubLoop2-Coolant Flow | gpm | Flow within subloop 2 |
| SubLoop3-Coolant Return Temp | °C | Return temp from subloop 3 |
| SubLoop3-Coolant Flow | gpm | Flow within subloop 3 |
| Overall-average Coolant Return Temp | °C | Average return across subloops |
| Overall Coolant Supply Temp | °C | Supply temp to subloops |
| Overall Coolant Flow | gpm | Total flow across subloops |
| SubLoop1_WasteHeat | MW | Heat removed by subloop 1 |
| SubLoop2_WasteHeat | MW | Heat removed by subloop 2 |
| SubLoop3_WasteHeat | MW | Heat removed by subloop 3 |
| Overall_WasteHeat | MW | Total heat removed |
| Frontier Compute Power | MW | Frontier HPC power demand |
| Frontier Facility accessory Power | MW | Facility accessory power |
| Frontier Total Power | MW | Overall facility power |
| Power Usage Effectiveness | – | PUE (dimensionless) |

## Structural Notes

- **Row 0** (Excel row 1): column names
- **Row 1** (Excel row 2): unit row (dropped during load)
- **Rows 2+**: actual data

Loading uses `pd.read_excel(path, header=0)` then `df.iloc[1:].reset_index(drop=True)`
to discard the units row.

## Known Issues

- **2,691 missing timestamps** (~5% of the full-year grid) — reindexed
  during preprocessing and interpolated where gaps were short.
- **122 missing `avg_return_temp` values** — interpolated.
- **68 rows with return temperature ≤ supply temperature** — flagged as
  physical violations and set to NaN before interpolation.
- **Non-breaking spaces** (`\xa0`) in some Excel column headers —
  stripped during load.

## Redistribution

This dataset is redistributed under the same CC license used by the
original figshare deposit. See the figshare DOI for the canonical version.
