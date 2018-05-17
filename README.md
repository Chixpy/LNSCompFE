## LNSCompFE ##
Front-End para las competiciones de Las Noches Skyperas.

*POR EL MOMENTO, TAN SOLO ESTÁ IMPLEMENTADA LA VERSIÓN .BAT*

Aunque este repositorio es para la creación de un FrontEnd con ventanas, el archivo por lotes ofrecen las mismas características esenciales... y en mi opinión, a la larga, es más cómodo de usar.

## Está por implementar ##

La idea es implementar la misma funcionalidad de los archivos .BAT en un entorno gráfico más amigable en vez de un menú de MS-DOS. Y tal vez añadir alguna chorraduca adicional como el poder ver los screenshots de los juegos.

LNSCompFE es un pequeño Front-End pensado para facilitar un poco los intentos en los campeonatos de [Las Noches Skyperas](http://nochesskyperas.1foro.com). Aunque nada impide configurarse para su uso e interés personal, ya que ofrece alguna utilidad extra.

Las principales ventajas que ofrece respecto a usar directamente el interfaz de WolfMAME son:

* Borra la NVRAM, HiScores y demás datos que pueden afectar a la reproducción antes de comenzar un nuevo intento. Los DIP switches no... porque se guardan junto la configuración de los botones.
* Permite indicar si se quiere conservar la partida *después* de grabarla (haciendo una copia del .inp)
* Guarda un registro de intentos realizados, con su fecha de inicio, duración y la puntuación conseguida en un archivo CSV.
* En versiones más actuales a WolfMAME 0.181 (versión usada en las competiciones por el momento), además ya están no implementados los botones para grabar o reproducir archivos .inp, lo que hace más tedioso aún realizar los intentos. Y este programa supliría esas funciones de grabar y reproducir.
* Además permite grabar a AVI (usando el propio WolfMAME) las partidas. 
* Por otra parte, parece ser que reiniciar la grabación con **MAYS+F3** funciona correctamente sólo si es ejecutado desde la línea de comandos. Por tanto este atajo se puede usar si se realizan los intentos con este frontend. OJO: Este atajo es útil para juegos en los que la NVRAM no afecta en la reproducción.

Respecto a los archivos `record.bat` y `playback.bat` incluidos en el propio WolfMAME indicar que al menos hasta la versión 0.197 realizan incorectamente su función de hacer una copia de seguridad y borrar la NVRAM; aunque realizan su cometido ya que asignan el direcorio de la NVRAM a `nul`.

