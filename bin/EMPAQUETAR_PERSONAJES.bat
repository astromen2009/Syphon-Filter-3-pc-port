@echo off
rem Syphon Filter 3 - PC: junta la carpeta "personajes" en personajes.pak
rem (personajes.txt, personajes.pak del juego, retratos\*.bmp y los archivos anadidos;
rem no entran respaldos_editor ni las imagenes .png de ayuda).
rem Busca la carpeta junto al juego o hasta tres carpetas mas arriba y escribe
rem personajes.pak al lado de esa carpeta. Vuelve a ejecutarlo cada vez que cambies la carpeta.
rem Packs the "personajes" folder into personajes.pak. Run it again after changing the folder.
"%~dp0sf3_nativo.exe" --crear-pak-personajes
