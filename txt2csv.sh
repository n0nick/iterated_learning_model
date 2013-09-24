#!/bin/bash

echo "generation,grammar,meanings"
cut -f2 -d# | sed 's/[a-z]*:/,/g' | tr -d '\040\011'
