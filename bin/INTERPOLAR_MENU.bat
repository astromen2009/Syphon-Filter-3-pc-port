@echo off
rem v234: sube el video del menu principal reescalado de 15 a 60 cuadros por
rem segundo con RIFE (rife-ncnn-vulkan, portable, usa la grafica por Vulkan) y lo
rem deja listo para el port: videos_propios\TITLE_alta.mpg
rem (y una copia para guardar: videos_propios\TITLE_60fps.mp4).
rem Necesita, en esta carpeta (SF3_NATIVO):
rem   - ffmpeg.exe
rem   - la carpeta descomprimida de rife-ncnn-vulkan (rife-ncnn-vulkan-...-windows)
rem Uso: doble clic (usa videos_propios\TITLE.mp4) o arrastra un video encima.
chcp 65001 >nul
setlocal EnableDelayedExpansion
cd /d "%~dp0"

set "ENTRADA=%~1"
if "%ENTRADA%"=="" set "ENTRADA=videos_propios\TITLE.mp4"
if not exist "%ENTRADA%" (
  echo No encuentro el video: %ENTRADA%
  pause & exit /b 1
)

set "FFMPEG=ffmpeg.exe"
if exist "%~dp0ffmpeg.exe" set "FFMPEG=%~dp0ffmpeg.exe"
"%FFMPEG%" -version >nul 2>&1
if errorlevel 1 (
  echo No encuentro ffmpeg.exe ^(https://www.gyan.dev/ffmpeg/builds/, bin\ffmpeg.exe^).
  pause & exit /b 1
)

set "RIFE="
if exist "%~dp0rife-ncnn-vulkan.exe" set "RIFE=%~dp0rife-ncnn-vulkan.exe"
for /d %%d in ("%~dp0rife-ncnn-vulkan*") do if exist "%%d\rife-ncnn-vulkan.exe" set "RIFE=%%d\rife-ncnn-vulkan.exe"
if "%RIFE%"=="" (
  echo No encuentro rife-ncnn-vulkan.exe.
  echo Descarga el .zip de Windows de https://github.com/nihui/rife-ncnn-vulkan/releases
  echo y descomprimelo dentro de esta carpeta ^(SF3_NATIVO^).
  pause & exit /b 1
)
for %%r in ("%RIFE%") do set "RIFEDIR=%%~dpr"
set "MODELO=%RIFEDIR%rife-v4.6"
if not exist "%MODELO%\" (
  for /d %%m in ("%RIFEDIR%rife-v4*") do set "MODELO=%%m"
)
if not exist "%MODELO%\" (
  echo No encuentro el modelo rife-v4 dentro de "%RIFEDIR%".
  pause & exit /b 1
)

set "TMPD=%~dp0temp_interpolar"
echo.
echo Hace falta unos 8 GB libres en este disco mientras trabaja (se borran al final)
echo y puede tardar bastante (de 10 a 30 minutos con la grafica integrada).
echo.
if exist "%TMPD%" rmdir /s /q "%TMPD%"
mkdir "%TMPD%\entrada" "%TMPD%\salida"

echo [1/4] Sacando los cuadros del video...
"%FFMPEG%" -v error -stats -i "%ENTRADA%" -fps_mode passthrough "%TMPD%\entrada\%%08d.png"
if errorlevel 1 goto error

for /f %%c in ('dir /b /a-d "%TMPD%\entrada\*.png" ^| find /c /v ""') do set N=%%c
set /a SALIDA=N*4
echo       !N! cuadros ^> !SALIDA! cuadros

echo [2/4] Interpolando con RIFE (modelo %MODELO%)...
"%RIFE%" -i "%TMPD%\entrada" -o "%TMPD%\salida" -m "%MODELO%" -n !SALIDA! -f %%08d.png
if errorlevel 1 goto error

echo [3/4] Copia para guardar: videos_propios\TITLE_60fps.mp4 ...
"%FFMPEG%" -v error -stats -y -framerate 60 -i "%TMPD%\salida\%%08d.png" -c:v libx264 -crf 16 -preset slow -pix_fmt yuv420p "videos_propios\TITLE_60fps.mp4"
if errorlevel 1 goto error

echo [4/4] Para el port: videos_propios\TITLE_alta.mpg ...
"%FFMPEG%" -v error -stats -y -framerate 60 -i "%TMPD%\salida\%%08d.png" -an -c:v mpeg1video -r 60 -q:v 2 -g 30 -bf 0 -f mpeg "videos_propios\TITLE_alta.mpg"
if errorlevel 1 goto error

rmdir /s /q "%TMPD%"
for %%i in (1 2 3 4 5 6 7 8 9) do if exist "videos_propios\TITLE_alta_%%i.mpg" del "videos_propios\TITLE_alta_%%i.mpg"
echo.
echo Listo: el menu principal ya va a 60 cuadros por segundo.
echo (Lanzador: Configuracion ^> General ^> "Menu principal de alta calidad".)
pause
exit /b 0

:error
echo.
echo Algo fallo. Los cuadros quedaron en "%TMPD%" para revisarlos.
echo Si el error es de RIFE, prueba a actualizar el driver de la grafica.
pause
exit /b 1
