# BHL/GN ruby entity extraction

Experiments in extracting entities in BHL corpus using GlobalNames gRPC endpoint, other services to extract named entities.

## Resources

### Edinburgh Geoparser

[The Edinburgh Geoparser](http://groups.inf.ed.ac.uk/geoparser/documentation/v1.1/html/index.html). Download and extract into a /geoparser directory. On macOS Mojave, modify the /geoparser/scripts/setup line 19 to read:

      Darwin?*)

This skips the macOS version check. YMMV.

Notes:
* does not produce character count for position of entity on page as does GN
* people names is poor
* TODO: remove scientific names from OCR content before passing to geonames (or other) as these can be people or place names such as Falco

### Rosette (TBD)

### IBM Watson (TBD)

