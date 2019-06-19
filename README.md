# BHL/GN ruby entity extraction

Experiments in extracting entities in BHL corpus using GlobalNames gRPC endpoint, other services to extract named entities.

Adjust content in config.yml.sample and rename to config.yml

Clone and then:
      gem install bundler
      bundle install

## Resources

### Edinburgh Geoparser

[The Edinburgh Geoparser](http://groups.inf.ed.ac.uk/geoparser/documentation/v1.1/html/index.html). Download and extract into a /geoparser directory within this repo. On macOS Mojave, modify the /geoparser/scripts/setup line 19 to read:

      Darwin?*)

This skips the macOS version check. YMMV.

Use
      ./bin/geonames_people.rb

Issues and Strengths:
* does not produce character count for position of entity on page as does GN
* people names poorly differentiated from other text

### Rosette

Get your API get at [Rosette](https://www.rosette.com) and place in config.yml

Use
      ./bin/rosette.rb

Issues and Stengths:

### IBM Watson

Getting and using credentials is annoying, but follow instructions [here](https://github.com/watson-developer-cloud/ruby-sdk) for best results the put watson apikey and url in config.yml.

Use
      ./bin/watson.rb

Issues and Strenthgs
* extracts places, people with start and end character positions within text
* does not have URIs, other metadata for places like lats/longs
* language of text is detected prior to entity extraction
* throughout is approx. 125 pages / minute

