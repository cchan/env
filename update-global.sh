# Meant more as a collection of update commands rather than an actual script,
# but it's certainly runnable.

echo ====CONDA====
conda update --all

echo ====APT-GET====
sudo apt-get update
sudo apt-get upgrade

echo ====YUM====
sudo yum update # --obsoletes removes obsolete packages too

echo ====GEM====
gem update

echo ====PIP====
pip freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U

echo ====NPM====
npm -g install npm
npm -g update

echo Note that npm (and NodeJS), pip (and Python), gem (and Ruby), etc. may themselves need to be updated.

