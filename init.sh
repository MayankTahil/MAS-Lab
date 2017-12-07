# Persistent Data Directories
export ROOT_DIR="/MAS-Lab"
export DATA_DIR="$ROOT_DIR/Data"
export CLOUD_DRIVE="$ROOT_DIR/Cloud-data"
export GUAC_DATA="$ROOT_DIR/Guac-data"
export GIT_DATA="$ROOT_DIR/Git-data"
export RANCHER_DATA="$ROOT_DIR/Rancher-data"
export REGISTRY_DATA="$ROOT_DIR/Registry-data"

# Initialized Config Files
export KUBE_CONFIG="$ROOT_DIR/config"

mkdir -p $ROOT_DIR
mkdir -p $DATA_DIR
mkdir -p $CLOUD_DRIVE
mkdir -p $GUAC_DATA
mkdir -p $GIT_DATA
mkdir -p $RANCHER_DATA
mkdir -p $REGISTRY_DATA
touch $KUBE_CONFIG

apt-get -y update
apt-get -y upgrade
apt-get -y install git nano

# Check and Install Docker
if hash docker 2>/dev/null; then
		echo "Docker already installed. Skipping script"
    else
        echo "Installing Docker"
        curl -s -k https://raw.githubusercontent.com/Citrix-TechSpecialist/scripts/master/install-docker.sh | bash
    fi

# Remove all containers, images, and clean up host
docker rm -f $(docker ps -aq)
docker rmi -f $(docker images)
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc:ro spotify/docker-gc

# Add insecure registry
echo '{
"insecure-registries":["registry.workspacelab.com:5000"],
"experimental": true
}' > /etc/docker/daemon.json

service docker restart 

# Initiate Services Stack
docker-compose up -d 
