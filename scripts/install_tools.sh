#!/usr/bin/env bash

KUBECONFORM_VERSION=${KUBECONFORM_VERSION:-latest}
KUSTOMIZE_VERSION=${KUSTOMIZE_VERSION:-latest}
YQ_VERSION=${YQ_VERSION:-latest}

echo Version Input:
echo
echo KUBECONFORM_VERSION: $KUBECONFORM_VERSION
echo KUSTOMIZE_VERSION: $KUSTOMIZE_VERSION
echo YQ_VERSION: $YQ_VERSION

if [ "$KUBECONFORM_VERSION" == "latest" ]; then
    KUBECONFORM_VERSION=$(
        curl -sL https://api.github.com/repos/yannh/kubeconform/releases/latest |\
        jq -r .tag_name 
    )
fi

if [ "$KUSTOMIZE_VERSION" == "latest" ]; then
    KUSTOMIZE_VERSION=$(
        curl -sL https://api.github.com/repos/kubernetes-sigs/kustomize/releases |\
        jq --sort-keys -r '.[]|.tag_name|select(.|test("^kustomize"))|sub("^kustomize/";"")' |\
        head -n 1
        )
fi

if [ "$YQ_VERSION" == "latest" ]; then
    YQ_VERSION=$(
        curl -sL https://api.github.com/repos/mikefarah/yq/releases/latest |\
        jq -r .tag_name
    )
fi
echo
echo
echo Versions to Install:
echo
echo KUBECONFORM_VERSION: $KUBECONFORM_VERSION
echo KUSTOMIZE_VERSION: $KUSTOMIZE_VERSION
echo YQ_VERSION: $YQ_VERSION

GITHUB_WORKSPACE=${GITHUB_WORKSPACE:-$(pwd)}
GITHUB_PATH=${GITHUB_PATH:-${GITHUB_WORKSPACE}/.github_path}

TOOLS_INSTALLDIR="${GITHUB_WORKSPACE}/.checktools"
TOOLS_BINDIR="${TOOLS_INSTALLDIR}/bin"

mkdir -p "${TOOLS_INSTALLDIR}"
mkdir -p "${TOOLS_BINDIR}"

echo "Install kubeconform ${KUBECONFORM_VERSION}"
curl -L "https://github.com/yannh/kubeconform/releases/download/${KUBECONFORM_VERSION}/kubeconform-linux-amd64.tar.gz" | tar xz -C "${TOOLS_BINDIR}" kubeconform

echo "Install kustomize ${KUSTOMIZE_VERSION}"
curl -L "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" | tar xz -C "${TOOLS_BINDIR}" kustomize

echo "Install yq ${YQ_VERSION}"
curl -o "${TOOLS_BINDIR}/yq" -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" && chmod 755 ${TOOLS_BINDIR}/yq


echo "${TOOLS_BINDIR}" >> "${GITHUB_PATH}"