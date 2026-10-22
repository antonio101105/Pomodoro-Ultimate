# 🍅 Pomodoro Ultimate - Tu Compañero de Productividad

**Pomodoro Ultimate** es una herramienta diseñada para potenciar tu concentración y eficiencia utilizando la técnica Pomodoro en un entorno visual limpio y sin distracciones.

## 🚀 Características Principales

* **Modo Oscuro (Dark Mode):** Interfaz en escala de grises diseñada para reducir la fatiga visual durante largas sesiones.
* **Temporizador Flexible:** Botones rápidos para **10, 25 y 30 minutos**, o entrada manual para tiempos personalizados.
* **Enfoque Total:**
    * **Modo Mini (↗):** Reduce la aplicación a lo esencial para ocupar el mínimo espacio en pantalla.
    * **Siempre Visible (Always on Top):** Opción para fijar el reloj sobre otras ventanas.
    * **Modo Fantasma (Opacidad):** Ajusta la transparencia de la ventana para ver lo que hay detrás.
* **Gestión de Tareas:** Campo de texto integrado para escribir tu objetivo actual y no perder el norte.
* **Gamificación:** Contador de sesiones completadas con indicador visual (🍅).
* **Alertas Visuales y Sonoras:**
    * El reloj cambia a **Naranja** (último minuto) y **Rojo** (últimos 10 segundos).
    * Sonidos de sistema suaves al finalizar, sin pitidos molestos.
* **Atajos de Teclado:**
    * `Espacio`: Iniciar / Pausar.
    * `Esc`: Detener / Reiniciar.

---

## 📋 Instrucciones de Uso

1.  **Ejecutar:** Descarga `Pomodoro.exe` desde [Releases](https://github.com/antonio101105/Pomodoro-Ultimate/releases/latest), comprueba su hash SHA-256 (publicado en la release) y ábrelo. También puedes ejecutar directamente `Pomodoro.ps1` con PowerShell.
2.  **Configurar:** Elige un tiempo predefinido o escribe uno manualmente y pulsa **OK**.
3.  **Enfocar:** Escribe tu tarea en la caja de texto central.
4.  **Iniciar:** Pulsa el botón verde **"INICIAR"** (o presiona la `Barra Espaciadora`).
5.  **Trabajar:** Concéntrate hasta que suene la alarma y veas el tomate 🍅.

---

## 🛠 Requisitos

* **Sistema Operativo:** Windows 10 o Windows 11.
* **Portabilidad:** No requiere instalación (Portable).
* **Tecnología:** Desarrollado con PowerShell y Windows Forms.

> **¡Mantén el foco y alcanza tus objetivos!**

---

## 🔐 Verificación del ejecutable

El `.exe` no está firmado digitalmente, así que Windows SmartScreen puede avisar al abrirlo. Antes de ejecutarlo, compara su hash con el publicado en la release:

```powershell
Get-FileHash .\Pomodoro.exe -Algorithm SHA256
```

## 📄 Licencia

[MIT](LICENSE)
