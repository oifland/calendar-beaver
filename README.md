calendar-beaver
===============

A small set of scripts to build a calendar from SVG templates using Inkscape, Ruby, pdftk, and a few Rails helpers.

Requirements
------------

These need to be installed and available in your path

- Ruby (that's what the scripts are written in)
- Inkscape (used to turn SVG templates into PDFs)
- pdftk (used to combine PDFs into a single PDF)
- nokogiri gem (for modifying SVG/XML documents)
- Rails (or ActiveSupport at least)

Getting Started
---------------

1. Edit the grid.svg and top.svg files to your liking. Leave the day numbers and structure the same, but feel free to adjust fonts and such.
2. Edit the list of holidays in holiday_finder.rb
3.  Run "ruby generator.rb" to produce your upper and lower folders with SVG files and sample backgrounds
4. Edit the generated SVG files, replacing background files and perhaps adjusting text (don't forget the cover and the back)
5. Combine all your work into a single PDF by running "ruby bind.rb"
6. Your file is output to calendar.pdf
