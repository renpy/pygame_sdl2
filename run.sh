#!/bin/bash

set -e

export CC="ccache gcc"
python setup.py install

exec python "$@"
