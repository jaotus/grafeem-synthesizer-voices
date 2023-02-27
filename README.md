## `grafeem_synthesizer` spontanous style trained voices

This repo has two HMM voices:
- Andreas1_v
- Lemmes2

Usage:
```bash
cd hmm
mkdir -p voices/et
unzip -d voices/et Andreas1_v.zip
mkdir -p data/{txt,wav}
echo "Lihtsalt nii on." >data/txt/text.txt
./minuhaal.sh Andreas1_v
aplay ./data/wav/Andreas1_v.wav
```
