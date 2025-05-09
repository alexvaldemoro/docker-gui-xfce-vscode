# Entorno Docker con GUI XFCE, VSCode y SSH

## ❌ Problemas WSL

si experimentas problemas a la hora de correr el dockerfile desde Windows WSL teniendo instalado VScode en tu maquina usa una maquina virtual, o desinstala el VScode de la maquina host.
(Se han aplicado cambios para que esto no suceda, y aunque tengas VScode instalado en el host y ejecutes este dockerfile a traves de ubuntu WSL desde windows deberia funcionar)

Entorno de desarrollo gráfico en contenedor Docker con:
- Escritorio XFCE
- Visual Studio Code
- Python 3
- Servidor VNC (acceso gráfico)
- Servidor SSH

## 🛠 Requisitos
- Docker instalado
- Cliente VNC (Recomendado: [Remmina](https://remmina.org/))
- 2 GB de RAM mínimo

## 🚀 Instrucciones rápidas

### 1. Clonar repositorio
```bash
git clone https://github.com/alexvaldemoro/docker-gui-xfce-vscode.git
cd docker-gui-xfce-vscode
```

### 2. Construir imagen Docker
```bash
sudo docker build -t ubuntu-gui .
```

### 3. Ejecutar contenedor
```bash
sudo docker run -d -p 5901:5901 -p 2222:22 --name gui-container ubuntu-gui
```

## 🌐 Conexión VNC
| Parámetro       | Valor           |
|-----------------|-----------------|
| **Dirección**   | `localhost:5901`|
| **Contraseña**  | `password`      |

## 🔑 Conexión SSH
```bash
ssh devuser@localhost -p 2222
# Contraseña: password
```

## 👨💻 Usar Visual Studio Code
1. Desde el escritorio XFCE:
   - Doble clic en el icono **vscode.sh**
   - O en terminal:
   ```bash
   yes 'y' | code --user-data-dir='/home/devuser/.vscode' --no-sandbox
   ```

## 🛠 Troubleshooting

### 🖥 VNC no conecta
1. Verificar logs del contenedor:
```bash
docker logs gui-container
```

### 🔌 Puertos bloqueados
```bash
sudo lsof -ti:5901 | xargs kill -9
```

## 📂 Estructura del proyecto
```
docker-xfce-vscode/
├── Dockerfile
├── start-vnc.sh
└── README.md
```

## 📜 Licencia
MIT License - Uso educativo/no productivo.

