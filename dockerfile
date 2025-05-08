# Usar Ubuntu 24.04 como base
FROM ubuntu:24.04

# Configurar entorno para evitar prompts interactivos
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias principales + XFCE + VNC + SSH + Python
RUN apt-get update && \
    apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    openssh-server \
    python3 \
    python3-pip \
    wget \
    git \
    nano \
    xauth \
    xfonts-base \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-cyrillic \
    dbus-x11 \
    desktop-file-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario no-root (devuser)
RUN useradd -m -s /bin/bash devuser && \
    echo "devuser:password" | chpasswd && \
    mkdir -p /home/devuser/.vnc && \
    chown -R devuser:devuser /home/devuser

# Instalar Visual Studio Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/ && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list && \
    apt-get update && \
    apt-get install -y code


# Configurar VNC para devuser
USER devuser
RUN echo "password" | vncpasswd -f > /home/devuser/.vnc/passwd && \
    chmod 600 /home/devuser/.vnc/passwd && \
    echo '#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec startxfce4' > /home/devuser/.vnc/xstartup && \
    chmod +x /home/devuser/.vnc/xstartup

# Crear acceso directo en el escritorio para VSCode
RUN mkdir -p /home/devuser/Desktop && \
    echo '[Desktop Entry]\n\
    Version=1.0\n\
    Name=Visual Studio Code\n\
    Comment=Code Editing. Redefined.\n\
    Exec=code --user-data-dir="/home/devuser/.vscode" --no-sandbox\n\
    Icon=/usr/share/icons/hicolor/256x256/apps/code.png\n\
    Terminal=false\n\
    Type=Application\n\
    Categories=Development;IDE;\n' > /home/devuser/Desktop/vscode.desktop && \
    chmod +x /home/devuser/Desktop/vscode.desktop

# Configuración final
USER root
RUN chown -R devuser:devuser /home/devuser && \
    update-desktop-database && \
    ssh-keygen -A

# Instalar VSCode y extensión de Python
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/ && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list && \
    apt-get update && \
    apt-get install -y code && \
    # Instalar extensión Python como usuario devuser
    su - devuser -c "code --install-extension ms-python.python --user-data-dir=/home/devuser/.vscode"


# Configurar SSH
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Script de inicio
COPY start-vnc.sh /start-vnc.sh
RUN chmod +x /start-vnc.sh

# Exponer puertos
EXPOSE 5901 22

# Comando de inicio
CMD ["/start-vnc.sh"]
