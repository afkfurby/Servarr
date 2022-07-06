# based on https://leandeep.com/install-jupyter-lab-on-ubuntu-18.04/

sudo apt-get update
sudo apt-get install -y curl
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# install node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion



# nvm ls-remote
# Determine the latest LTS. For me it is v10.16.0 when I am writing this tutorial
nvm install v14.19.3 && nvm use default v14.19.3

# install python modules
sudo apt-get install python3 python3-pip python3-virtualenv

adduser jupyterlab

cd /home/jupyterlab/
python3 -m virtualenv ./venv

pip3 install jupyterlab

jupyter labextension install @jupyterlab/hub-extension
jupyter lab build


jupyter-lab --generate-config

mkdir -p /home/$USER/dev/jupyterlab
export WorkingDirectory=/home/$USER/dev/jupyterlab

cat << EOF | sudo tee /etc/systemd/system/jupyter-lab.service
[Unit]
Description=Jupyter Lab
[Service]
Type=simple
PIDFile=/run/jupyter.pid
ExecStart=/home/$USER/venv/bin/jupyter-lab --config=/home/$USER/.jupyter/jupyter_notebook_config.py
WorkingDirectory=$WorkingDirectory
User=$USER
Group=$USER
Restart=always
RestartSec=10
#KillMode=mixed
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable jupyter-lab.service



# Incoming connection whitelist. tried with IP & CIDR. not sure about ranges. should be comma separated if more than one.
sed -i.back "s/#c.NotebookApp.allow_origin = ''/c.NotebookApp.allow_origin = '10.1.0.0\/24'/" ~/.jupyter/jupyter_lab_config.py

# Jupyter listening IP. Set to localhost if only planning on using locally.
sed -i "s/#c.NotebookApp.ip = '0.0.0.0'/c.NotebookApp.ip = '0.0.0.0'/" ~/.jupyter/jupyter_lab_config.py

# Whether or not to open browser on jupyter launch. If headless, or server, set to False.
sed -i "s/#c.NotebookApp.open_browser = True/c.NotebookApp.open_browser = False/" ~/.jupyter/jupyter_lab_config.py

# Listening port. Change if necessary
sed -i "s/#c.NotebookApp.port = 8000/c.NotebookApp.port = 8000/" ~/.jupyter/jupyter_lab_config.py

# Randomly generated token for access without user/pass
sed -i "s/^#c.NotebookApp.token .*/c.NotebookApp.token = '$token'/" ~/.jupyter/jupyter_lab_config.py

# Trash Cleanup
sed -i "s/#c.NotebookApp.cookie_secret = b''/#c.NotebookApp.cookie_secret = ''/" ~/.jupyter/jupyter_lab_config.py
sed -i "s/#c.Session.key = b''/#c.Session.key = ''/" ~/.jupyter/jupyter_lab_config.py
sed -i "s/#c.NotebookNotary.secret = b''/#c.NotebookNotary.secret = ''/" ~/.jupyter/jupyter_lab_config.py


