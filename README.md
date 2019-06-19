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

* does not produce character count for position of entity on page as does GN services and IBM Watson (as option)
* people names poorly differentiated from other text, many example of "people" that are not so

### Rosette

Get your API get at [Rosette](https://www.rosette.com) and place in config.yml

Use
      ./bin/rosette.rb

Issues and Stengths:

* Limited number of permissible calls until forced to pay for service

### IBM Watson

Getting and using credentials is annoying, but follow instructions [here](https://github.com/watson-developer-cloud/ruby-sdk) for best results the put watson apikey and url in config.yml.

Use
      ./bin/watson.rb

Issues and Strengths:

* extracts places, people with start and end character positions within text
* does not additionally resolve to URIs or other metadata for places such as lats/longs
* language of text is detected prior to entity extraction
* throughput is approx. 125 pages / minute on a single thread of calls

