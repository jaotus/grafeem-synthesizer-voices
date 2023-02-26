#!/usr/bin/env bash

set -e

LANGUAGE=et
SPEAKER=minuhaal
test "$1" && SPEAKER=$1
INFILE=./test/txt/in_$SPEAKER.txt
OUTFILE=./test/wav/out_$SPEAKER.wav

mkdir -p -m 0777 corpus train voices test

echo check podman >log.log
podman -v &>>log.log && rt=podman || rt=docker
echo selected $rt >>log.log
echo "python ./scripts/speak.py -l $LANGUAGE -s $SPEAKER -o $OUTFILE naive $INFILE" >>log.log

exec $rt run --rm -i \
   -v $(realpath voices):/Ossian/voices \
   -v $(realpath test):/Ossian/test \
   ghcr.io/jaotus/hmm-grafeem-train:latest bash &>>log.log <<EOF
export LANG=C.utf8
export THEANO_FLAGS=""
export USER=tester

## conda activate ossian
. /venv/bin/activate

mkdir -p -m 0777 test/{wav,txt}
python ./scripts/speak.py -l $LANGUAGE -s $SPEAKER -o $OUTFILE naive $INFILE
echo Done $OUTFILE

cp $OUTFILE $OUTFILE.last
rm ./test/wav/out_$SPEAKER.lab

chmod -R 0777 test

EOF

