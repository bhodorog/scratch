# set your MCHOST before sourcing
MC_HOST=${MCHOST:-"localhost"}
PLATFORM=$(uname)
[[ $PLATFORM == 'Darwin' ]] && alias _grep=ggrep || alias _grep=grep

function mcd_cmd () { echo "$1" | nc $MC_HOST 11211; };

function mcd_get () { echo "get $1" | nc $MC_HOST 11211; };

function mcd_items () { echo "stats $1" | nc $MC_HOST 11211 | _grep -Po "(?<=items:)[0-9]{1,2}" | sort -n | uniq; };

function mcd_stats () { echo "stats ${1-}" | nc $MC_HOST 11211; };

function mcd_cdump () { echo "stats cachedump $1 100" | nc $MC_HOST 11211; };

function mcd_keys () {
    for ITEM in $(mcd_items "items"); do
        echo "$(mcd_cdump $ITEM)" | _grep ITEM | sed s/^/"$ITEM - "/;
    done
}

function mcd_time () {
    PATT="STAT time "
    RET=$(mcd_stats | _grep -Po "(?<=$PATT).*")
    echo $RET
}


function mcd_key_expiry () {
    KEY=${1:-}
    ITEM=$(mcd_keys | _grep $KEY)
    EXPIRY=$(echo $ITEM | _grep -Po "(?<=b; )[0-9]+(?= s])")
    echo $EXPIRY
}

function pp_time () {
    ruby -e "p Time.at($1)"
}

function mcd_watch () {
    echo 'watch '\''(source ~/1/repos/ffx/omg/memcached.sh; echo "key    "$(pp_time $(mcd_key_expiry "bogdan")); echo "server "$(pp_time $(mcd_time)))'\'
}
