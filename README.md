# NoduleX_Docker
Containerize the process from https://github.com/jcausey-astate/NoduleX_code

# Step 1: Build dataset
will create dir in /data/ called "built_dataset"  
/NoduleX_code/dicom_and_image_tools/simplify-doi-structure.sh -s /NoduleX_code/data/DOI /NoduleX_code/data/built_dataset  
"DOI" contains the proginal data downloaded from https://wiki.cancerimagingarchive.net/display/Public/LIDC-IDRI  
"built_dataset" contains dataset built to a flattened directory structure  

# Step 2: Create Segmentation Masks(DICOM format)
(temporarily upload zip file from host to container)
will create dir in /data/ called "binary_dicom"  
process in batch: run2.sh  
'''  
for n in `ls -d data/built_dataset/*` ; do \
    echo "Converting nodule $n" ; \
    python dicom_and_image_tools/segment_to_binary_image.py --candidates data/nodule_lists/S1vS45_TRAIN_candidates.txt --segmented-only \
        "$n" \
        "data/binary_dicom/$(basename $n)" \
        && echo "OK" \
        || echo "FAILED converting nodule $n" \
;done  
’‘’

# Step 3: Convert DICOM to Analyze format
will create dir in /data/ called "binary_analyze"  
run: run.sh  
'''  
p=LIDC-IDRI-0011; \
for n in `ls -d data/binary_dicom/$p/*` ; do \
    echo "Converting nodule $n" ; \
    python dicom_and_image_tools/dicom_to_analyze.py \
        "$n" \
        "data/binary_analyze/$p/$(basename $n)" \
        && echo "OK" \
        || echo "FAILED converting nodule $n" \
;done  
'''

# Step 4: QIF feature extraction
