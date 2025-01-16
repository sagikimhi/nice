#!/bin/bash

SCRIPT_NAME=`basename -s .sh $0`
SCRIPT_ROOT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
SCRIPT_LOG="${SCRIPT_ROOT}/../${SCRIPT_NAME}.log"

if [[ $# -lt 1 ]]; then
    echo ""
    echo "Usage:"
    echo "------"
    echo "${SCRIPT_NAME} <pkg_name>"
    echo ""
    echo "Options:"
    echo "--------"
    echo "-h -help --help   print this help menu and exit."
    echo ""
    exit
fi

# Package
PKG_NAME="$1"
PKG_ROOT="${SCRIPT_ROOT}/.."
PKG_DOCS="${PKG_ROOT}/docs"
PKG_SOURCE="${PKG_ROOT}/src/sv/nice_pkg"
PKG_DISTRIB="${PKG_ROOT}/distrib"
PKG_REFERENCE="${PKG_ROOT}/ref"

# NaturalDocs References
NATURAL_DOCS_CFG="${PKG_REFERENCE}/ndconfig"
NATURAL_DOCS_IMAGES="${PKG_REFERENCE}/images"
NATURAL_DOCS_TARPACK="${PKG_REFERENCE}/naturaldocs-sv-modified.tar.gz"
NATURAL_DOCS_DOCKERFILE="${PKG_REFERENCE}/Dockerfile"
NATURAL_DOCS_TOPICS_CFG="${NATURAL_DOCS_CFG}/PKG_Topics.txt"
NATURAL_DOCS_PROJECT_CFG="${NATURAL_DOCS_CFG}/PKG_Project.txt"
NATURAL_DOCS_LANGUAGES_CFG="${NATURAL_DOCS_CFG}/PKG_Languages.txt"

# Distributed directories
DISTRIB_DOCS="${PKG_DISTRIB}/docs"
DISTRIB_ND_CFG="${PKG_DISTRIB}/ndconfig"
DISTRIB_SOURCE="${PKG_DISTRIB}/src"
DISTRIB_IMAGES="${PKG_DISTRIB}/images"
DISTRIB_DOCKERFILE="${PKG_DISTRIB}/Dockerfile"

# Distributed docs directories
DISTRIB_HTML_DOCS="${DISTRIB_DOCS}/html"

DISTRIB_ND_TOPICS="${DISTRIB_ND_CFG}/Topics.txt"
DISTRIB_ND_PROJECT="${DISTRIB_ND_CFG}/Project.txt"
DISTRIB_ND_LANGUAGES="${DISTRIB_ND_CFG}/Languages.txt"

DOCKER_IMAGE_NAME="make_${PKG_NAME}_docs"
DOCKER_BUILD_NAME="make_${PKG_NAME}_docs"

function print_info {
    echo ""
    echo "Script"
    echo "------"
    echo "SCRIPT_NAME=${SCRIPT_NAME}"
    echo "SCRIPT_ROOT=${SCRIPT_ROOT}"
    echo ""
    echo ""
    echo "Package"
    echo "-------"
    echo "PKG_NAME=${PKG_NAME}"
    echo "PKG_ROOT=${PKG_ROOT}"
    echo "PKG_SOURCE=${PKG_SOURCE}"
    echo "PKG_DISTRIB=${PKG_DISTRIB}"
    echo "PKG_REFERENCE=${PKG_REFERENCE}"
    echo ""
    echo ""
    echo "NaturalDocs References"
    echo "----------------------"
    echo "NATURAL_DOCS_CFG=${NATURAL_DOCS_CFG}"
    echo "NATURAL_DOCS_IMAGES=${NATURAL_DOCS_IMAGES}"
    echo "NATURAL_DOCS_TARPACK=${NATURAL_DOCS_TARPACK}"
    echo ""
    echo ""
    echo "Distribution Directories"
    echo "------------------------"
    echo "DISTRIB_DOCS=${DISTRIB_DOCS}"
    echo "DISTRIB_SOURCE=${DISTRIB_SOURCE}"
    echo "DISTRIB_IMAGES=${DISTRIB_IMAGES}"
    echo "DISTRIB_ND_CFG=${DISTRIB_ND_CFG}"
    echo "DISTRIB_HTML_DOCS=${DISTRIB_HTML_DOCS}"
}

function directory_exists {
    if [[ -d "$1" ]]; then
        return 0
    else
        return 1
    fi
}

function prepare {
    echo "Preparing temporary work directory..."
    if directory_exists ${PKG_DOCS}; then
        rm -rf ${PKG_DOCS} 1>> ${SCRIPT_LOG}
    fi
    mkdir -p ${DISTRIB_ND_CFG} 1>> ${SCRIPT_LOG}
}

function populate {
    echo "Populating work directory with necessary assets..."
    cp -r ${PKG_SOURCE} ${DISTRIB_SOURCE}
    cp -r ${NATURAL_DOCS_TOPICS_CFG} ${DISTRIB_ND_TOPICS}
    cp -r ${NATURAL_DOCS_PROJECT_CFG} ${DISTRIB_ND_PROJECT}
    cp -r ${NATURAL_DOCS_LANGUAGES_CFG} ${DISTRIB_ND_LANGUAGES}
    cp -r ${NATURAL_DOCS_DOCKERFILE} ${DISTRIB_DOCKERFILE}
    tar -xf ${NATURAL_DOCS_TARPACK} --one-top-level=${PKG_DISTRIB}
}

function build_container {
    echo "Building documentation builder docker container..."
    docker build -t ${DOCKER_BUILD_NAME} ${PKG_DISTRIB}
}

function run_container {
    echo "Building documentation in docker container..."
    docker run --name ${DOCKER_BUILD_NAME} -it ${DOCKER_IMAGE_NAME}
}

function extract_docs {
    echo "Extracting documentation from docker container..."
    docker cp ${DOCKER_IMAGE_NAME}:/docs ${PKG_DOCS}
    chmod -R 777 ${PKG_DOCS}
}

function clean_up {
    echo "Cleaning up leftovers..."
    if directory_exists ${PKG_DISTRIB}; then
        rm -rf ${PKG_DISTRIB}
    fi
    docker rm ${DOCKER_BUILD_NAME}
    docker image rm ${DOCKER_IMAGE_NAME}
}

function finish {
    echo "Done."
    echo "Documentation written to ${PKG_DOCS}."
}

function main {
    print_info
    prepare
    populate
    build_container
    run_container
    extract_docs
    clean_up
    finish
}

main | tee ${SCRIPT_LOG}
