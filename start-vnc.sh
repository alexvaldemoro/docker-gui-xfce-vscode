#!/bin/bash
# Iniciar servidor VNC
vncserver :1 -geometry 1280x800 -depth 24 && \
# Iniciar SSH
service ssh start && \
# Mantener el contenedor en ejecución
tail -f /dev/null
