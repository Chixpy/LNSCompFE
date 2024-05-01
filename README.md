## LNSCompFE ##

![LNSCompFE 1.0.X.X](../../wiki/img/LNSCompFE/Main.png)

Front-End para las competiciones de [Las Noches Skyperas](https://nochesskyperas.foroactivo.com/).

LNSCompFE es un pequeño Front-End pensado para facilitar un poco los intentos en los campeonatos de [Las Noches Skyperas](http://nochesskyperas.1foro.com). Aunque nada impide configurarse para su uso e interés personal, ya que ofrece facilidades a la hora de grabar INP con (Wolf)MAME.

Además se incluye un .bat que realiza las misma funciones, en caso de que se prefiera usar dicha versión.

* [Ayuda](https://github.com/Chixpy/LNSCompFE/wiki)
* [Descargas](https://github.com/Chixpy/LNSCompFE/releases)

Las principales ventajas que ofrece respecto a usar directamente el interfaz de WolfMAME son:

* Intenta eliminar la influencia de la NVRAM, HiScores y demás datos que pueden afectar a la reproducción. Para ello:
  * Realiza una copia de seguridad esos datos.
  * Borra los originales antes de comenzar un nuevo intento.
  * Restaura todo tras terminar el intento.
  * NOTA: Los DIP switches no. Porque se guardan junto la configuración de los botones.
* Permite indicar si se quiere conservar la partida *después* de grabarla (haciendo una copia del .inp)
* Guarda un registro de intentos realizados, con su fecha de inicio, duración y la puntuación conseguida en un archivo CSV.
* En versiones más actuales a WolfMAME 0.181 (versión usada en las competiciones por el momento), además ya están no implementados los botones para grabar o reproducir archivos .inp, lo que hace más tedioso aún realizar los intentos. Y este programa supliría esas funciones de grabar y reproducir.
* Además permite grabar a AVI (usando el propio WolfMAME) las partidas. 
* Por otra parte, parece ser que reiniciar la grabación con **MAYS+F3** funciona correctamente sólo si es ejecutado desde la línea de comandos. Por tanto este atajo se puede usar si se realizan los intentos con este frontend. OJO: Este atajo solo es útil para juegos en los que la NVRAM no afecta en la reproducción.

Respecto a los archivos `record.bat` y `playback.bat` incluidos en el propio WolfMAME indicar que al menos hasta la versión 0.197 realizan incorrectamente su función de hacer una copia de seguridad y borrar la NVRAM; aunque realizan su cometido ya que asignan el directorio de la NVRAM a `nul`.

