#!/bin/bash -ex

# pip install arize-phoenix-otel
docker run \
  --name arize-phoenix \
  --rm \
  -p 6006:6006 \
  -p 4317:4317 \
  -d \
  arizephoenix/phoenix:latest

# Stop the container on script exit
trap 'echo "Stopping arize-phoenix container..."; docker stop arize-phoenix' EXIT

export PHOENIX_COLLECTOR_ENDPOINT=http://localhost:6006

# Ordered datasets (by Corpus.json size, then Question.json)
datasets=(
#  mix
  multihop-rag
#  multihop-rag-summary
#  quality
#  agriculture
#  cs
#  Popqa
#  musique
#  legal
#  hotpotqa
#  ALCE
)

# ls Option/Method/*.yaml | sort
yaml_files=(
  Option/Method/Dalk.yaml
  Option/Method/GGraphRAG.yaml
  Option/Method/GR.yaml
  Option/Method/HippoRAG.yaml
  Option/Method/KGP.yaml
  Option/Method/LGraphRAG.yaml
  Option/Method/LightRAG.yaml
  Option/Method/MedG.yaml
  Option/Method/RAPTOR.yaml
  Option/Method/ToG.yaml
)

rm -rf "my_result/my_test/"
# Loop over datasets
for dataset in "${datasets[@]}"; do
  rm -rf "my_result/$dataset"
  # Loop over YAML files in alphabetical order
  for yaml in "${yaml_files[@]}"; do
    echo "Running: $yaml on dataset: $dataset"
    python main.py -opt "$yaml" -dataset_name "$dataset"
  done
done

echo "All done! Remember to check Arize Phoenix trace."
read -n 1 -s -r -p "Press any key to exit..."

exit 0
