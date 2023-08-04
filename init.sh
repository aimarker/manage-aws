#!/bin/bash
echo "Updating the Ubuntu packages"
sudo apt-get update -y
echo "Ubuntu package update complete"
echo "Creating actions-runner directory"
su ubuntu -c 'mkdir $HOME/actions-runner && cd $HOME/actions-runner'
echo "Downloading actions-runner packages"
su ubuntu -c 'curl -o $HOME/actions-runner/actions-runner-linux-x64-2.306.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.306.0/actions-runner-linux-x64-2.306.0.tar.gz'
echo "Extracting actions-runner tar file"
su ubuntu -c 'cd $HOME/actions-runner && tar xzf ./actions-runner-linux-x64-2.306.0.tar.gz'
echo "Configuring action-runner to GitHub"
su ubuntu -c 'cd $HOME/actions-runner && ./config.sh --unattended --url https://github.com/aimarker/MLOPs_AI --token ABD2MRUFJXEOHHQ64ZKEG3DEV4E6M'
echo "Downloading and configuring docker"
echo "Step 1/5 : Installing dependencies"
sudo apt-get update && sudo apt-get --assume-yes install ca-certificates curl gnupg
echo "Step 2/5 : Add Docker's official GPG key"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "Step 3/5 : Setting up the repository"
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "Step 4/5 : Installing Docker engine"
sudo apt-get update && sudo apt-get --assume-yes install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker ubuntu
echo "Step 5/5 : Login to docker hub"
docker login --username="dockatdocker" --password="infaAS@2019"
su ubuntu -c 'cd $HOME/actions-runner && ./run.sh &'