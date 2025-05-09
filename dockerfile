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

# Instalar VSCode (forzar 'y' en la pregunta de WSL)
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/ && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list && \
    apt-get update && \
    # Forzar 'y' con yes y redirección de entrada
    yes 'y' | apt-get install -y code && \
    # Instalar extensión Python
    yes 'y' | su - devuser -c "code --install-extension ms-python.python --user-data-dir=/home/devuser/.vscode"

# Configurar VNC para devuser
USER devuser
RUN echo "password" | vncpasswd -f > /home/devuser/.vnc/passwd && \
    chmod 600 /home/devuser/.vnc/passwd && \
    echo '#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec startxfce4' > /home/devuser/.vnc/xstartup && \
    chmod +x /home/devuser/.vnc/xstartup



# Crear script en el escritorio de devuser
RUN mkdir -p /home/devuser/Desktop && \
    echo -e "#!/bin/sh\nyes 'y' | code --user-data-dir=\"/home/devuser/.vscode\" --no-sandbox" > /home/devuser/Desktop/vscode.sh && \
    chmod +x /home/devuser/Desktop/vscode.sh && \
    chown -R devuser:devuser /home/devuser/Desktop

# Configuración final
USER root
RUN chown -R devuser:devuser /home/devuser && \
    update-desktop-database && \
    ssh-keygen -A


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
