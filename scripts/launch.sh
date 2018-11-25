#!/bin/bash

cd /root

/usr/lib/rstudio-server/bin/rserver --server-daemonize 0 &

jupyterhub -f /etc/jupyterhub/jupyterhub_config.py

