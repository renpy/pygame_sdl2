#!/bin/bash

set -e

export CC="ccache gcc"
python setup.py -q install

exec python "$@"
