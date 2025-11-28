---

# Born2BeRoot – 42 Madrid | Fundación Telefónica

Born2BeRoot es un proyecto de administración de sistemas dentro del cursus de 42 Network. Consiste en configurar un servidor Linux desde una instalación mínima y sin interfaz gráfica, incluyendo particionado con LVM, políticas de contraseñas, seguridad, gestión de usuarios y grupos, configuración de sudo, UFW, SSH y un script de monitorización periódica del sistema.

Este repositorio contiene **mi script `monitoring.sh`** y apuntes esenciales que pueden ayudar a preparar la evaluación de dicho proyecto si vas a realizarlo o te encuentras en ello.

---

## Contenido del repositorio

* `monitoring.sh` → Script que muestra estadísticas del sistema mediante `cron` y `wall`.
* Guía teórica de evaluación.
* Resumen de configuraciones clave (SSH, UFW, sudo, particiones, LVM…).
* Notas rápidas para las comprobaciones de la defensa.

---

## Firma de la máquina virtual

La firma del archivo `.vdi` debe coincidir con la de tu VM el día de la evaluación.
Al finalizar el proyecto debes subir a la intranet un archivo llamado **Signature.txt** que contenga únicamente la firma de tu máquina virtual.

Para obtenerla, sitúate en la ruta donde se encuentra el `.vdi` y ejecuta:

```bash
sha1sum nombreMaquinaVirtualBox.vdi
```

El hash resultante es el que debes copiar en **Signature.txt**.
Desde ese momento **no debes modificar la VM**, porque la firma cambiaría y no coincidiría con la del repositorio. Para la evaluación tendrás que crear un clon o realizar un snapshot en VirtualBox delante de la persona evaluadora.

---

# Teoría de Born2BeRoot

### ¿Qué es una máquina virtual?

Una máquina virtual (VM) es básicamente una “máquina dentro de tu máquina”. La virtualización permite ejecutar varios sistemas en el mismo hardware físico como si fueran ordenadores independientes.

Un servidor físico tiene componentes como CPU, RAM, disco, red y un sistema operativo encima. Una VM usa el hardware de la máquina anfitriona, pero su sistema operativo y aplicaciones son totalmente independientes.

La capa que permite esto es el **hipervisor**, un software (como VirtualBox) que crea y gestiona VMs, repartiendo CPU, memoria y recursos, y evitando que interfieran entre sí.

Cada VM necesita un sistema operativo. En 42 se puede usar **Debian** o **Rocky**:

* **Debian**: más sencillo, muy personalizable, fácil de actualizar y más amigable para principiantes.
* **Rocky**: orientado a entornos empresariales, muy robusto y con mayor énfasis en seguridad.
  Por eso 42 recomienda empezar con Debian.

### ¿Para qué sirve una máquina virtual?

* Resulta más económico y práctico que tener varias máquinas físicas.
* Mantenimiento mucho menor.
* Permite hacer copias de seguridad con snapshots y restaurar el estado fácilmente.
* Aumenta la seguridad: cada VM está aislada del resto y del host.
* Ideal para pruebas, para aprender o para aislar servicios.

En resumen, una VM funciona como un ordenador normal, pero está contenida dentro de otro. Ahorras dinero, espacio, esfuerzo, mejoras la seguridad y simplificas las copias de seguridad. Con esta base teórica, ya puedes instalar tu primera VM.

### ¿Por qué has elegido Debian? En caso de haber elegido Debian (como es mi caso)

* **Debian**:
Debian es **recomendado para principiantes** porque es más sencillo de usar en administración de sistemas. Tiene mucha documentación y tutoriales, es muy estable y fiable, cuenta con una **comunidad grande y activa**, y usa **APT**, un gestor de paquetes **intuitivo y bien documentado**.

### ¿Por qué has elegido Rocky? En caso de haber elegido Rocky
* **Rocky**:
Rocky/CentOS es una opción **orientada a entornos profesionales** gracias a su estabilidad y soporte a largo plazo. Se caracteriza por ofrecer un sistema robusto, con actualizaciones controladas y predecibles, muy adecuado para aprender administración de sistemas en un contexto similar al de servidores en producción. Incorpora **SELinux**, un sistema de seguridad avanzado que permite aplicar políticas estrictas y gran nivel de control. Su gestor de paquetes DNF es moderno, eficiente y facilita el manejo de dependencias. Además, dispone de amplia documentación heredada del ecosistema RHEL (Red Hat Enterprise Linux), junto con una comunidad activa que mantiene Rocky Linux como sucesor estable tras el fin de CentOS clásico. Es una distribución adecuada cuando se busca un entorno seguro, consistente y con **enfoque empresarial**.

### ¿Qué es Aptitude y APT? ¿Cuales son sus diferencias? ¿y AppArmor? (si has elegido Debian) ¿y SELinux y DNF? ( si has elegido Rocky)

* **apt** → Gestor de paquetes principal.
* **aptitude** → Alternativa más “inteligente”, con semi-interfaz.
La diferencia principal es que apt es una interfaz más moderna y simplificada del gestor de paquetes APT, mientras que aptitude es una herramienta separada con una interfaz de terminal interactiva basada en curses que ofrece más funciones, como la resolución inteligente de dependencias y la gestión de paquetes en un formato de menú.

* **AppArmor** → sistema de seguridad que limita qué puede hacer cada programa (archivos a los que puede acceder, permisos, etc.). Añade capas de protección sin complicar demasiado la configuración. Explicado de una forma un poco más técnica; se trata de un módulo de seguridad del kernel de Linux que restringe las capacidades de los programas mediante perfiles de seguridad basados en rutas de archivos.
Su función es aplicar el control de acceso obligatorio (MAC) para limitar lo que un programa puede hacer, como acceder a archivos, redes o sockets. Es conocido por ser más fácil de usar que otras opciones y viene habilitado por defecto en distribuciones como Ubuntu y Debian. 

### SELinux y DNF (Rocky)

* **SELinux** → Se trata de un módulo de seguridad de Linux (Security-Enhanced Linux) que implementa un control de acceso obligatorio (MAC) para proteger el sistema. Muy seguro, pero también más complejo de configurar que AppArmor.
* **DNF** → Gestor de paquetes modernode CentOS/RHEL. Más moderno que yum, maneja mejor dependencias y actualizaciones.

### Ventajas y desventajas de una política de contraseñas estricta.

| Ventajas                                   | Desventajas                                                           |
|--------------------------------------------|-----------------------------------------------------------------------|
| Más seguridad.                              | Puede resultar molesto para los usuarios.                                  |
| Reduce accesos no autorizados.              | Contraseñas demasiado complejas llevan a que la gente las apunte en papel. |
| Obliga a renovar contraseñas periódicamente.| Si la política es exagerada, provoca errores y pérdida de tiempo.     |

Por tanto, **debe equilibrar seguridad y usabilidad**. No sirve una política ultra estricta si los usuarios no la pueden cumplir.

### ¿Qué es una partición? ¿Qué es LVM?

* **Partición**: división lógica de un disco físico. Permite separar el sistema, datos, swap, etc., organizando mejor el almacenamiento.

* **LVM**: capa flexible encima del disco que permite:
  - Redimensionar volúmenes sin desmontar discos.
  - Unir varios discos en uno lógico.
  - Crear snapshots.
  - Ampliar almacenamiento sin romper nada.
  - Mucha más flexibilidad que las particiones tradicionales.

### ¿Qué es sudo?
Comando que permite ejecutar acciones como superusuario sin iniciar sesión como root. Controla quién puede hacer qué, y deja registro de todas las acciones para auditoría.


### ¿Qué es UFW?
UFW es un firewall sencillo de configurar. Sirve para:

- Permitir o bloquear puertos.
- Proteger la máquina del tráfico no autorizado.
- Gestionar reglas de red de forma clara (`allow`, `deny`).


### ¿Qué es SSH?
SSH es un protocolo para conectarse de forma remota a otra máquina con cifrado.
Aporta una conexión segura, autenticación fuerte, transferencia cifrada de datos y posibilidad de administrar servidores a distancia de forma segura.
### ¿Qué es cron?

Sistema que ejecuta tareas programadas automáticamente. Sirve para lanzar scripts cada minuto, hora, día, semana o cuando se necesite. Ideal para mantenimiento, backups y automatización. Y en este proyecto se ha usado para programar que se lance el script monitoring.sh que muestra stats de la máquina en la terminal de los usuarios con sesión iniciada. En el proyecto se usa para lanzar [monitoring.sh](https://github.com/maramartinezvargas/Born2BeRoot/blob/main/monitoring.sh)

---

# Comprobaciones prácticas rápidas

### UFW

```bash
sudo ufw status
```

### SSH

```bash
sudo systemctl status ssh
```

Debe estar activo y escuchando solo por el puerto 4242.

### Grupos y usuarios

```bash
getent group sudo
getent group user42
```

### Política de contraseñas

```bash
sudo chage -l <usuario>
```

### Hostname

```bash
hostnamectl
```

### Particiones y LVM

```bash
lsblk
```

### Servicios

```bash
sudo service --status-all
```

---

# monitoring.sh

El script recoge información del sistema (CPU, RAM, disco, IP, carga, conexiones, sudo, etc.) y la envía con `wall` a todas las terminales.

### Ejecución periódica

```bash
sudo crontab -e
*/1 * * * * /usr/local/bin/monitoring.sh
```

### Ubicación recomendada

```
/usr/local/bin/monitoring.sh
```

---

# Explicación breve de los puntos claves del script monitoring.sh

* **uname -a** → arquitectura y kernel.
* **/proc/cpuinfo** → CPUs físicas y lógicas.
* **free --mega** → RAM total, usada y porcentaje.
* **df -m** → uso de disco total y porcentajes.
* **vmstat** → carga de CPU real.
* **who -b** → fecha del último arranque.
* **lsblk** → detección de LVM.
* **ss -ta** → conexiones TCP establecidas.
* **users** → usuarios conectados.
* **hostname -I** / **ip link** → IP y MAC.
* **journalctl** → número de usos de sudo.
* **wall** → muestra todo en las terminales activas.

---

