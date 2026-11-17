# Oficina Virtual AD-NEGOCIOS

Enlace: https://adnegocios.github.io/OFICINA-AD-/

La pagina trabaja con la oficina encendida en **tu PC**: el navegador del SRI, la carpeta de SharePoint y los agentes estan en cada computadora.

## Para trabajar desde el enlace
1. En tu PC, ten instalado el proyecto `oficina-ad-negocios` (repositorio privado del equipo), Node, Claude Code con sesion iniciada y `config/rutas.json` con tus carpetas.
2. Enciende la oficina y deja la ventana abierta:
   `node C:\Users\<tu usuario>\oficina-ad-negocios\oficina\server.js`
3. Abre el enlace. Si el navegador pregunta por acceso a la red local, pulsa **Permitir**.

Si la oficina no esta encendida, la pagina lo avisa y muestra un boton **Reintentar**.

## Seguridad
- La pagina solo habla con la oficina de tu propia PC (127.0.0.1); no envia nada a internet.
- Las credenciales del SRI **no** se llenan desde este enlace: solo desde http://127.0.0.1:4173 en tu PC, o escribiendolas en la ventana del SRI.
