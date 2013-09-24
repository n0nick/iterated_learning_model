#!/bin/bash

cut -f2 -d# | sed 's/[a-z]*:/,/g'
