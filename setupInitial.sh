
set -x

os=`uname -s`
if [ "$os" == "Darwin" ]; then
  brew install terraform
  brew install ansible
  brew install pv
  exit $?
else
  yum --version > /dev/null 2>&1
  rc=$?
  if [ ! "$rc" == "0" ]; then
    echo "Only EL8+ ARM64 supported"
    exit 1
  fi
  if [ ! `arch` == "aarch64" ]; then
    echo "Only EL8+ ARM64 supported"
    exit 1
  fi
fi

sudo dnf install -y wget zip

rm terraform*
zip_file=terraform_1.3.5_linux_arm64.zip
wget https://releases.hashicorp.com/terraform/1.3.5/$zip_file
unzip $zip_file
sudo mv terraform /usr/local/bin/.
sudo chmod 755 /usr/local/bin/terraform 
rm $zip_file

sudo dnf install -y epel-release
sudo dnf install -y ansible
sudo dnf install -y pv
