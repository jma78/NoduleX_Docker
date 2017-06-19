p=LIDC-IDRI-0016; \
for n in `ls -d data/binary_dicom/$p/*` ; do \
    echo "Converting nodule $n" ; \
    python dicom_and_image_tools/dicom_to_analyze.py \
        "$n" \
        "data/binary_analyze/$p/$(basename $n)" \
        && echo "OK" \
        || echo "FAILED converting nodule $n" \
;done