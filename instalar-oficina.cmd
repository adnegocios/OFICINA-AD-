@echo off
rem Oficina Virtual AD-NEGOCIOS: instalacion en esta PC (se usa una sola vez; repetirlo no borra nada).
rem Descarga el proyecto, instala lo necesario y Claude Code, crea config\rutas.json y el acceso directo del escritorio.
chcp 65001 >nul
setlocal
title Instalar Oficina Virtual AD-NEGOCIOS
set "REPO=https://github.com/adnegocios/oficina-ad-negocios.git"
set "RAMA=oficina-diseno"
set "DESTINO=%USERPROFILE%\oficina-ad-negocios"

echo ================================================
echo   Oficina Virtual AD-NEGOCIOS - instalacion
echo ================================================
echo.

where git >nul 2>&1
if errorlevel 1 goto falta_git
where node >nul 2>&1
if errorlevel 1 goto falta_node

if exist "%DESTINO%\.git" goto actualizar
echo [1/6] Descargando el proyecto. GitHub puede pedirte iniciar sesion...
git clone -q -b %RAMA% "%REPO%" "%DESTINO%"
if errorlevel 1 goto sin_acceso
goto dependencias

:actualizar
echo [1/6] El proyecto ya esta en esta PC: actualizando...
git -C "%DESTINO%" fetch -q origin
git -C "%DESTINO%" switch -q %RAMA%
git -C "%DESTINO%" pull -q --ff-only

:dependencias
echo [2/6] Instalando lo necesario para el navegador del SRI...
call npm.cmd install --prefix "%DESTINO%\tools\sri-login" --no-audit --no-fund --loglevel=error
if errorlevel 1 goto error

echo [3/6] Instalando Claude Code...
if exist "%APPDATA%\npm\claude.cmd" goto configurar
call npm.cmd install -g @anthropic-ai/claude-code --no-audit --no-fund --loglevel=error
if errorlevel 1 goto error

:configurar
echo [4/6] Configurando tus carpetas...
node "%DESTINO%\oficina\configurar.js"
if errorlevel 1 goto error

echo [5/6] Creando el acceso directo "Oficina AD-NEGOCIOS" en el escritorio...
powershell -NoProfile -Command "$e=[Environment]::GetFolderPath('Desktop'); $s=(New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path $e 'Oficina AD-NEGOCIOS.lnk')); $s.TargetPath='%DESTINO%\oficina\encender-oficina.cmd'; $s.WorkingDirectory='%DESTINO%'; $s.Save()"

echo [6/6] Revisando la sesion de Claude Code...
call "%APPDATA%\npm\claude.cmd" auth status >nul 2>&1
if not errorlevel 1 goto listo
echo.
echo Falta iniciar sesion en Claude Code. Al pulsar una tecla se abrira:
echo elige iniciar sesion con tu cuenta, termina en el navegador y luego escribe /exit
pause
call "%APPDATA%\npm\claude.cmd"

:listo
echo.
echo ================================================
echo   Listo. Usa el acceso directo del escritorio:
echo   "Oficina AD-NEGOCIOS"
echo ================================================
pause
exit /b 0

:falta_git
echo Falta Git. Instalalo desde https://git-scm.com/download/win y vuelve a abrir este archivo.
pause
exit /b 1

:falta_node
echo Falta Node.js. Instala la version LTS desde https://nodejs.org y vuelve a abrir este archivo.
pause
exit /b 1

:sin_acceso
echo No se pudo descargar el proyecto. Pide acceso al repositorio adnegocios/oficina-ad-negocios en GitHub.
pause
exit /b 1

:error
echo Algo fallo en la instalacion. Copia lo que aparece arriba y envialo a Francis.
pause
exit /b 1
