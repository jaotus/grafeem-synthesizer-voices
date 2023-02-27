#!/usr/bin/env bash

set -e

LANGUAGE=et
SPEAKER=minuhaal
test "$1" && SPEAKER=$1
INFILE=data/txt/text.txt
OUTFILE=data/wav/$SPEAKER.wav

mkdir -p -m 0777 corpus train voices/et

podman -v &>>log.log && rt=podman || rt=docker

exec $rt run --rm -i \
   -v $(realpath voices):/Ossian/voices \
   -v $(realpath data):/Ossian/data \
   ghcr.io/jaotus/hmm-grafeem-train:latest bash <<EOF
export LANG=C.utf8
export THEANO_FLAGS=""
export USER=tester

## conda activate ossian
. /venv/bin/activate

mkdir -p -m 0777 data/{wav,txt}
python ./scripts/speak.py -l $LANGUAGE -s $SPEAKER -o $OUTFILE naive $INFILE
echo Done $OUTFILE

cp $OUTFILE $OUTFILE.last
#rm ./data/wav/out_$SPEAKER.lab

EOF