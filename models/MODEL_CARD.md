# Model Card — Coolant

**Version:** 1.0.0  
**Date:** 2026-09-28  
**Git commit:** `d9a86688598a`  

## Environment

- **python**: 3.10.12
- **numpy**: 2.2.6
- **pandas**: 2.3.3
- **lightgbm**: 4.7.0
- **platform**: Linux-6.18.33.2-microsoft-standard-WSL2-x86_64-with-glibc2.35

## Data Hashes (SHA-256)

- `train.parquet`: `4d19018afa8dff30...`
- `val.parquet`: `260386fb68701de1...`
- `test.parquet`: `c0535ba4e87a0219...`

## Model Hash (SHA-256)

- `coolant_tier_lgbm.txt`: `86e1be6fd44e788b...`

## Headline Metrics

- **regression_MAE_C**: 0.8310498041944985
- **prediction_lead_min**: 115
- **degree_min_reduction_pct**: 90.6250027931628
- **events_reduction_pct**: 77.91666666666664

## Limitations

- One site (Frontier), one year (2023).
- Offline counterfactual evaluation. No live control-loop deployment.
- Twin validated to 1.35 °C MAE. Downstream metrics carry this uncertainty.
- Feature set includes raw telemetry; real deployment requires sensor preprocessing.
