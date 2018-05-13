@ECHO off
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
::   WinXP; pero no me hago responsable de que no funcione o cause alg£n da¤o
::   o p‚rdida de datos.
::
:: El programa est  pensado para ejecutarse desde el mismo directorio que
::   el ejecutable de (Wolf)MAME y con los directorios INP, NVRAM, DIFF,
::   HI y CFG en sus ubicaciones por defecto.
::
:: TODO: Cosas por hacer... 
::   * Cambiar la p gina de c¢digos de la consola y este archivo a UTF8;
::     (chcp 65001) No afecta para nada m s que los acentos en los mensajes,
::      pero ser¡a elegante y funcionar¡an independientemente del lenguaje
::      por defecto de Windows
::   * Usar un fichero auxiliar de config donde se definan las variables
::     principales y a¤adir un m‚todo para crearlo desde el propio Batch.
::   * Poder grabar con un estado inicial de la NVRAM, dicho de otro modo:
::     1. Guardar el estado actual.
::     2. Restaurar el estado inicial para grabar.
::        (¨D¢nde deber¡a estar guardado previamente?)
::     3. Ejecutar MAME.
::     4. Restaurar el estado actual. 
::        (o preguntar si se quiere mantener la NVRAM generada...)
::     5. Hacer una copia del estado inicial si la partida se conserva.
::        (¨D¢nde lo guardo, junto al inp?)
::     Esto implica que en CrearAVI o ReproducirINP en el paso 2
::       hay que restaurar el estado inicial correspondiente a cada partida.
::   * Poder definir un MAME que est  en otro directorio distinto al Batch...
::     (sto realmente no tengo ning£n inter‚s por hacerlo)
::     

GOTO BatchMain

:: VARIABLES PRINCIPALES ======================================================
:BatchInit
:: Aqu¡ van las variables iniciales para no tener que estar buscando en
::   el fichero.

:: Preguntamos el nombre del jugador
SET /p $LNSJugador=Escribe tus iniciales o nombre: 
:: Para que no est‚ preguntando:
::SET $LNSJugador=CHX

SET $LNSFichero1=fichero1
SET $LNSJuego1=Juego1
SET $LNSFichero2=fichero2
SET $LNSJuego2=Juego2
SET $LNSFichero3=fichero3
SET $LNSJuego3=Juego3
SET $LNSFechaFin=DD/MM/AA

SET $LNSEjecutable=mamearcade.exe

GOTO :EOF

:: COMPROBACIONES INICIALES ===================================================
:BatchMain

:: Comprobando que se pueden usar las CMDEXT
SETLOCAL EnableExtensions
>NUL ECHO & GOTO CHKCMDEXT
GOTO BatchErrorNOCMDEXT
:CHKCMDEXT
IF "~x0"=="%~x0" GOTO BatchErrorNOCMDEXT
IF "%%~x0"=="%~x0" GOTO BatchErrorNOCMDEXT
SET "CMDEXTVERSION="
:: Comprobamos si es la version 1
IF "%CMDEXTVERSION%"=="" (
  ECHO.
  ECHO Se ha detectado "Command extensions v1", el programa continuar  de
  ECHO   todas formas, pero se desconoce si funcionar  correctamente en su
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
ECHO  %date%                Fin del campeonato: %$LNSFechaFin%               %time:~0,8%
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
ECHO     [0]  - Salir                       [A] - Ayuda
ECHO  -----------------------------------------------------------------------------

CHOICE /c:123ERVP0OA > NUL
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

:: AYUDA ======================================================================
:LNSAyuda
CLS
ECHO Hola, %$LNSJugador%.
ECHO.
ECHO Veo que has encontrado la ayuda as¡ que no te voy a explicar para que sirve
ECHO   la opci¢n [A].
ECHO.
ECHO Para elegir un juego pulsa [1], [2] o [3] y se te mostrar  en el men£ el juego
ECHO   elegido.
ECHO.
ECHO Una vez has seleccionado el juego puedes realizar las siguientes acciones:
ECHO   [E] - Ejecuta el juego y graba un INP para la competici¢n, tras salir del
ECHO         WolfMAME se te har n una serie de preguntas para mantener el INP y 
ECHO         la puntuaci¢n por si quieres mantener un registro de los intentos y
ECHO         la evoluci¢n.
ECHO   [R] - Permite reproducir un INP ya guardado.
ECHO   [V] - Reproduce un INP y adem s crea un v¡deo en la carpeta SNAP
ECHO   [P] - Ejecuta el juego, sin crear el INP ni las limitaciones de WolfMAME de
ECHO         cuando se graba (como pausar, usar trucos, savestates, etc).
ECHO   [0] - Salir. (Vale tanto el cero como la letra O)		
ECHO.
PAUSE

GOTO :EOF

:: SUBRUTINAS =================================================================

:: SUB BorrarNVRAM ------------------------------------------------------------
:BorrarNVRAM
:: Necesita:
:: * $1 = Nombre de la ROM de la que hay que borrar la NVRAM.
:: Borra el directorio nvram\$1\nul.
SETLOCAL
SET $Fichero=%~1

ECHO BORRANDO NVRAM... %$Fichero%
ECHO -----------------
IF NOT DEFINED $Fichero (
  ECHO ERROR - BorrarNVRAM: No se ha definido nombre del fichero.
  PAUSE
  GOTO BorrarNVRAMEnd
)

:: No borramos cfg porque guarda la configuraci¢n de los botones...
::   ... pero ah¡ se guarda la configuraci¢n de los DIP Switches
:: IF EXIST "cfg\%$Fichero%.cfg" DEL "cfg\%$Fichero%.cfg"
IF EXIST "hi\%$Fichero%.hi" DEL "hi\%$$Fichero%.hi"
IF EXIST "hi\%$Fichero%" RD /s /q "hi\%$Fichero%"
IF EXIST "nvram\%$Fichero%.nv" DEL "nvram\%$Fichero%.nv"
IF EXIST "nvram\%$Fichero%" RD /s /q "nvram\%$Fichero%"
IF EXIST "diff\%$Fichero%.dif" DEL "diff\%$Fichero%.dif"
IF EXIST "diff\%$Fichero%" RD /s /q "diff\%$Fichero%"

:BorrarNVRAMEnd
ENDLOCAL

GOTO :EOF

:: SUB SelecFichero -----------------------------------------------------------
:SelecFichero
:: Necesita:
:: ú $1 = Directorio y filtro para listar los ficheros
:: Devuelve:
:: ú %$SubSFFichero% = Nombre del fichero elegido.
:: Muestra un listado de archivos y permite elegir uno.
::   En caso de error %$SubSFFichero% no estar  definida.
SETLOCAL EnableDelayedExpansion
SET $SubSFFichero=
SET $SubSFFiltro=%~1

:: ERROR no se ha definido el filtro
IF NOT DEFINED $SubSFFiltro (
  ECHO ERROR - SelecFichero: No se ha definido el filtro de b£squeda.
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
  ECHO No se ha encontrado ning£n archivo.
  GOTO SelecFicheroEnd
)

SET /P $INPSelec="Seleccione un fichero: " 
IF NOT DEFINED $INPFich%$INPSelec% (
   ECHO ­N£mero inv lido seleccionado! 
:: Pausa controlada por quien lo llame - PAUSE   
   GOTO SelecFicheroEnd
)

SET $SubSFFichero=!$INPFich%$INPSelec%!

:SelecFicheroEnd
ENDLOCAL & SET $SubSFFichero=%$SubSFFichero%

GOTO :EOF

:: CREAR INP ==================================================================
:LNSCrearINP
:: Necesita:
:: ú $1 = Nombre clave del juego en MAME (El nombre del fichero sin extensi¢n)
:: ú $2 = OPCIONAL: Nombre completo del juego
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
:: Adem s tomamos la hora inicial y final para las estad¡sticas
SET $LNSFecha1=%date%
SET $LNSTiempo1=%time:~0,8%

"%LNSEjecutable%" %$LNSFichAct% -input_directory inp -afs -throttle -speed 1 -rec %$LNSFichAct%.inp

SET $LNSTiempo2=%time:~0,8%
SET $LNSFecha2=%date%

ECHO.
CALL :BorrarNVRAM "%$LNSFichAct%"


:: HACK: Si los n£meros comienzan por 0 el CMD supone que se trata de un n£mero
::   octal, dando error si ve un 08 o 09 as¡ que lo eliminamos.
::   Por otra parte, en verdad las horas en vez de un 0 tienen un espacio,
::   pero no es tan problem tico, as¡ que no lo compruebo.

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

:: A fin de mes, siempre que la partida empiece dos o m s d¡as antes del
::   fin del mes y no dure m s de un mes...
IF %$LNSDia1% GTR %$LNSDia2% SET /a $LNSDia2=%$LNSDia2%+%$LNSDia1%

:: Hiperc lculo del tiempo
SET /a $LNSDiff=(%$LNSSeg2% - %$LNSSeg1%) + ((%$LNSMinuto2% - %$LNSMinuto1%) * 60) + ((%$LNSHora2% - %$LNSHora1%) * 3600) + ((%$LNSDia2% - %$LNSDia1%) * 86400)

:: Si se est  jugando menos de 60 segundos no contar el intento,
::   por si nos hemos equivocado de juego y tal.
IF %$LNSDiff% LSS 60 (
  ECHO.
  ECHO La partida ha durado menos de 60 segundos, no ser  contabilizada.
  ECHO Aunque seguir  en inp\%$LNSFichAct%.inp hasta que comiences otra.
  ECHO.
  PAUSE
  GOTO LNSCrearINPEnd
)

ECHO.
ECHO ESTADÖSTICAS
ECHO ------------
ECHO La partida comenz¢ el %$LNSFecha1% a las %$LNSTiempo1%
ECHO   y dur¢ %$LNSDiff% segundos.
ECHO.
ECHO Introduce la puntuaci¢n conseguida o el tiempo (frames o segundos), puedes
ECHO   dejarlo vac¡o si has abortado el intento.
SET $LNSPuntos=
SET /p $LNSPuntos="Puntuaci¢n: "

:: Creamos el fichero de estad¡sticas si no existe
IF NOT EXIST "%$LNSFichAct%.csv" ECHO "Inicio","Segundos","Puntos" > "%$LNSFichAct%.csv"
:: A¤adimos la l¡nea a la tabla
ECHO %$LNSFecha1% %$LNSTiempo1%,%$LNSDiff%,%$LNSPuntos% >> "%$LNSFichAct%.csv"

ECHO.
ECHO GUARDANDO PARTIDA... inp\%$LNSFichAct%.inp
ECHO --------------------
ECHO La partida seguir  en inp\%$LNSFichAct%.inp hasta que comiences otra al
ECHO   mismo juego, pero si la conservas se copiar  en otro fichero que no ser  
ECHO   reescrito.
ECHO.
CHOICE /c:SN  /m "¨Quieres conservar la partida"
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
:: ú $1 = Nombre clave del juego en MAME (El nombre del fichero sin extensi¢n)
:: ú $2 = OPCIONAL: Nombre completo del juego
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
"%LNSEjecutable%" %$LNSFichAct% -pb "%$SubSFFichero%" -inpview 1 -inplayout standard
PAUSE

CALL :BorrarNVRAM "%$LNSFichAct%"

:LNSReprINPEnd
ENDLOCAL

GOTO :EOF

:: CREAR AVI ==================================================================
:LNSCrearAVI
:: Necesita:
:: ú $1 = Nombre clave del juego en MAME (El nombre del fichero sin extensi¢n)
:: ú $2 = OPCIONAL: Nombre completo del juego
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
"%LNSEjecutable%" %$LNSFichAct% -noafs -fs 0 -nothrottle -pb "%$SubSFFichero%.inp" -exit_after_playback -aviwrite "%$SubSFFichero%.avi"
PAUSE

CALL :BorrarNVRAM "%$LNSFichAct%"

:LNSCrearAVIEnd
ENDLOCAL

GOTO :EOF

:: PRACTICAR ==================================================================
:LNSPracticar
:: Necesita:
:: ú $1 = Nombre clave del juego en MAME (El nombre del fichero sin extensi¢n)
:: ú $2 = OPCIONAL: Nombre completo del juego
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
"%LNSEjecutable%" %$LNSFichAct% 
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