PATT=${1-ipdb}
echo ${PATT} 1>&2
ag -l ipdb | xargs -n 1 gsed --in-place '/'${PATT}'/d'
