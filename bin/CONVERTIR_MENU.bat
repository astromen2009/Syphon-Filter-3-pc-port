@echo off
rem v234: convierte el video del menu principal reescalado (MP4 u otro) al
rem formato que lee el port: videos_propios\TITLE_alta.mpg (MPEG-1, un solo archivo).
rem Uso: doble clic (usa videos_propios\TITLE.mp4) o arrastra un video encima.
rem Hace falta ffmpeg.exe junto a este .bat (o instalado en el sistema).
chcp 65001 >nul
setlocal
cd /d "%~dp0"

set "ENTRADA=%~1"
if "%ENTRADA%"=="" set "ENTRADA=videos_propios\TITLE.mp4"
if not exist "%ENTRADA%" (
  echo No encuentro el video: %ENTRADA%
  echo Pon tu video en videos_propios\TITLE.mp4 o arrastralo encima de este archivo.
  pause
  exit /b 1
)

set "FFMPEG=ffmpeg.exe"
if exist "%~dp0ffmpeg.exe" set "FFMPEG=%~dp0ffmpeg.exe"
"%FFMPEG%" -version >nul 2>&1
if errorlevel 1 (
  echo No encuentro ffmpeg.exe.
  echo Descargalo de https://www.gyan.dev/ffmpeg/builds/ ^(ffmpeg-release-essentials.zip^),
  echo y copia bin\ffmpeg.exe junto a este archivo ^(en la carpeta SF3_NATIVO^).
  pause
  exit /b 1
)

echo Convirtiendo "%ENTRADA%" a videos_propios\TITLE_alta.mpg ...
echo (puede tardar uno o dos minutos)
"%FFMPEG%" -v error -stats -y -i "%ENTRADA%" -an -c:v mpeg1video -r 30 -q:v 2 -g 15 -bf 0 -f mpeg "videos_propios\TITLE_alta.mpg"
if errorlevel 1 (
  echo Error al convertir.
  pause
  exit /b 1
)

rem Las partes de antes ya no hacen falta (el archivo unico tiene preferencia).
for %%i in (1 2 3 4 5 6 7 8 9) do if exist "videos_propios\TITLE_alta_%%i.mpg" del "videos_propios\TITLE_alta_%%i.mpg"

echo.
echo Listo: videos_propios\TITLE_alta.mpg
echo En el lanzador: Configuracion ^> General ^> "Menu principal de alta calidad".
pause
