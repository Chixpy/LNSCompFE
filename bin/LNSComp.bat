@GOTO BatchMain
:: LNSComp.bat 1.1.0
:: Copyright (C) 2017-2018 Chixpy
:: https://github.com/Chixpy/LNSCompFE
::
:: This program is free software: you can redistribute it and/or modify
:: it under the terms of the GNU General Public License as published by
:: the Free Software Foundation, either version 3 of the License, or
:: (at your option) any later version.
::
:: This program is distributed in the hope that it will be useful,
:: but WITHOUT ANY WARRANTY; without even the implied warranty of
:: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
:: GNU General Public License for more details.
::
:: You should have received a copy of the GNU General Public License
:: along with this program.  If not, see <http://www.gnu.org/licenses/>.
::
:: ---------------------------------------------------------------------
::
:: Solo probado con Win10, muy posiblemente funcione en WinVista e incluso 
::   WinXP; pero no me hago responsable de que no funcione o cause algún daño
::   o pérdida de datos.
::
:: El programa está pensado para ejecutarse desde el mismo directorio que
::   el ejecutable de (Wolf)MAME y con los directorios INP, NVRAM, DIFF,
::   HI y CFG en sus ubicaciones por defecto.
::
:: TODO: Cosas por hacer... 
::   * Poder grabar con un estado inicial de la NVRAM, dicho de otro modo:
::     1. Guardar el estado actual.
::     2. Restaurar el estado inicial para grabar. ¬¬
::        (¿Dónde debería estar guardado previamente?)
::     3. Ejecutar MAME.
::     4. Restaurar el estado actual. 
::        (o preguntar si se quiere mantener la NVRAM generada...)
::     5. Hacer una copia del estado inicial si la partida se conserva.
::        (¿Dónde lo guardo, junto al inp?)
::     ¬¬ Esto implica que en CrearAVI o ReproducirINP en el paso 2
::          hay que restaurar el estado inicial correspondiente a cada partida.
::        Como recordatorio, si se implementa esto habrá que quitar el parámetro
::          -nvram_dir nul de las llamadas al ejecutable.
::   * Poder definir un MAME que está en otro directorio distinto al Batch...
::     (Esto realmente no tengo casi nada de interés por hacerlo)
::     

@GOTO BatchMain

:: VARIABLES PRINCIPALES ======================================================
:BatchInit
:: Aquí irían las variables principales para no estar buscando en todo el 
::   fichero... pero como ahora se van a guardar en un fichero externo esto
::   es usado para definir algún valor por defecto inicial y cargar la
::   configuración.

:: Archivo de configuración
SET $LNSConfig=LNSComp.ini

:: Valores por defecto, aunque luego se cambien.
SET $LNSEjecutable=mamearcade.exe
SET $LNSFechaFin=%date%

IF EXIST "%$LNSConfig%" (
  FOR /F "delims=" %%A IN (%$LNSConfig%) DO SET "%%A"
) ELSE (
  CALL :LNSConfig
)

:BatchInitEnd
GOTO :EOF

:: COMPROBACIONES INICIALES ===================================================
:BatchMain

@ECHO off

:: Comprobando que se pueden usar las CMDEXT
SETLOCAL EnableExtensions
chcp 65001
>NUL ECHO & GOTO CHKCMDEXT
GOTO BatchErrorNOCMDEXT
:CHKCMDEXT
IF "~x0"=="%~x0" GOTO BatchErrorNOCMDEXT
IF "%%~x0"=="%~x0" GOTO BatchErrorNOCMDEXT
SET "CMDEXTVERSION="
:: Comprobamos si es la version 1
IF "%CMDEXTVERSION%"=="" (
  ECHO.
  ECHO Se ha detectado "Command extensions v1", el programa continuará de
  ECHO   todas formas, pero se desconoce si funcionará correctamente en su
  ECHO   totalidad.
  ECHO.
  PAUSE
)
 
CALL :BatchInit
CALL :BatchRun

GOTO BatchEnd

:: PROGRAMA PRINCIPAL =========================================================
:BatchRun
:: Definiendo unos valores por defecto
IF NOT DEFINED $LNSFichAct (
  SET $LNSFichAct=%$LNSFichero1%
  SET $LNSJuegAct=%$LNSJuego1%
)
CLS
echo.
ECHO  %date% %time:~0,8% - Fin del campeonato: %$LNSFechaFin%             
ECHO  -----------------------------------------------------------------------------
ECHO                         CAMPEONATO DE LAS NOCHES SKYPERAS
ECHO  -----------------------------------------------------------------------------
ECHO.
ECHO   Hola, %$LNSJugador%
ECHO.
ECHO   %$LNSJuegAct%
ECHO                                   --------------------------------------------
ECHO     [E] - Grabar INP             ^|   Cambiar de juego:
ECHO                                  ^|
ECHO     [R] - Reproducir INP         ^|     [1] - %$LNSJuego1%
ECHO                                  ^|
ECHO     [V] - Crear AVI              ^|     [2] - %$LNSJuego2%
ECHO                                  ^|
ECHO     [P] - Practicar              ^|     [3] - %$LNSJuego3%
ECHO                                  ^|
ECHO  -----------------------------------------------------------------------------
ECHO     [0]  - Salir             [A] - Ayuda                [C] - Configuración
ECHO  -----------------------------------------------------------------------------

CHOICE /c:123ERVP0OAC > NUL

IF ERRORLEVEL 11 (
  CALL :LNSConfig
  GOTO BatchRunEnd
)
IF ERRORLEVEL 10 (
  CALL :LNSAyuda
  GOTO BatchRunEnd
)
IF ERRORLEVEL 9 GOTO :EOF
IF ERRORLEVEL 8 GOTO :EOF
IF ERRORLEVEL 7 (
  CALL :LNSPracticar "%$LNSFichAct%" "%$LNSJuegAct%"
  GOTO BatchRunEnd
)
IF ERRORLEVEL 6 (
  CALL :LNSCrearAVI "%$LNSFichAct%" "%$LNSJuegAct%"
  GOTO BatchRunEnd
)
IF ERRORLEVEL 5 (
  CALL :LNSReprINP "%$LNSFichAct%" "%$LNSJuegAct%"
  GOTO BatchRunEnd
)
IF ERRORLEVEL 4 (
  CALL :LNSCrearINP "%$LNSFichAct%" "%$LNSJuegAct%"
  GOTO BatchRunEnd
)
IF ERRORLEVEL 3 (
  SET $LNSFichAct=%$LNSFichero3%
  SET $LNSJuegAct=%$LNSJuego3%
  GOTO BatchRunEnd
)
IF ERRORLEVEL 2 (
  SET $LNSFichAct=%$LNSFichero2%
  SET $LNSJuegAct=%$LNSJuego2%
  GOTO BatchRunEnd
)
IF ERRORLEVEL 1 (
  SET $LNSFichAct=%$LNSFichero1%
  SET $LNSJuegAct=%$LNSJuego1%
  GOTO BatchRunEnd
)

:BatchRunEnd
GOTO BatchRun

:: SUBRUTINAS =================================================================

:: SUB BorrarNVRAM ------------------------------------------------------------
:BorrarNVRAM
:: Necesita:
:: * $1 = Nombre de la ROM de la que hay que borrar la NVRAM.
:: Borra haciendo una copia de seguridad el directorio nvram\$1 y similares.
SETLOCAL
SET $Fichero=%~1

ECHO BORRANDO NVRAM... %$Fichero%
ECHO -----------------
IF NOT DEFINED $Fichero (
  ECHO ERROR - BorrarNVRAM: No se ha definido nombre del fichero.
  PAUSE
  GOTO BorrarNVRAMEnd
)

:: No borramos cfg porque guarda la configuración de los botones...
::   ... pero ahí se guarda la configuración de los DIP Switches
:: IF EXIST "cfg\%$Fichero%.cfg" MOVE /Y "cfg\%$Fichero%.cfg" "cfg\%$Fichero%.cfg.bak"
IF EXIST "hi\%$Fichero%.hi" MOVE /Y "hi\%$Fichero%.hi" "hi\%$$Fichero%.hi.bak"
IF EXIST "hi\%$Fichero%" MOVE /Y "hi\%$Fichero%" "hi\%$Fichero%.bak"
IF EXIST "nvram\%$Fichero%.nv" MOVE /Y "nvram\%$Fichero%.nv" "nvram\%$Fichero%.nv.bak"
IF EXIST "nvram\%$Fichero%" MOVE /Y "nvram\%$Fichero%" "nvram\%$Fichero%.bak"
IF EXIST "diff\%$Fichero%.dif" MOVE /Y "diff\%$Fichero%.dif" "diff\%$Fichero%.dif.bak"
IF EXIST "diff\%$Fichero%" MOVE /Y "diff\%$Fichero%" "diff\%$Fichero%.bak"

:BorrarNVRAMEnd
ENDLOCAL

GOTO :EOF

:: SUB RestaurarNVRAM ------------------------------------------------------------
:RestaurarNVRAM
:: Necesita:
:: * $1 = Nombre de la ROM de la que hay que restaurar la NVRAM.
:: Restaura la NVRAM anterior a la grabación nvram\$1 y similares.
SETLOCAL
SET $Fichero=%~1

ECHO RESTAURANDO NVRAM... %$Fichero%
ECHO -----------------
IF NOT DEFINED $Fichero (
  ECHO ERROR - RestaurarNVRAM: No se ha definido nombre del fichero.
  PAUSE
  GOTO RestaurarNVRAMEnd
)

:: Aunque MOVE sobreescribe los ficheros si ya existen, los borramos primero
::   por si no existían originalmente y ha sido creado nuevo durante la
::   ejecución de MAME.
:: IF EXIST "cfg\%$Fichero%.cfg" DEL "cfg\%$Fichero%.cfg"
IF EXIST "hi\%$Fichero%.hi" DEL "hi\%$$Fichero%.hi"
IF EXIST "hi\%$Fichero%" RD /s /q "hi\%$Fichero%"
IF EXIST "nvram\%$Fichero%.nv" DEL "nvram\%$Fichero%.nv"
IF EXIST "nvram\%$Fichero%" RD /s /q "nvram\%$Fichero%"
IF EXIST "diff\%$Fichero%.dif" DEL "diff\%$Fichero%.dif"
IF EXIST "diff\%$Fichero%" RD /s /q "diff\%$Fichero%"

:: IF EXIST "cfg\%$Fichero%.cfg.bak" MOVE /Y "cfg\%$Fichero%.cfg.bak" "cfg\%$Fichero%.cfg"
IF EXIST "hi\%$Fichero%.hi.bak" MOVE /Y "hi\%$Fichero%.hi.bak" "hi\%$$Fichero%.hi"
IF EXIST "hi\%$Fichero%.bak" MOVE /Y "hi\%$Fichero%.bak" "hi\%$Fichero%"
IF EXIST "nvram\%$Fichero%.nv.bak" MOVE /Y "nvram\%$Fichero%.nv.bak" "nvram\%$Fichero%.nv"
IF EXIST "nvram\%$Fichero%.bak" MOVE /Y "nvram\%$Fichero%.bak" "nvram\%$Fichero%"
IF EXIST "diff\%$Fichero%.dif.bak" MOVE /Y "diff\%$Fichero%.dif.bak" "diff\%$Fichero%.dif"
IF EXIST "diff\%$Fichero%.bak" MOVE /Y "diff\%$Fichero%.bak" "diff\%$Fichero%"

:RestaurarNVRAMEnd
ENDLOCAL

GOTO :EOF

:: SUB SelecFichero -----------------------------------------------------------
:SelecFichero
:: Necesita:
:: · $1 = Directorio y filtro para listar los ficheros
:: Devuelve:
:: · %$SubSFFichero% = Nombre del fichero elegido.
:: Muestra un listado de archivos y permite elegir uno.
::   En caso de error %$SubSFFichero% no estará definida.
SETLOCAL EnableDelayedExpansion
SET $SubSFFichero=
SET $SubSFFiltro=%~1

:: ERROR no se ha definido el filtro
IF NOT DEFINED $SubSFFiltro (
  ECHO ERROR - SelecFichero: No se ha definido el filtro de búsqueda.
  PAUSE
  GOTO SelecFicheroEnd
)

SET $FicheroIndex=0
FOR %%f IN ("%$SubSFFiltro%") DO (
   SET $INPFich!$FicheroIndex!=%%f
   ECHO   !$FicheroIndex! - %%f
   SET /A $FicheroIndex=!$FicheroIndex!+1
)

IF %$FicheroIndex% equ 0 (
  ECHO No se ha encontrado ningún archivo.
  GOTO SelecFicheroEnd
)

SET /P $INPSelec="Seleccione un fichero: " 
IF NOT DEFINED $INPFich%$INPSelec% (
   ECHO ¡Número inválido seleccionado! 
:: Pausa controlada por quien lo llame - PAUSE   
   GOTO SelecFicheroEnd
)

SET $SubSFFichero=!$INPFich%$INPSelec%!

:SelecFicheroEnd
ENDLOCAL & SET $SubSFFichero=%$SubSFFichero%

GOTO :EOF

:: AYUDA ======================================================================
:LNSAyuda
CLS
ECHO Hola, %$LNSJugador%.
ECHO.
ECHO Veo que has encontrado la ayuda así que no te voy a explicar para que sirve
ECHO   la opción [A].
ECHO.
ECHO Para elegir un juego pulsa [1], [2] o [3] y se te mostrará en el menú el juego
ECHO   elegido.
ECHO.
ECHO Una vez has seleccionado el juego puedes realizar las siguientes acciones:
ECHO   [E] - Ejecuta el juego y graba un INP para la competición, tras salir del
ECHO         WolfMAME se te harán una serie de preguntas para mantener el INP y 
ECHO         la puntuación por si quieres mantener un registro de los intentos y
ECHO         la evolución.
ECHO   [R] - Permite reproducir un INP ya guardado.
ECHO   [V] - Reproduce un INP y además crea un vídeo en la carpeta SNAP
ECHO   [P] - Ejecuta el juego, sin crear el INP ni las limitaciones de WolfMAME de
ECHO         cuando se graba (como pausar, usar trucos, savestates, etc).
ECHO   [C] - Cambiar la configuración del programa.		
ECHO   [0] - Salir. (Vale tanto el cero como la letra O)		
ECHO.
PAUSE

GOTO :EOF

:: CONFIGURACIÓN ==============================================================
:LNSConfig

:: Variable usada como intermediaria para introducir los valores
SET $LNSConfInput=
CLS

ECHO --------------------
ECHO CONFIGURANDO LNSComp
ECHO --------------------
ECHO.
ECHO NOTAS:
ECHO   - Procura no usar símbolos especiales de los .bat como: ^| ^< ^> ^& ^" ^^
ECHO   - Dejar vacío un campo mantiene su valor anterior. Aunque si
ECHO     ya estaba anteriormente vacío se te volverá a repreguntar.
ECHO.
ECHO.
ECHO Introduce tu nombre de usuario en el foro, sirve para identificar al creador
ECHO   de las partidas cuando se conservan y diferenciarlas si más personas usan
ECHO   el mismo ordenador.
ECHO.
:LNSConfigUsuario
SET /p "$LNSConfInput=USUARIO (%$LNSJugador%): " || Set $LNSConfInput=%$LNSJugador%
IF NOT DEFINED $LNSConfInput GOTO :LNSConfigUsuario 
SET $LNSJugador=%$LNSConfInput%
ECHO.
ECHO.
ECHO.
ECHO Ahora configuraremos los 3 juegos y usan 2 valores:
ECHO   CLAVE: Es el nombre clave del juego usado por MAME del juego. 
ECHO     Dicho de otro modo, el nombre del fichero .zip (sin la extensión).
ECHO     Por ejemplo, para "Street Figther II" la clave es "sf2"
ECHO   NOMBRE: Nombre completo del juego que se mostrará en el menú y otros lugares.
ECHO     (Recuerda no usar ^| ^< ^> ^& ^" ^^)
ECHO.
:LNSConfigJuegoFichero1
SET /p "$LNSConfInput=CLAVE DEL JUEGO 1 (%$LNSFichero1%): " || Set $LNSConfInput=%$LNSFichero1%
IF NOT DEFINED $LNSConfInput GOTO :LNSConfigJuegoFichero1 
SET $LNSFichero1=%$LNSConfInput%
:LNSConfigJuegoNombre1
SET /p "$LNSConfInput=NOMBRE DEL JUEGO 1 (%$LNSJuego1%): " || Set $LNSConfInput=%$LNSJuego1%
IF NOT DEFINED $LNSConfInput GOTO :LNSConfigJuegoNombre1 
SET $LNSJuego1=%$LNSConfInput%
ECHO.
:LNSConfigJuegoFichero2
SET /p "$LNSConfInput=CLAVE DEL JUEGO 2 (%$LNSFichero2%): " || Set $LNSConfInput=%$LNSFichero2%
IF NOT DEFINED $LNSConfInput GOTO :LNSConfigJuegoFichero2 
SET $LNSFichero2=%$LNSConfInput%
:LNSConfigJuegoNombre2
SET /p "$LNSConfInput=NOMBRE DEL JUEGO 2 (%$LNSJuego2%): " || Set $LNSConfInput=%$LNSJuego2%
IF NOT DEFINED $LNSConfInput GOTO :LNSConfigJuegoNombre2 
SET $LNSJuego2=%$LNSConfInput%
ECHO.
:LNSConfigJuegoFichero3
SET /p "$LNSConfInput=CLAVE DEL JUEGO 3 (%$LNSFichero3%): " || Set $LNSConfInput=%$LNSFichero3%
IF NOT DEFINED $LNSConfInput GOTO :LNSConfigJuegoFichero3 
SET $LNSFichero3=%$LNSConfInput%
:LNSConfigJuegoNombre3
SET /p "$LNSConfInput=NOMBRE DEL JUEGO 3 (%$LNSJuego3%): " || Set $LNSConfInput=%$LNSJuego3%
IF NOT DEFINED $LNSConfInput GOTO :LNSConfigJuegoNombre3 
SET $LNSJuego3=%$LNSConfInput%
ECHO.
ECHO.
ECHO.
ECHO Fecha final del campeonato, tan solo es un recordatorio sin más.
ECHO.
SET /p "$LNSConfInput=FIN DEL CAMPEONATO (%$LNSFechaFin%): " || Set $LNSConfInput=%$LNSFechaFin%
SET $LNSFechaFin=%$LNSConfInput%
ECHO.
ECHO.
ECHO.
ECHO Ejecutable de (Wolf)MAME a usar. Recuerda que debe encontrarse en el mismo
ECHO   directorio que este archivo Batch
ECHO.
:LNSConfigEjecutable
SET /p "$LNSConfInput=EJECUTABLE (Wolf)MAME (%$LNSEjecutable%): " || Set $LNSConfInput=%$LNSEjecutable%
IF NOT DEFINED $LNSConfInput GOTO :LNSConfigEjecutable 
SET $LNSEjecutable=%$LNSConfInput%

:LNSConfigEnd
:: Limpiando la variable usada como intermediaria para introducir los valores
SET $LNSConfInput=

:: Guardando la configuración en el archivo
:: SET $LNS> "%$LNSConfig%" es mas sencillo pero hay que renombrar las
::   variables que no se quieran guardar en el fichero (o al reves)

ECHO $LNSJugador=%$LNSJugador%> "%$LNSConfig%"
ECHO $LNSFichero1=%$LNSFichero1%>> "%$LNSConfig%"
ECHO $LNSJuego1=%$LNSJuego1%>> "%$LNSConfig%"
ECHO $LNSFichero2=%$LNSFichero2%>> "%$LNSConfig%"
ECHO $LNSJuego2=%$LNSJuego2%>> "%$LNSConfig%"
ECHO $LNSFichero3=%$LNSFichero3%>> "%$LNSConfig%"
ECHO $LNSJuego3=%$LNSJuego3%>> "%$LNSConfig%"
ECHO $LNSFechaFin=%$LNSFechaFin%>> "%$LNSConfig%"
ECHO $LNSEjecutable=%$LNSEjecutable%>> "%$LNSConfig%"

GOTO :EOF

:: CREAR INP ==================================================================
:LNSCrearINP
:: Necesita:
:: · $1 = Nombre clave del juego en MAME (El nombre del fichero sin extensión)
:: · $2 = OPCIONAL: Nombre completo del juego
SETLOCAL
SET $LNSFichAct=%~1
SET $LNSJuegAct=%~2

CLS
ECHO -------------
ECHO GRABANDO INP: %$LNSJuegAct%
ECHO -------------
ECHO.

IF NOT DEFINED $LNSFichAct (
  ECHO ERROR - LNSCrearINP: No se ha definido el fichero del juego.
  PAUSE
  GOTO LNSCrearINPEnd
)

CALL :BorrarNVRAM "%$LNSFichAct%"

ECHO.
ECHO EJECUTANDO... %$LNSFichAct%
ECHO -------------
:: Además tomamos la hora inicial y final para las estadísticas
SET $LNSFecha1=%date%
SET $LNSTiempo1=%time:~0,8%

"%$LNSEjecutable%" %$LNSFichAct% -input_directory inp -afs -throttle -speed 1 -rec %$LNSFichAct%.inp

SET $LNSTiempo2=%time:~0,8%
SET $LNSFecha2=%date%

ECHO.
CALL :RestaurarNVRAM "%$LNSFichAct%"


:: HACK: Si los números comienzan por 0 el CMD supone que se trata de un número
::   octal, dando error si ve un 08 o 09 así que lo eliminamos.
::   Por otra parte, en verdad las horas en vez de un 0 tienen un espacio,
::   pero no es tan problemático, así que no lo compruebo.

SET $LNSDia1=%$LNSFecha1:~0,2%
if "%$LNSDia1:~0,1%" == "0" SET $LNSDia1=%$LNSDia1:~1,1%
SET $LNSHora1=%$LNSTiempo1:~0,2%
if "%$LNSHora1:~0,1%" == "0" SET $LNSHora1=%$LNSHora1:~1,1%
SET $LNSMinuto1=%$LNSTiempo1:~3,2%
if "%$LNSMinuto1:~0,1%" == "0" SET $LNSMinuto1=%$LNSMinuto1:~1,1%
SET $LNSSeg1=%$LNSTiempo1:~6,2%
if "%$LNSSeg1:~0,1%" == "0" SET $LNSSeg1=%$LNSSeg1:~1,1%

SET $LNSDia2=%$LNSFecha2:~0,2%
if "%$LNSDia2:~0,1%" == "0" SET $LNSDia2=%$LNSDia2:~1,1%
SET $LNSHora2=%$LNSTiempo2:~0,2%
if "%$LNSHora2:~0,1%" == "0" SET $LNSHora2=%$LNSHora2:~1,1%
SET $LNSMinuto2=%$LNSTiempo2:~3,2%
if "%$LNSMinuto2:~0,1%" == "0" SET $LNSMinuto2=%$LNSMinuto2:~1,1%
SET $LNSSeg2=%$LNSTiempo2:~6,2%
if "%$LNSSeg2:~0,1%" == "0" SET $LNSSeg2=%$LNSSeg2:~1,1%

:: A fin de mes, siempre que la partida empiece dos o más días antes del
::   fin del mes y no dure más de un mes...
IF %$LNSDia1% GTR %$LNSDia2% SET /a $LNSDia2=%$LNSDia2%+%$LNSDia1%

:: Hipercálculo del tiempo
SET /a $LNSDiff=(%$LNSSeg2% - %$LNSSeg1%) + ((%$LNSMinuto2% - %$LNSMinuto1%) * 60) + ((%$LNSHora2% - %$LNSHora1%) * 3600) + ((%$LNSDia2% - %$LNSDia1%) * 86400)

:: Si se está jugando menos de 60 segundos no contar el intento,
::   por si nos hemos equivocado de juego y tal.
IF %$LNSDiff% LSS 60 (
  ECHO.
  ECHO La partida ha durado menos de 60 segundos, no será contabilizada.
  ECHO Aunque seguirá en inp\%$LNSFichAct%.inp hasta que comiences otra.
  ECHO.
  PAUSE
  GOTO LNSCrearINPEnd
)

ECHO.
ECHO ESTADÍSTICAS
ECHO ------------
ECHO La partida comenzó el %$LNSFecha1% a las %$LNSTiempo1%
ECHO   y duró %$LNSDiff% segundos.
ECHO.
ECHO Introduce la puntuación conseguida o el tiempo (frames o segundos), puedes
ECHO   dejarlo vacío si has abortado el intento.
SET $LNSPuntos=
SET /p $LNSPuntos="Puntuación: "

:: Creamos el fichero de estadísticas si no existe
IF NOT EXIST "%$LNSFichAct%.csv" ECHO "Inicio","Segundos","Puntos"> "%$LNSFichAct%.csv"
:: Añadimos la línea a la tabla
ECHO %$LNSFecha1% %$LNSTiempo1%,%$LNSDiff%,%$LNSPuntos%>> "%$LNSFichAct%.csv"

ECHO.
ECHO GUARDANDO PARTIDA... inp\%$LNSFichAct%.inp
ECHO --------------------
ECHO La partida seguirá en inp\%$LNSFichAct%.inp hasta que comiences otra al
ECHO   mismo juego, pero si la conservas se copiará en otro fichero que no será 
ECHO   reescrito.
ECHO.
CHOICE /c:SN  /m "¿Quieres conservar la partida"
IF ERRORLEVEL 2 GOTO LNSCrearINPEnd
IF ERRORLEVEL 1 GOTO LNSCrearINPGrabar

:LNSCrearINPCambId
ECHO.
ECHO Partidas encontradas:
dir "inp\%$LNSFichAct% *.*" /B 
ECHO.
ECHO Puntos=%$LNSPuntos%
SET $LNSPuntos=
SET /p $LNSPuntos=Introduzca otro identificador que no exista:
GOTO LNSCrearINPGrabar

:LNSCrearINPGrabar
:: Comprobando que no existe ya...
IF EXIST "inp\%$LNSFichAct% - %$LNSJugador% - %$LNSPuntos%.inp" (
  ECHO.
  ECHO inp\%$LNSFichAct% - %$LNSJugador% - %$LNSPuntos%.inp ya existe
  ECHO Elija otro identificador por favor.
  GOTO LNSCrearINPCambId
)  

copy /B "inp\%$LNSFichAct%.inp" "inp\%$LNSFichAct% - %$LNSJugador% - %$LNSPuntos%.inp"
:: TODO: Detectar errores, pero hay que mirar la salida de copy
::   IF ERRORLEVEL LoQueSea...
ECHO La partida se ha copiado en inp\%$LNSFichAct% - %$LNSJugador% - %$LNSPuntos%.inp
ECHO.
PAUSE
GOTO LNSCrearINPEnd

:LNSCrearINPEnd
ENDLOCAL
GOTO :EOF

:: REPRODUCIR INP ==================================================================
:LNSReprINP
:: Necesita:
:: · $1 = Nombre clave del juego en MAME (El nombre del fichero sin extensión)
:: · $2 = OPCIONAL: Nombre completo del juego
SETLOCAL
SET $LNSFichAct=%~1
SET $LNSJuegAct=%~2

CLS
ECHO -----------------
ECHO REPRODUCIENDO INP: %$LNSJuegAct%
ECHO -----------------
ECHO.

IF NOT DEFINED $LNSFichAct (
  ECHO ERROR - LNSReprINP: No se ha definido el fichero del juego.
  PAUSE
  GOTO LNSReprINPEnd
)

CALL :BorrarNVRAM "%$LNSFichAct%"

ECHO.
ECHO SELECCIONE FICHERO A REPRODUCIR
ECHO -------------------------------

CALL :SelecFichero "inp\%$LNSFichAct%*.inp"
IF NOT DEFINED $SubSFFichero (
  ECHO ERROR - LNSReprINP: No se ha elegido un fichero INP.
  PAUSE
  GOTO LNSReprINPEnd
)
:: Quitamos el directorio porque MAME da error
SET $SubSFFichero=%$SubSFFichero:~4%

ECHO.
ECHO EJECUTANDO... %$LNSFichAct% : %$SubSFFichero%
ECHO -------------
"%$LNSEjecutable%" %$LNSFichAct% -input_directory inp -afs -throttle -speed 1 -pb "%$SubSFFichero%" -inpview 1 -inplayout standard
PAUSE

CALL :RestaurarNVRAM "%$LNSFichAct%"

:LNSReprINPEnd
ENDLOCAL

GOTO :EOF

:: CREAR AVI ==================================================================
:LNSCrearAVI
:: Necesita:
:: · $1 = Nombre clave del juego en MAME (El nombre del fichero sin extensión)
:: · $2 = OPCIONAL: Nombre completo del juego
SETLOCAL
SET $LNSFichAct=%~1
SET $LNSJuegAct=%~2

CLS
ECHO ------------
ECHO CREANDO AVI: %$LNSJuegAct%
ECHO ------------
ECHO.

IF NOT DEFINED $LNSFichAct (
  ECHO ERROR - LNSCrearAVIEnd: No se ha definido el fichero del juego.
  PAUSE
  GOTO LNSCrearAVI
)

CALL :BorrarNVRAM "%$LNSFichAct%"

ECHO.
ECHO SELECCIONE FICHERO A REPRODUCIR
ECHO -------------------------------

CALL :SelecFichero "inp\%$LNSFichAct%*.inp"
IF NOT DEFINED $SubSFFichero (
  ECHO ERROR - LNSCrearAVIEnd: No se ha elegido un fichero INP.
  PAUSE
  GOTO LNSCrearAVIEnd
)
:: Quitamos el directorio porque MAME da error y la extension para nombrar el AVI
SET $SubSFFichero=%$SubSFFichero:~4,-4%

ECHO.
ECHO EJECUTANDO... %$LNSFichAct% : %$SubSFFichero%
ECHO -------------
"%$LNSEjecutable%" %$LNSFichAct% -input_directory inp -noafs -fs 0 -nothrottle -pb "%$SubSFFichero%.inp" -exit_after_playback -aviwrite "%$SubSFFichero%.avi"
PAUSE

CALL :RestaurarNVRAM "%$LNSFichAct%"

:LNSCrearAVIEnd
ENDLOCAL

GOTO :EOF

:: PRACTICAR ==================================================================
:LNSPracticar
:: Necesita:
:: · $1 = Nombre clave del juego en MAME (El nombre del fichero sin extensión)
:: · $2 = OPCIONAL: Nombre completo del juego
SETLOCAL
SET $LNSFichAct=%~1
SET $LNSJuegAct=%~2

CLS
ECHO ------------
ECHO PRACTICANDO: %$LNSJuegAct%
ECHO ------------
ECHO.

IF NOT DEFINED $LNSFichAct (
  ECHO ERROR - LNSReprINP: No se ha definido el fichero del juego.
  PAUSE
  GOTO LNSPracticarEnd
)

ECHO.
ECHO EJECUTANDO... %$LNSFichAct% : %$SubSFFichero%
ECHO -------------
"%$LNSEjecutable%" %$LNSFichAct% 
PAUSE

:LNSPracticarEnd
ENDLOCAL

GOTO :EOF

:: ERROR NO CMDEXT ============================================================
:BatchErrorNOCMDEXT
ECHO.
ECHO ERROR: No fue posible SETLOCAL EnableExtensions
ECHO on
@EXIT /b 

:: SALIDA DEL BATCH ===========================================================
:BatchEnd
:: LLamar con GOTO BatchEnd puesto que termina...
:: Eliminando variables, reactivando el eco.
ENDLOCAL
ECHO on
@EXIT /b
