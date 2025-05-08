#!/bin/bash
# Iniciar VNC como devuser
su - devuser -c "vncserver :1 -geometry 1280x800 -depth 24" \
# Iniciar SSH
service ssh start && \
# Mantener el contenedor en ejecución
tail -f /dev/null
