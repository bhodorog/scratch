# has a hard dependency on jq (osx: brew install jq, debian based: apt-get install jq)
function instancely () {
    if [ -z $1 ]; then
        echo "instancely project_name [cluster_name] [environment_name]"
        echo "    project_name matches one of 'DV_OMG', etc."
        echo "    cluster_name matches the blue value in instancely e.g. 'bigbang-v2', 'dashboard', etc."
        echo "    environment_name matches one of 'Production', 'Staging', etc."
        return
    fi
    PROJECT_MATCH=${1:-.*}
    APP=${2:-.*}
    ENVIRONMENT=${3:-.*}
    PRJ_URL="http://instancely.fairfaxmedia.com.au/api/ec2/project"
    PROJECT=$(curl ${PRJ_URL} 2>/dev/null | jq -r -C '.data[] | select(test("'${PROJECT_MATCH}'"; "i"))')
    INST_URL="http://instancely.fairfaxmedia.com.au/api/ec2/instance?project=${PROJECT}&group_by=cluster"
    curl "$INST_URL" 2>/dev/null | jq -r -C '.data[] | select(.role | test("'$APP'"; "i")) | .data.tags | select(."aws:cloudformation:stack-name" | test("'$ENVIRONMENT'"; "i")) | ."aws:cloudformation:stack-name", .Name'
}
