@echo off
rem Syphon Filter 3 - PC: junta las carpetas "sonidos", "voces_propias" y "videos_propios" en m_media.pak
rem (sonidos\muerte_hombre y muerte_mujer\*.wav, voces_propias\EN_###.wav y de videos_propios
rem solo los .mpg y .wav de arriba: TITLE_alta.mpg, ZINTRO.wav...; las subcarpetas y los .mp4 no entran).
rem Busca las carpetas junto al juego o hasta tres carpetas mas arriba y escribe
rem m_media.pak al lado de ellas. Vuelve a ejecutarlo cada vez que cambies esas carpetas.
rem Packs the sonidos, voces_propias and videos_propios folders into m_media.pak.
"%~dp0sf3_nativo.exe" --crear-pak-media
