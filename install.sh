#!/bin/bash
for file in base/secrets/*.env.example; do
    env_file="${file%.example}"
    if [ ! -f "$env_file" ]; then
        cp "$file" "$env_file"
    fi
done

for file in overlays/dev/secrets/*.env.example; do
    env_file="${file%.example}"
    if [ ! -f "$env_file" ]; then
        cp "$file" "$env_file"
    fi
done


for file in base/properties/*.env.example; do
    env_file="${file%.example}"
    if [ ! -f "$env_file" ]; then
        cp "$file" "$env_file"
    fi
done


# Replace $(RAND32) with a random base64 encoded string in all non-example env files
for env_file in base/secrets/*.env; do
    if [[ -f "$env_file" && ! "$env_file" == *.example ]]; then
        # Generate a random base64 encoded string
        random_string=$(openssl rand -base64 32)
        
        sed -i '' "s|\$(RAND32)|$random_string|g" "$env_file"
    fi
done


echo "Setup FileSystem"
mkdir -p /opt/5stack/dev
mkdir -p /opt/5stack/demos
mkdir -p /opt/5stack/steamcmd
mkdir -p /opt/5stack/serverfiles
mkdir -p /opt/5stack/postgres
mkdir -p /opt/5stack/typesense
mkdir -p /opt/5stack/minio



echo "Environment files setup complete"

echo "Installing Kustomize ..."
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

echo "Installing k3s ..."
curl -sfL https://get.k3s.io | sh -s - --disable=traefik 

kubectl -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml

echo "Updating Node to host services"
kubectl label node $(kubectl get nodes -o jsonpath='{.items[0].metadata.name}') 5stack-services=true


echo "Updating 5stack ..."
./update.sh

