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

## How the app is built

- `src/app.html` is the one source file. The **WHIRL engine** (every factor, weight and tier) is a single `WHIRL` object near the top of its script; the calculator, the "how the score works" table and the chase log all read from it.
- `python3 tools/build.py` turns it into `index.html` (the website) and `dist/artifact.html` (the Claude copy).
- **Shared chase log**: fill in `config.js` and run `supabase/setup.sql` (steps in `supabase/README.md`). Until then the log saves in each browser.
- **Live map layers**: each overlay is one entry in the `LAYERS` list in `src/app.html` (feed URL, how to draw it, status text). Add an entry to add a layer.
- `data/geo.json` holds the map shapes and case locations; `data/fit.json` places cases you add on the map.
- The **chase log** is the learning loop: score a day, mark tornado or bust afterward, and the "Is the score working?" chart finds the cutoff that best separates the two.
