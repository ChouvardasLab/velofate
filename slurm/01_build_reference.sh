#!/usr/bin/env bash

#SBATCH --time=02:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=kb_ref
#SBATCH --partition=pibu_el8
#SBATCH --output=kb_ref_%j.out
#SBATCH --error=kb_ref_%j.err

# Load Anaconda and activate the kb-python environment
module load Anaconda3/2022.05
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate <YOUR_CONDA_ENV>

# Move to the directory containing the reference files
cd <PATH_TO_KB_REFERENCE_FILES>

# Build the human reference for RNA velocity
kb ref \
  -d human \
  --workflow nac \          # Use the "nac" workflow for RNA velocity
  -i index.idx \
  -g t2g.txt \
  -c1 spliced_t2c.txt \
  -c2 unspliced_t2c.txt \
  -f1 spliced.fa \               
  -f2 unspliced.fa
