#!/bin/bash

while [[ $# -gt 0 ]]; do
    case $1 in
        --kubeconfig)
            KUBECONFIG="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [ -z "$KUBECONFIG" ]; then
    KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
fi

kubectl --kubeconfig=$KUBECONFIG apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.yaml

