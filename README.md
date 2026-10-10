# StormChaseClaude: the WHIRL Index

**WHIRL** (Witter–Hart Integrated Rotational Likelihood) is a tornado-targeting score and chase reference for Illinois and the Midwest, built by Keith Witter and Brian Hart.

The site (`index.html`) includes:

- **Today's setup**: the live SPC Day 1 outlook, mesoanalysis, watches, reports and our radar sites.
- **WHIRL calculator**: score a setup from 0–500 m SRH, effective shear, MLCAPE, LCL, CIN, storm mode and boundaries.
- **Go or no-go** thresholds, the tornado window, and what to do after morning storms.
- **Picking the storm**: the in-field checklist.
- **Case library**: 12 Illinois/Missouri tornadoes and 5 supercell busts on a map, with radar and sounding sites.
- **Research ranking**: which ingredients best separate tornadoes from busts.

## Files

| Path | What it is |
| --- | --- |
| `index.html` | The whole site, one file |
| `data/cases.csv` | The case library (times in UTC for the script) |
| `tools/whirl_pipeline.py` | Pulls radar scans and soundings for each case and ranks the ingredients. Run it in Google Colab after `pip install metpy arm-pyart scikit-learn` |

## Adding a case

Add a row to `data/cases.csv` and the matching line to `CASES` in `tools/whirl_pipeline.py`. Busts (warned supercells with no tornado) are the biggest gap: we need at least seven more before the weights mean anything.

Not an official forecast. Always follow NWS warnings.
