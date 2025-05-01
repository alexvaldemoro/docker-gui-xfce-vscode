# Usar Ubuntu 24.04 como base
FROM ubuntu:24.04

# Evitar prompts interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV HOME=/root

# Instalar dependencias básicas + XFCE + VNC + SSH + Python
RUN apt-get update && \
    apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    openssh-server \
    python3 \
    python3-pip \
    wget \
    curl \
    git \
    nano \
    dbus-x11 \
    x11-utils \
    x11-xserver-utils \
    xdg-utils \
    xauth \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instalar Visual Studio Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list && \
    apt-get update && \
    apt-get install -y code

# Configurar VNC (contraseña: "password")
RUN mkdir -p /root/.vnc && \
    echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Configurar xstartup para XFCE
RUN echo '#!/bin/sh \n\
unset SESSION_MANAGER \n\
unset DBUS_SESSION_BUS_ADDRESS \n\
exec startxfce4' > /root/.vnc/xstartup && \
    chmod 755 /root/.vnc/xstartup

# Asegurar permisos y variables
RUN chmod 700 /root/.vnc && \
    touch /root/.Xauthority && \
    chmod 600 /root/.Xauthority

# Configurar SSH (usuario: root, contraseña: "password")
RUN echo "root:password" | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Exponer puertos
EXPOSE 5901 22 3000

# Script para iniciar servicios (VNC + SSH)
COPY start-vnc.sh /start-vnc.sh
RUN chmod +x /start-vnc.sh

# Comando de inicio
CMD ["/start-vnc.sh"]
