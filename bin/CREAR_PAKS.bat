@echo off
rem Syphon Filter 3 - PC: crea idiomas.pak y armas.pak a partir de los archivos sueltos
rem (textos_es.pak, textos_ru.pak, voces_es.pak, videos_es_*.pak, voces_ru_*.pak y la carpeta armas)
rem que haya junto al juego o hasta tres carpetas mas arriba. Los .pak se escriben donde estaban esos archivos.
rem Creates idiomas.pak and armas.pak from the loose language and weapon files.
"%~dp0sf3_nativo.exe" --crear-paks
