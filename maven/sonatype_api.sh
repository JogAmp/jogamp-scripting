#!/bin/sh

sdir_0=`dirname $0`
sdir=`readlink -f $sdir_0`
. $sdir/sonatype_api_token.txt

# set -x

sonatype_search_repos() {
    curl -u ${api_user}:${api_password} --anyauth --request GET \
        --header "accept: application/json" \
        "https://ossrh-staging-api.central.sonatype.com/manual/search/repositories?ip=any"
    return $?
}
sonatype_set_default_repo() {
    curl -u ${api_user}:${api_password} --anyauth --request POST \
        --header 'accept: */*' \
        -d '' \
        "https://ossrh-staging-api.central.sonatype.com/manual/upload/defaultRepository/org.jogamp?publishing_type=automatic"
    return $?
}
sonatype_upload_staging() {
    repository_key=$1
    if [ -z "${repository_key}" ] ; then
        echo "repository_key is empty"
        exit 1
    fi
    curl -u ${api_user}:${api_password} --anyauth --request POST \
        --header 'accept: */*' \
        -d '' \
        "https://ossrh-staging-api.central.sonatype.com/manual/upload/repository/${repository_key}?publishing_type=automatic"
    return $?
}
sonatype_drop_staging() {
    repository_key=$1
    if [ -z "${repository_key}" ] ; then
        echo "repository_key is empty"
        exit 1
    fi
    curl -u ${api_user}:${api_password} --anyauth --request DELETE \
        --header 'accept: */*' \
        "https://ossrh-staging-api.central.sonatype.com/manual/drop/repository/${repository_key}"
    return $?
}

# sonatype_search_repos
# sonatype_set_default_repo
# sonatype_upload_staging "${api_repository_key}" 
# sonatype_drop_staging "${api_repository_key}"
# sonatype_set_default_repo
# sonatype_search_repos
