# SAGCQA0852_LisaButler_STOmics

- T7
- note: there were two projects on one samplesheet, with 2 samples each
- I need MGI's help to retrieve the mask files for this, this may delay the analysis
	- got the mask files from them on 6 Dec, (4 day wait)
- I'm going to run this with both SAW  v7 and SAW v8, to get a feel for v8
- I am assuming this is human

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
time bash $scriptFile \
  -splitCount 1 \
  -maskFile ${maskFile} \
  -fq1 $FQ1 \
  -fq2 $FQ2 \
  -refIndex $refDir \
  -speciesName mm10 \
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

mv -c ET4/ /cancer/storage/SAGC/spatial_single_cell/SAGCQA0850-2_JoelCastro/outs

tar -cvf shared/ST3.tar ST3
```
- upload to Filesender

```bash
python3 /homes/daniel.thomson/gitrepos/filesender-mp/filesender_sagc.py -p -n 10 -r daniel.thomson@sahmri.com outs 

```

