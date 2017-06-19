for n in `ls -d data/built_dataset/*` ; do \
    echo "Converting nodule $n" ; \
    python dicom_and_image_tools/segment_to_binary_image.py --candidates data/nodule_lists/S1vS45_TRAIN_candidates.txt --segmented-only \
        "$n" \
        "data/binary_dicom/$(basename $n)" \
        && echo "OK" \
        || echo "FAILED converting nodule $n" \
;done