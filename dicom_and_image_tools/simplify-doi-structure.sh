#/bin/bash
# Args: [-s] DOI-dir result-dir
#  -s specifies "create symbolic links" to all files, don't actually copy
# ---------------------------------------------------------------------------


# Platform-independant substitute for "readlink -f" based on code found at:
# http://stackoverflow.com/a/19250873
# Modified to only care about "existence" (file or directory is OK)
function get_realpath() {

	[[ ! -e "$1" ]] && return 1 # failure : file does not exist.
	[[ -n "$no_symlinks" ]] && local pwdp='pwd -P' || local pwdp='pwd' # do symlinks.
	d="$1"
	[[ "${d%/*}" == "$d" ]] && d="./$d"							       # handle relative from cwd
	echo "$( cd "$( echo "${d%/*}" )" 2>/dev/null; $pwdp )"/"${d##*/}" # echo result.
	return 0 # success

}

function show_usage() {

	echo -e "Usage:\n\t$(basename ${0}) [-s] DOI-dir result-dir"
	echo -e "\t\t-s\tcreate symbolic links to files, not copies"
	echo

}

LINK=0
if [[ "$1" == "-s" ]] ; then
	LINK=1
	shift
fi

if [[ "$#" -lt 2 ]] ; then
	show_usage
	exit 1
fi

DOI_DIR="$(get_realpath $1)"
OUT_DIR="$(get_realpath $2)"
SD="$(dirname $0)"

if [[ -z "$DOI_DIR" ]] ; then
	echo "DOI directory \"$1\" does not exist."
	show_usage
	exit 2
fi

if [[ -z "$OUT_DIR" ]] ; then
	OUT_DIR="$2"
	mkdir -p "${OUT_DIR}"
fi

LEN=${#DOI_DIR}
LEN=$(( LEN - 1 ))
if [[ "${DOI_DIR:$LEN}" == "/" ]] ; then
    DOI_DIR=${DOI_DIR:0:$LEN}             # drop the extra trailing slash
fi
LEN=${#OUT_DIR}
LEN=$(( LEN - 1 ))
if [[ "${OUT_DIR:$LEN}" == "/" ]] ; then
    OUT_DIR=${OUT_DIR:0:$LEN}             # same for output dir
fi

for patient in `ls ${DOI_DIR}` ; do
	if [[ ${patient:0:1} == "." ]] ; then
		continue
	fi
	DIRS=`${SD}/walk-doi.sh "${DOI_DIR}/${patient}"`
	NDIRS="$(echo $DIRS | wc -l)" 
	echo "$patient has $NDIRS scans..." 
	scan_i=1
	for scan in "$DIRS" ; do
		suffix=""
		if [[ "$NDIRS" -gt 1 ]] ; then
			suffix="_${scan_i}"
		fi
		OUT_PATIENT_DIR="${OUT_DIR}/${patient}${suffix}"
		mkdir -p "$OUT_PATIENT_DIR"
		if [[ "$LINK" -eq 0 ]] ; then
			cp -r "${scan}/*" "${OUT_PATIENT_DIR}/"
		else
			for file in ${scan}/* ; do
				ln -s "${file}" "${OUT_PATIENT_DIR}/$(basename ${file})"
			done
		fi
		scan_i="$(( scan_i + 1 ))"
	done
done