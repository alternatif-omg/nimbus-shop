#!/usr/bin/env bash
# One-shot setup of a single-node Minikube on an Ubuntu EC2 instance (x86_64, >= 2 vCPU, ~4 GB RAM).
# Installs Docker, kubectl, minikube, clones the repo and applies every manifest EXCEPT secrets.
# Secrets and the GitHub runner token are added by hand afterwards (see the final output).
set -euo pipefail

REPO=https://github.com/alternatif-omg/nimbus-shop
. /etc/os-release
[ "$ID" = ubuntu ] || { echo "Ubuntu only (found: $ID)"; exit 1; }
[ "$(uname -m)" = x86_64 ] || { echo "x86_64 only (found: $(uname -m))"; exit 1; }
[ "$(nproc)" -ge 2 ] || { echo "need >= 2 vCPU (found: $(nproc))"; exit 1; }
MEM_MB=$(free -m | awk '/Mem:/{print $2}')
[ "$MEM_MB" -ge 3500 ] || echo "WARNING: only ${MEM_MB} MB RAM, a t3.medium (4 GB) is recommended"

sudo apt-get update -y
sudo apt-get install -y docker.io git curl conntrack socat
sudo usermod -aG docker "$USER"

cd "$(mktemp -d)"
KVER=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
curl -fsSLO "https://dl.k8s.io/release/${KVER}/bin/linux/amd64/kubectl"
curl -fsSLO "https://dl.k8s.io/release/${KVER}/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -m 0755 kubectl /usr/local/bin/kubectl

curl -fsSLO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
curl -fsSLO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64.sha256
echo "$(cat minikube-linux-amd64.sha256)  minikube-linux-amd64" | sha256sum --check
sudo install -m 0755 minikube-linux-amd64 /usr/local/bin/minikube

# the docker group is not active in this shell yet, so run the docker-dependent steps through sg
sg docker -c "minikube start --driver=docker --cpus=2 --memory=3000"
sg docker -c "minikube addons enable ingress"

[ -d "$HOME/nimbus-shop" ] || git clone "$REPO" "$HOME/nimbus-shop"
cd "$HOME/nimbus-shop"
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/backend -f k8s/frontend
# the ingress admission webhook rejects the Ingress until the controller is ready
kubectl wait -n ingress-nginx --for=condition=ready pod -l app.kubernetes.io/component=controller --timeout=180s
kubectl apply -f k8s/ingress

# shortcut: socat is not restarted after a reboot, rerun this line (or turn it into a systemd unit) then
sudo pkill -f "socat TCP-LISTEN:80" 2>/dev/null || true
sudo nohup socat TCP-LISTEN:80,fork,reuseaddr TCP:"$(sg docker -c 'minikube ip')":80 >/dev/null 2>&1 &

cat <<MSG

Done. Pods wait for the secret, so they show CreateContainerConfigError until you add it:
  1. create ~/nimbus-shop/backend/.env with the 8 variables (nano), then:
       cd ~/nimbus-shop/k8s/secrets && bash generate-secrets.sh
       kubectl apply -f ~/nimbus-shop/k8s/secrets/secrets.yaml
  2. kubectl get pods -n ecommerce
  3. register the GitHub runner (label: minikube) as THIS user, see the GitHub runner page for the commands.
  4. in MongoDB Atlas -> Network Access, allow this server's public IP.
  5. on your PC add "<public-ip> ecommerce.local" to the hosts file, then open http://ecommerce.local
MSG
