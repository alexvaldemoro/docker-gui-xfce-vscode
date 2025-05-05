# Entorno Docker con GUI XFCE, VSCode, Python y SSH  
**Despliegue de un entorno gráfico en contenedores Docker para desarrollo**

## 🛠️ Requisitos previos
- Docker instalado ([instrucciones oficiales](https://docs.docker.com/get-docker/))
- Cliente VNC ([Remmina](https://remmina.org/) recomendado)
- 4 GB de RAM mínimo recomendado

---

## 🚀 Instrucciones paso a paso

### 1. Clonar el repositorio
```
git clone https://github.com/tu-usuario/docker-gui-xfce-vscode.git
cd docker-gui-xfce-vscode
```

### 2. Construir la imagen Docker
```
sudo docker build -t ubuntu-gui .
```

### 3. Ejecutar el contenedor
```
sudo docker run -d -p 5901:5901 -p 2222:22 --name gui-container ubuntu-gui
```

---

## 🌐 Conexión VNC
| Parámetro       | Valor                 |
|-----------------|-----------------------|
| **Dirección**   | `localhost:5901`      |
| **Contraseña**  | `password` (defecto)  |

---

## 🖥️ Uso de VSCode en el contenedor
1. Conéctate via VNC.
2. Abre una terminal en XFCE.
3. Ejecuta:
```
code /development --user-data-dir='.' --no-sandbox
```

---

## 🛠️ Personalización
### Cambiar contraseña VNC/SSH
Edita estas líneas en el `Dockerfile`:
```dockerfile
# Contraseña VNC
RUN echo "nueva-pass" | vncpasswd -f > /root/.vnc/passwd

# Contraseña SSH
RUN echo "root:nueva-pass" | chpasswd
```

---

## 📜 Licencia
Ninguna
