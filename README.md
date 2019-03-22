## Instalación del entorno (Ubuntu)

### Octave

Ejecutar lo siguiente para instalar octave desde apt:
```
sudo add-apt-repository ppa:octave/stable
sudo apt update
sudo apt install octave
sudo apt install liboctave-dev

```

Para acceder a la interfaz por consola de Octave, correr:
```
octave --no-gui
```

Podemos extender Octave con paquetes extras (https://octave.sourceforge.io/). Para instalar los paquetes utilizados en el TP, ejecutar los siguientes comandos desde la interfaz de Octave:
```
pkg install -forge io
pkg install -forge statistics
pkg install -forge image
```

Luego, crear un archivo *.octaverc* en *$HOME*, con el siguiente contenido:
```
pkg load io
pkg load statistics
pkg load image
```