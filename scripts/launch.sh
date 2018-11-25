#!/bin/bash

cd /root
jupyterhub -f /etc/jupyterhub/jupyterhub_config.py

/usr/lib/rstudio-server/bin/rserver --server-daemonize 0 &
