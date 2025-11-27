---

# Born2BeRoot – 42 Madrid | Fundación Telefónica

Born2BeRoot es un proyecto de iniciación a la administración de sistemas dentro del cursus de 42 Network. Consiste en configurar un servidor Linux desde una instalación mínima y sin interfaz gráfica. Incluye particionado con LVM, políticas de contraseñas, seguridad, gestión de usuarios y grupos, configuración de sudo, UFW, SSH y un script de monitorización periódica del sistema.

Este repositorio contiene **mi script `monitoring.sh`** y apuntes esenciales para preparar la evaluación.

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

Cada VM necesita un sistema operativo. En 42 se puede usar **Debian** o **CentOS**:

* **Debian**: más sencillo, muy personalizable, fácil de actualizar y más amigable para principiantes.
* **CentOS**: orientado a entornos empresariales, muy robusto y con mayor énfasis en seguridad.
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

### ¿Por qué has elegido Rocky? En caso de haber elegido Rcoky
* **Rocky**:
Rocky/CentOS es una opción **orientada a entornos profesionales** gracias a su estabilidad y soporte a largo plazo. Se caracteriza por ofrecer un sistema robusto, con actualizaciones controladas y predecibles, muy adecuado para aprender administración de sistemas en un contexto similar al de servidores en producción. Incorpora **SELinux**, un sistema de seguridad avanzado que permite aplicar políticas estrictas y gran nivel de control. Su gestor de paquetes DNF es moderno, eficiente y facilita el manejo de dependencias. Además, dispone de amplia documentación heredada del ecosistema RHEL (Red Hat Enterprise Linux), junto con una comunidad activa que mantiene Rocky Linux como sucesor estable tras el fin de CentOS clásico. Es una distribución adecuada cuando se busca un entorno seguro, consistente y con **enfoque empresarial**.

### ¿Qué es Aptitude y APT? ¿Cuales son sus diferencias? ¿y AppArmor? (si has elegido Debian) ¿y SELinux y DNF? ( si has elegido Rocky)

* **apt** → Gestor de paquetes principal.
* **aptitude** → Alternativa más “inteligente”, con semi-interfaz.
La diferencia principal es que apt es una interfaz más moderna y simplificada del gestor de paquetes APT, mientras que aptitude es una herramienta separada con una interfaz de terminal interactiva basada en curses que ofrece más funciones, como la resolución inteligente de dependencias y la gestión de paquetes en un formato de menú.

* **AppArmor** → Sistema de control de permisos por aplicación.
Se trata de un módulo de seguridad del kernel de Linux que restringe las capacidades de los programas mediante perfiles de seguridad basados en rutas de archivos.
Su función es aplicar el control de acceso obligatorio (MAC) para limitar lo que un programa puede hacer, como acceder a archivos, redes o sockets. Es conocido por ser más fácil de usar que otras opciones y viene habilitado por defecto en distribuciones como Ubuntu y Debian. 

### SELinux y DNF (Rocky)

* **SELinux** → Se trata de un módulo de seguridad de Linux (Security-Enhanced Linux) que implementa un control de acceso obligatorio (MAC) para proteger el sistema
* **DNF** → Gestor de paquetes moderno.

### Política de contraseñas estricta

Seguridad más alta, pero puede ser molesta y generar malas prácticas si se exagera.

### ¿Qué es una partición? ¿Qué es LVM?

* **Partición**: división lógica del disco.
* **LVM**: sistema flexible que permite redimensionar volúmenes, unir discos y crear snapshots sin romper nada.

### ¿Qué es sudo?

Permite ejecutar acciones como administrador sin iniciar sesión como root, registrando todas las acciones.

### ¿Qué es UFW?

Firewall simplificado para permitir/bloquear puertos.

### ¿Qué es SSH?

Protocolo seguro para acceder a máquinas remotas. Todo va cifrado.

### ¿Qué es cron?

Programador de tareas. En el proyecto se usa para lanzar `monitoring.sh`.

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

# Explicación breve del script

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

