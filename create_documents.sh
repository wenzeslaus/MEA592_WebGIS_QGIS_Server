#!/bin/bash

pandoc --from=rst --to=html --toc --css=style.css --output=qgis_server_assignment.html qgis_server_assignment.rst

