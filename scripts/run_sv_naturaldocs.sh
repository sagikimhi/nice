#!/bin/zsh

SCRIPT_NAME=`basename $0`
SCRIPT_ROOT=`dirname $0`

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
PKG_SOURCE="${PKG_ROOT}/src"
PKG_DISTRIB="${PKG_ROOT}/distrib"
PKG_REFERENCE="${PKG_ROOT}/ref"

# NaturalDocs References
NATURAL_DOCS_CFG="${PKG_REFERENCE}/ndconfig"
NATURAL_DOCS_IMAGES="${PKG_REFERENCE}/images"
NATURAL_DOCS_TARPACK="${PKG_REFERENCE}/naturaldocs-sv-modified.tar.gz"

# Distribution directories
DISTRIB_DOCS="${PKG_DISTRIB}/docs"
DISTRIB_SOURCE="${PKG_DISTRIB}/src"
DISTRIB_IMAGES="${PKG_DISTRIB}/images"
DISTRIB_ND_CFG="${PKG_DISTRIB}/ndconfig"
DISTRIB_HTML_DOCS="${DISTRIB_DOCS}/html"

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

function clean_distrib {
    if [[ -d ${PKG_DISTRIB} ]]; then
        rm -rf ${PKG_DISTRIB}
    fi

    mkdir -p ${DISTRIB_ND_CFG}
}

function populate_distrib {
    cp -r ${PKG_SOURCE} ${DISTRIB_SOURCE}
    cp -r ${PKG_ROOT}/Dockerfile ${PKG_DISTRIB}/Dockerfile
    cp -r ${NATURAL_DOCS_CFG}/PKG_Topics.txt ${DISTRIB_ND_CFG}/Topics.txt
    cp -r ${NATURAL_DOCS_CFG}/PKG_Project.txt ${DISTRIB_ND_CFG}/Project.txt
    cp -r ${NATURAL_DOCS_CFG}/PKG_Languages.txt ${DISTRIB_ND_CFG}/Languages.txt
    tar -xzf ${NATURAL_DOCS_TARPACK} --one-top-level=${PKG_DISTRIB}
}

function build_docs_with_docker {
    docker build -t ${PKG_NAME}_docs ${PKG_DISTRIB}

    docker run --name build_${PKG_NAME}_docs -it ${PKG_NAME}_docs

    docker cp build_${PKG_NAME}_docs:/docs ${PKG_DISTRIB}/docs

    docker rm build_${PKG_NAME}_docs

    docker image rm ${PKG_NAME}_docs
}

function main {
    print_info

    clean_distrib

    populate_distrib

    build_docs_with_docker
}

main
