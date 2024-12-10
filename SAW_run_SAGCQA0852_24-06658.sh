#!/bin/bash

#SBATCH --job-name=SAW_run_SAGCQA0852_24-06658
#SBATCH --output=SAW_run_SAGCQA0852_24-06658.%j.log

# Resources allocation request parameters

#SBATCH --mail-user=daniel.thomson@sahmri.com
#SBATCH --mail-type=FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=120000
#SBATCH --time=3-00:00:00          # Run time in hh:mm:s
#SBATCH --nodelist=hpc-lin-cmp03

echo "Executed on node $HOSTNAME"

date

GENOME='hg38'
PROJECT='SAGCQA0852'
BaseDir='/cancer/storage/SAGC/projects/SAGCQA0852_LisaButler_STOmics'
sifFile=/hpc/capacity/SAGC/containers/sif/SAW_7.1.sif
scriptFile=/hpc/capacity/SAGC/spatial_single_cell/SAW/Scripts/stereoPipeline_v7.1.sh
refDir=/hpc/capacity/reference/tool_specific/SAW/$GENOME

imageDir=${BaseDir}/STOmics_image_data/SAGCQA0852_LisaButler_MikeCilento_QCResults
fqDir=/cancer/storage/SAGC/fastq/SAGCQA0852/E200030998/fastq

sample='24-06658'
sampleName='24-06658'
chipId='C04597D6'
iprFile=${imageDir}/C04597D6_20241128_113258/C04597D6_SC_20241128_113258_3.0.3.ipr
tgzFile=${imageDir}/C04597D6_20241128_113258/C04597D6_SC_20241128_113258_3.0.3.tar.gz
gtfFile=/hpc/capacity/reference/tool_specific/10X_genomics/spaceranger/refdata-gex-GRCh38-2020-A/genes/genes.gtf

FQ1=${fqDir}/${sample}_L01_R1.fastq.gz
FQ2=${fqDir}/${sample}_L01_R2.fastq.gz

maskFile=${BaseDir}/mask_files/C04597D6.barcodeToPos.h5
tmpDir=/local/${sampleName}

#outDir=${BaseDir}/${sampleName}
cd ${BaseDir}

time bash $scriptFile \
  -splitCount 1 \
  -maskFile ${maskFile} \
  -fq1 $FQ1 \
  -fq2 $FQ2 \
  -refIndex $refDir \
  -speciesName ${GENOME} \
  -annotationFile ${gtfFile} \
  -outDir $tmpDir \
  -imageRecordFile ${iprFile} \
  -imageCompressedFile ${tgzFile} \
  -doCellBin Y \
  -rRNAremove Y \
  -threads 32 \
  -sif ${sifFile}

#  -genomeFile ${refDir}/fasta/genome.fa \
#  -tissueType rheumatoid_arthritis_synovial \

date

#mv -v ${tmpDir} ${BaseDir}

echo DONE

date

