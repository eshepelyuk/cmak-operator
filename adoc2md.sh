#!/bin/bash

# asciidoctor -a env-github -b docbook -a leveloffset=+1 -o - README.adoc | pandoc --markdown-headings=atx --wrap=preserve -t gfm -f docbook -

sed -i 's/^plantuml::arch.puml.*$/![Component diagram](http:\/\/www.plantuml.com\/plantuml\/proxy?cache=no\&src=https:\/\/raw.githubusercontent.com\/eshepelyuk\/cmak-operator\/master\/arch.puml)/g' README.md
