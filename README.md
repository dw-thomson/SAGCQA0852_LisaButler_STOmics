# SAGCQA0852_LisaButler_STOmics

- T7
- note: there were two projects on one samplesheet, with 2 samples each
- I need MGI's help to retrieve the mask files for this, this may delay the analysis
	- got the mask files from them on 6 Dec, (4 day wait)
- I'm going to run this with both SAW  v7 and SAW v8, to get a feel for v8
- I am assuming this is human
- analysis complete 11 Dec, report sent, results look textbook

SAGCQA0852
The libraries 24-06657 and 24-06658 belong to this project and are human Prostate tissue samples.
 
SAGCQA0932-2
The libraries 24-06592 and 24-06593 belong to this project and are Wheat inflorescence tissues.
 
| ULN       | SampleName  | SlideID     |
|-----------|-------------|-------------|
| 24-06657  | -           | D04319C6    |
| 24-06658  | -           | C04597D6    |

- NOTE the SlideID's were in the 'sampleName' field on the samplesheet
- 

samplesheet
```
Job_Number,SAGCQA0852_0932_2,,,
Date,2/12/2024,,,
MGI_Flowcell,E200030998,,,
[Reads],,,,
Read1_Cycles,50,,,
Read2_Cycles,100,,,
Barcode_Cycles,10,,,
DualBarcode_Cycles,0,,,
[Data],,,,
Sample_ID,Sample_Name,Index_ID,index,index2
24-06657,D04319C6,57-64,ATTCAACGGA,
24-06658,C04597D6,81-88,ATACTCACGC,
24-06592,B03621C3,89-96,CACCATGTCT,
24-06593,B03621G1,97-104,AGGTATTCTT,
```

# SAW analysis
```bash
#!/bin/bash

#SBATCH --job-name=SAW_run_SAGCQA0852_24-06657
#SBATCH --output=SAW_run_SAGCQA0852_24-06657.%j.log

# Resources allocation request parameters

#SBATCH --mail-user=daniel.thomson@sahmri.com
#SBATCH --mail-type=FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=120000
#SBATCH --time=3-00:00:00          # Run time in hh:mm:s
#SBATCH --nodelist=hpc-lin-cmp04

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

sample='24-06657'
sampleName='24-06657'
chipId='D04319C6'
iprFile=${imageDir}/D04319C6_20241128_112946/D04319C6_SC_20241128_112946_3.0.3.ipr
tgzFile=${imageDir}/D04319C6_20241128_112946/D04319C6_SC_20241128_112946_3.0.3.tar.gz
gtfFile=/hpc/capacity/reference/tool_specific/10X_genomics/spaceranger/refdata-gex-GRCh38-2020-A/genes/genes.gtf

FQ1=${fqDir}/${sample}_L01_R1.fastq.gz
FQ2=${fqDir}/${sample}_L01_R2.fastq.gz

maskFile=${BaseDir}/mask_files/D04319C6.barcodeToPos.h5
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
```

```bash
module load symlinks/1.4
symlinks -c visualization/

mv -c 24-06658 /cancer/storage/SAGC/projects/SAGCQA0852_LisaButler_STOmics
tar -cvf 24-06658.tar 24-06658
md5sum 24-06657.tar > 24-06657.tar.md5sum
```
- upload to Filesender

```bash
cd for_filesender
python3 /homes/daniel.thomson/gitrepos/filesender-mp/filesender_sagc.py -p -n 10 -r daniel.thomson@sahmri.com *

```

