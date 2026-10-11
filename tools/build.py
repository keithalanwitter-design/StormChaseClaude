"""Build the WHIRL site from src/app.html.

  python3 tools/build.py

Writes:
  index.html          full page for GitHub Pages (saves the chase log in the browser)
  dist/artifact.html  the same app for the shared Claude page (shared chase log)
Map shapes and case locations come from data/geo.json; data/fit.json places
cases your team adds on the map.
"""
import pathlib
root = pathlib.Path(__file__).resolve().parent.parent
app = (root / "src/app.html").read_text()
app = app.replace("__GEO__", (root / "data/geo.json").read_text().strip())
app = app.replace("__FIT__", (root / "data/fit.json").read_text().strip())
LIVE = ('<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">\n'
        '<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>\n'
        '<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.45.4/dist/umd/supabase.js"></script>\n'
        '<script src="config.js"></script>')
(root / "dist").mkdir(exist_ok=True)
# the shared Claude page can't load outside data, so it shows a link to the live map instead
(root / "dist/artifact.html").write_text(app.replace("<!--LIVE_HEAD-->\n", ""))
app = app.replace("<!--LIVE_HEAD-->", LIVE)
head, rest = app.split("</style>", 1)
page = ("<!doctype html>\n<html lang=\"en\">\n<head>\n<meta charset=\"utf-8\">\n"
        "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1, viewport-fit=cover\">\n"
        "<meta name=\"description\" content=\"WHIRL: a Midwest tornado chase hub with a scoring engine, chase log, case library and field guide.\">\n"
        + head + "</style>\n</head>\n<body>\n" + rest.strip() + "\n</body>\n</html>\n")
(root / "index.html").write_text(page)
print("built index.html and dist/artifact.html")
