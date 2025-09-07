#!/bin/sh

sdir_0=`dirname $0`
sdir=`readlink -f $sdir_0`

# Using variables: api_user, api_password, repository_key
if [ -e $sdir/sonatype_api_token.txt ] ; then
    . $sdir/sonatype_api_token.txt
fi

# set -x

CURL_OPTS="--silent --fail-with-body --show-error"

handle_result() {
    err=$1
    res="$2"
    if [ ${err} -eq 0 ] ; then
        echo "${res}" | grep -e '^{\"error\":' 2>&1 > /dev/null && err=1
    fi
    if [ ${err} -eq 0 ] ; then
        echo "reply: OK: ${res}"
    else
        echo "reply: ERROR: ${res}"
    fi
    return ${err}
}

sonatype_search_repos() {
    res=`curl ${CURL_OPTS} -u ${api_user}:${api_password} --anyauth --request GET \
        --header "accept: application/json" \
        "https://ossrh-staging-api.central.sonatype.com/manual/search/repositories?ip=any"`
    handle_result $? "${res}"
    return $?
}
sonatype_set_default_repo() {
    res=`curl ${CURL_OPTS} -u ${api_user}:${api_password} --anyauth --request POST \
        --header 'accept: */*' \
        -d '' \
        "https://ossrh-staging-api.central.sonatype.com/manual/upload/defaultRepository/org.jogamp?publishing_type=automatic"`
    handle_result $? "${res}"
    return $?
}
sonatype_upload_staging() {
    repository_key=$1
    if [ -z "${repository_key}" ] ; then
        echo "repository_key is empty"
        exit 1
    fi
    res=`curl ${CURL_OPTS} -u ${api_user}:${api_password} --anyauth --request POST \
        --header 'accept: */*' \
        -d '' \
        "https://ossrh-staging-api.central.sonatype.com/manual/upload/repository/${repository_key}?publishing_type=automatic"`
    handle_result $? "${res}"
    return $?
}
sonatype_drop_staging() {
    repository_key=$1
    if [ -z "${repository_key}" ] ; then
        echo "repository_key is empty"
        exit 1
    fi
    res=`curl ${CURL_OPTS} -u ${api_user}:${api_password} --anyauth --request DELETE \
        --header 'accept: */*' \
        "https://ossrh-staging-api.central.sonatype.com/manual/drop/repository/${repository_key}"`
    handle_result $? "${res}"
    return $?
}

# sonatype_search_repos
# sonatype_set_default_repo
# sonatype_upload_staging "${api_repository_key}" 
# sonatype_drop_staging "${api_repository_key}"
# sonatype_set_default_repo
# sonatype_search_repos
