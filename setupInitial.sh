
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
    echo "Only EL8+ supported"
    exit 1
  fi
fi

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum install -y terraform
sudo dnf install -y epel-release
sudo dnf install -y ansible
sudo dnf install -y pv
