#!/usr/bin/env bash

#SBATCH --time=06:00:00
#SBATCH --mem=128G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=kb_count
#SBATCH --partition=pibu_el8
#SBATCH --output=kb_count_%A_%a.out
#SBATCH --error=kb_count_%A_%a.err
#SBATCH --array=1-5

# Load Anaconda and activate the kb-python environment
module load Anaconda3/2022.05
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate <YOUR_CONDA_ENV>

# Define input, reference, and output directories
DATA_DIR=<PATH_TO_FASTQ_FILES>
REFERENCE_DIR=<PATH_TO_KB_REFERENCE>
BASE_OUT_DIR=<PATH_TO_OUTPUT_DIRECTORY>
ACC_LIST=<PATH_TO_ACCESSION_LIST>

# Move to the reference directory
cd "$REFERENCE_DIR"

# Get the accession for the current array task
ACC=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$ACC_LIST")

# Create a separate output directory for each sample
SAMPLE_OUT="$BASE_OUT_DIR/$ACC"
mkdir -p "$SAMPLE_OUT"

echo "Starting kb count for sample: $ACC"

# Generate the filtered h5ad count matrix
kb count \
  -i index.idx \
  -g t2g.txt \
  -c1 spliced_t2c.txt \
  -c2 unspliced_t2c.txt \          
  --workflow nac \                  # Use the "nac" workflow for RNA velocity
  -x 10XV2 \                        # Specify the technology (e.g., 10XV2, 10XV3, etc.)
  --filter bustools \               # Use bustools for filtering
  --h5ad \                          # Output the count matrix in h5ad format
  -o "$SAMPLE_OUT" \
  -t "$SLURM_CPUS_PER_TASK" \
  "$DATA_DIR/${ACC}_1.fastq.gz" \
  "$DATA_DIR/${ACC}_2.fastq.gz"
