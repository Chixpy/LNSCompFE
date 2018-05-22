unit ufrLNSCompFE;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, ActnList, IniPropStorage, Buttons, StdCtrls,
  LazFileUtils, StrUtils,
  // Misc units
  uVersionSupport,
  // CHX units
  uCHXStrUtils,
  // CHX forms
  ufrCHXForm, ufCHXAbout,
  // CHX frames
  ufCHXImgListPreview,
  // LNSCompFE classes
  ucLNSCFEConfig,
  // LNSCompFE frames
  ufLNSCFEConfig;

type

  { TfrmLNSCompFE }

  TfrmLNSCompFE = class(TfrmCHXForm)
    actEditarConfig: TAction;
    actGrabarAVI: TAction;
    actGrabarINP: TAction;
    actReproducirINP: TAction;
    actProbarJuego: TAction;
    ActionList: TActionList;
    bConfig: TBitBtn;
    bGrabarAVI: TBitBtn;
    bJugar: TBitBtn;
    bProbar: TBitBtn;
    bReproducir: TBitBtn;
    eNick: TEdit;
    ilActions: TImageList;
    iLogo: TImage;
    lMAMEExe: TLabel;
    lNick: TLabel;
    OpenDialog: TOpenDialog;
    pBottom: TPanel;
    pMain: TPanel;
    pNick: TPanel;
    pRight: TPanel;
    pTop: TPanel;
    rgbJuegos: TRadioGroup;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    procedure actEditarConfigExecute(Sender: TObject);
    procedure actGrabarAVIExecute(Sender: TObject);
    procedure actGrabarINPExecute(Sender: TObject);
    procedure actProbarJuegoExecute(Sender: TObject);
    procedure actReproducirINPExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure iLogoClick(Sender: TObject);
    procedure rgbJuegosResize(Sender: TObject);
    procedure rgbJuegosSelectionChanged(Sender: TObject);

  private
    FConfig: cLNSCFEConfig;
    FConfigFile: string;
    FDIFFFolder: string;
    FHIFolder: string;
    FImageExt: TStringList;
    FImageList: TStringList;
    FImagesFolder: string;
    FImpPreview: TfmCHXImgListPreview;
    FINPFolder: string;
    FJuego: string;
    FMAMEExe: string;
    FNVRAMFolder: string;
    procedure SetConfigFile(const aConfigFile: string);
    procedure SetDIFFFolder(const aDIFFFolder: string);
    procedure SetHIFolder(const aHIFolder: string);
    procedure SetImagesFolder(const aImagesFolder: string);
    procedure SetINPFolder(const aINPFolder: string);
    procedure SetJuego(const aJuego: string);
    procedure SetMAMEExe(const aMAMEExe: string);
    procedure SetNVRAMFolder(const aNVRAMFolder: string);

  protected
    property ConfigFile: string read FConfigFile write SetConfigFile;
    //< Nombre del fichero de configuración de LNSCompFE

    property MAMEExe: string read FMAMEExe write SetMAMEExe;
    //< Ruta del ejecutable MAME
    property ImagesFolder: string read FImagesFolder write SetImagesFolder;
    //< Carperta de imágenes
    property INPFolder: string read FINPFolder write SetINPFolder;
    //< Carpeta de INP
    property HIFolder: string read FHIFolder write SetHIFolder;
    //< Carpeta de Hiscores
    property NVRAMFolder: string read FNVRAMFolder write SetNVRAMFolder;
    //< Carpeta de NVRAM
    property DIFFFolder: string read FDIFFFolder write SetDIFFFolder;
    //< Carpeta de DIFF de CHDS

    property Config: cLNSCFEConfig read FConfig;
    //< Configuración de LNSConfig

    property Juego: string read FJuego write SetJuego;
    //< Clave del juego seleccionado
    property ImageList: TStringList read FImageList;
    //< Lista de imágenes encontradas
    property ImageExt: TStringList read FImageExt;
    //< Formatos de imagen soportados

    property ImpPreview: TfmCHXImgListPreview read FImpPreview;
    //< Frame para previsualización de imágenes

    procedure ActualizarConfig;
    //< Actualiza la configuración
    procedure ActualizarMedia;
    //< Actualiza la imagen

    procedure NVRAMBackup;
    //< Crea una copia de la NVRAM y demás
    procedure CrearINP;
    //< Ejecuta MAME y crea un INP
    procedure ReproducirINP;
    //< Reproduce un INP con MAME
    procedure CrearAVI;
    //< Reproducie un INP y crea un AVI
    procedure ProbarJuego;
    //< Ejecuta un juego con MAME sin restricciones
    procedure NVRAMRestore;
    //< Restaura la NVRAM

  public

  end;

var
  frmLNSCompFE: TfrmLNSCompFE;

implementation

{$R *.lfm}

{ TfrmLNSCompFE }

procedure TfrmLNSCompFE.FormCreate(Sender: TObject);
begin
  Application.Title := Format('%0:s %1:s', [Application.Title,
    GetFileVersion]);
  ConfigFile := 'LNSCompFE.ini';

  // Título de la ventana
  Caption := Format('%0:s: %1:s', [Application.Title, 'Ventana principal']);

  // Leemos la configuración de la ventana
  LoadGUIConfig(ConfigFile);

  // Leemos la configuración del programa
  FConfig := cLNSCFEConfig.Create(Self);
  Config.DefaultFileName := ConfigFile;
  Config.LoadFromFile('');

  // Frames
  FImpPreview := TfmCHXImgListPreview.Create(self);
  ImpPreview.Align := alClient;
  ImpPreview.Parent := pRight;

  // Lista de imágenes
  FImageList := TStringList.Create;
  FImageExt := TStringList.Create;
  ImageExt.CommaText := AnsiReplaceText(AnsiReplaceText(GraphicFileMask(TGraphic), '*.', ''), ';', ',');

  // Debería ir en la ventana de configuración pero la voy a dejar en
  //   la principal
  eNick.Text := Config.Nick;

  ActualizarConfig;
end;

procedure TfrmLNSCompFE.actEditarConfigExecute(Sender: TObject);
begin
  TfmLNSCFEConfig.SimpleModalForm(Config, ConfigFile, '');

  ActualizarConfig;
end;

procedure TfrmLNSCompFE.actGrabarAVIExecute(Sender: TObject);
begin
  CrearAVI;
end;

procedure TfrmLNSCompFE.actGrabarINPExecute(Sender: TObject);
begin
  CrearINP;
end;

procedure TfrmLNSCompFE.actProbarJuegoExecute(Sender: TObject);
begin
  ProbarJuego;
end;

procedure TfrmLNSCompFE.actReproducirINPExecute(Sender: TObject);
begin
  ReproducirINP;
end;

procedure TfrmLNSCompFE.FormDestroy(Sender: TObject);
begin
  Config.Nick := eNick.Text;
  Config.SaveToFile('', False); // No borrar el contenido previo del archivo
  Config.Free;

  ImageList.Free;
  ImageExt.Free;
end;

procedure TfrmLNSCompFE.iLogoClick(Sender: TObject);
begin
  Application.CreateForm(TfrmCHXAbout, frmCHXAbout);

  frmCHXAbout.mAditional.Lines.Add('(C) 2018 Chixpy - GNU-GPL 3.0');
  frmCHXAbout.mAditional.Lines.Add('');

  frmCHXAbout.mAditional.Lines.Add('Images: ' + ImagesFolder);
  frmCHXAbout.mAditional.Lines.Add('INP: ' + INPFolder);
  frmCHXAbout.mAditional.Lines.Add('HI: ' + HIFolder);
  frmCHXAbout.mAditional.Lines.Add('NVRAM: ' + NVRAMFolder);
  frmCHXAbout.mAditional.Lines.Add('DIFF: ' + DIFFFolder);

  frmCHXAbout.ShowModal;
end;

procedure TfrmLNSCompFE.rgbJuegosResize(Sender: TObject);
var
  FontData: TFontData;
  AlturaTexto: integer;
begin
  // Definimos el número de columnas en base a la cantidad de items, tamaño
  //   del texto y tamaño del RadioGroup.

  AlturaTexto := rgbJuegos.Font.Height;
  // Si 0 entonces buscamos la altura por defecto
  if rgbJuegos.Font.Height = 0 then
  begin
    FontData := GetFontData(rgbJuegos.Font.Handle);
    AlturaTexto := ((FontData.Height * 72) div
      rgbJuegos.Font.PixelsPerInch) * 2;
  end;

  // Suele ser negativo por alguna razón...
  AlturaTexto := abs(AlturaTexto);

  rgbJuegos.Columns := (rgbJuegos.Items.Count div
    ((rgbJuegos.ClientHeight div AlturaTexto) + 1)) + 1;
end;

procedure TfrmLNSCompFE.rgbJuegosSelectionChanged(Sender: TObject);
begin
  if rgbJuegos.ItemIndex >= 0 then
    Juego := Config.Juegos[rgbJuegos.ItemIndex]
  else
    Juego := '';

  ActualizarMedia;
end;

procedure TfrmLNSCompFE.SetConfigFile(const aConfigFile: string);
begin
  FConfigFile := SetAsAbsoluteFile(aConfigFile, ProgramDirectory);
end;

procedure TfrmLNSCompFE.SetDIFFFolder(const aDIFFFolder: string);
begin
  FDIFFFolder := SetAsFolder(aDIFFFolder);
end;

procedure TfrmLNSCompFE.SetHIFolder(const aHIFolder: string);
begin
  FHIFolder := SetAsFolder(aHIFolder);
end;


procedure TfrmLNSCompFE.SetImagesFolder(const aImagesFolder: string);
begin
  FImagesFolder := SetAsFolder(SetAsAbsoluteFile(aImagesFolder,
    ProgramDirectory));
end;

procedure TfrmLNSCompFE.SetINPFolder(const aINPFolder: string);
begin
  FINPFolder := SetAsFolder(aINPFolder);
end;

procedure TfrmLNSCompFE.SetJuego(const aJuego: string);
begin
  if FJuego = aJuego then
    Exit;
  FJuego := aJuego;

  if Juego = '' then
  begin
    // Desactivamos botones
    actGrabarINP.Enabled := False;
    actReproducirINP.Enabled := False;
    actGrabarAVI.Enabled := False;
    actProbarJuego.Enabled := False;
  end
  else
  begin
    actGrabarINP.Enabled := True;
    actReproducirINP.Enabled := True;
    actGrabarAVI.Enabled := True;
    actProbarJuego.Enabled := True;
  end;
end;

procedure TfrmLNSCompFE.SetMAMEExe(const aMAMEExe: string);
begin
  FMAMEExe := SetAsAbsoluteFile(aMAMEExe, ProgramDirectory);
end;

procedure TfrmLNSCompFE.SetNVRAMFolder(const aNVRAMFolder: string);
begin
  FNVRAMFolder := SetAsFolder(aNVRAMFolder);
end;

procedure TfrmLNSCompFE.ActualizarConfig;

  function LeeMAMEConfig(aMAMEIni: TStringList; const Key: string): string;
  var
    i: integer;
    aLine: string;
  begin
    Result := '';

    // Buscamos Key al principio de cada línea
    i := 0;
    while (Result = '') and (i < aMAMEIni.Count) do
    begin
      aLine := Trim(aMAMEIni[i]);
      if pos(Key, aLine) = 1 then
        Result := Trim(Copy(aLine, Length(Key) + 2, MaxInt));
      Inc(i);
    end;
  end;

var
  i: integer;
  MAMEFolder: string;
  MAMEIni: TStringList;
begin
  // Limpiamos variables
  Juego := '';
  MAMEExe := '';
  MAMEFolder := '';
  INPFolder := '';
  HIFolder := '';
  NVRAMFolder := '';
  DIFFFolder := '';


  // Lista de juegos
  rgbJuegos.Items.Assign(Config.Juegos);

  if rgbJuegos.Items.Count > 0 then
    rgbJuegos.ItemIndex := 0; // Seleccionamos un juego

  rgbJuegosResize(rgbJuegos); // Recolocando items...


  // Ejecutable de MAME
  MAMEExe := Config.MAMEExe;
  // Comprobamos que existe; sino buscamos en el directorio del programa
  //   algún ejecutable...
  i := 0;
  while (not FileExistsUTF8(MAMEExe)) and (i < Config.AutoMAMEList.Count) do
  begin
    MAMEExe := Config.AutoMAMEList[i];
    Inc(i);
  end;

  // Directorio de imágenes
  ImagesFolder := Config.ImagesFolder;
  // Si no existe obtendremos el que tenga MAME por defecto luego al
  //   leer MAME.ini
  if not DirectoryExistsUTF8(ImagesFolder) then
    ImagesFolder := '';

  if not FileExistsUTF8(MAMEExe) then
  begin
    // Borrando el ejecutable
    MAMEExe := '';
    lMAMEExe.Caption := 'No se encontró ningún ejecutable de MAME';
    Exit; // Nada más que hacer...
  end
  else
  begin
    MAMEFolder := SetAsFolder(ExtractFileDir(MAMEExe));
    lMAMEExe.Caption := MAMEExe;
  end;


  // Leyendo MAME.ini
  // No es un archivo INI al uso así que hay que leerlo como un archivo
  //   de texto y buscamos a mano...

  if FileExistsUTF8(MAMEFolder + 'MAME.ini') then
  begin
    MAMEIni := TStringList.Create;
    try
      MAMEIni.LoadFromFile(MAMEFolder + 'MAME.ini');
      // Si el directorio de imágenes está definido a mano, no sobreescribirlo.
      if ImagesFolder = '' then
        ImagesFolder := CreateAbsolutePath(LeeMAMEConfig(MAMEIni,
          'snapshot_directory'), MAMEFolder);
      INPFolder := CreateAbsolutePath(LeeMAMEConfig(MAMEIni,
        'input_directory'), MAMEFolder);
      NVRAMFolder := CreateAbsolutePath(LeeMAMEConfig(MAMEIni,
        'nvram_directory'), MAMEFolder);
      DIFFFolder := CreateAbsolutePath(LeeMAMEConfig(MAMEIni,
        'diff_directory'), MAMEFolder);
    finally
      MAMEIni.Free;
    end;
  end;

  // No se han definido, ponemos la configuración por defecto
  if ImagesFolder = '' then
    ImagesFolder := CreateAbsolutePath('snap', MAMEFolder);
  if INPFolder = '' then
    INPFolder := CreateAbsolutePath('inp', MAMEFolder);
  if NVRAMFolder = '' then
    NVRAMFolder := CreateAbsolutePath('nvram', MAMEFolder);
  if DIFFFolder = '' then
    DIFFFolder := CreateAbsolutePath('diff', MAMEFolder);

  // La carpeta HI está definida en el código del plugin como constante
  HIFolder := CreateAbsolutePath('hi', MAMEFolder);
end;

procedure TfrmLNSCompFE.ActualizarMedia;
var
  i: Integer;
  aFile: string;
begin
  ImpPreview.StrList := nil;
  ImageList.Clear;

  if (Juego = '') or (ImagesFolder = '') then Exit;

  // Buscamos las imágenes del juego
  // 1.- <DirImages>\<Juego>.mext

    i := 0;
    while i < ImageExt.Count do
    begin
      aFile := ImageExt[i];
      if (aFile <> '') and (aFile[1] <> ExtensionSeparator) then
        aFile := ExtensionSeparator + aFile;
      aFile := ImagesFolder + Juego + aFile;
      if FileExistsUTF8(aFile) then
        ImageList.Add(aFile);
      Inc(i);
    end;

  // 2.- <DirImages>\<Juego>\*.mext

   FindAllFiles(ImageList, ImagesFolder + SetAsFolder(Juego),
    FileMaskFromStringList(ImageExt), True);

  ImpPreview.StrList := ImageList;
end;

procedure TfrmLNSCompFE.NVRAMBackup;
var
  aFile: string;
begin
  if Juego = '' then
    Exit;

  // Se presupone que hemos la configuración de MAME
  // Renombramos los archivos

  aFile := HIFolder + Juego;
  if FileExistsUTF8(aFile + '.hi') then
    RenameFileUTF8(aFile + '.hi', aFile + '.hi.bak');
  if DirectoryExistsUTF8(aFile) then
    RenameFileUTF8(aFile, aFile + '.bak');

  aFile := NVRAMFolder + Juego;
  if FileExistsUTF8(aFile + '.nv') then
    RenameFileUTF8(aFile + '.nv', aFile + '.nv.bak');
  if DirectoryExistsUTF8(aFile) then
    RenameFileUTF8(aFile, aFile + '.bak');

  aFile := DIFFFolder + Juego;
  if FileExistsUTF8(aFile + '.dif') then
    RenameFileUTF8(aFile + '.dif', aFile + '.dif.bak');
  if DirectoryExistsUTF8(aFile) then
    RenameFileUTF8(aFile, aFile + '.bak');

end;

procedure TfrmLNSCompFE.CrearINP;
var
  MAMEFolder, CurrFolder: string;
begin
  if Juego = '' then
    Exit;

  MAMEFolder := ExtractFileDir(MAMEExe);
  CurrFolder := GetCurrentDirUTF8;

  if MAMEFolder <> '' then
    SetCurrentDirUTF8(MAMEFolder);

  NVRAMBackup;

  ExecuteProcess(MAMEExe, Juego + ' -afs -throttle -speed 1 -rec ' +
    Juego + '.inp');

  NVRAMRestore;

  if MAMEFolder <> '' then
    SetCurrentDirUTF8(CurrFolder);
end;

procedure TfrmLNSCompFE.ReproducirINP;
var
  MAMEFolder, CurrFolder, Partida: string;
begin
  //if rgbJuegos.ItemIndex = -1 then
  //  Exit;

  //MAMEFolder := ExtractFileDir(MAMEExe);
  //if MAMEFolder <> '' then
  //  chdir(MAMEFolder);

  //Juego := Config.Juegos[rgbJuegos.ItemIndex];
  //// Partida no puede contener el directorio
  //Partida := ;

  //NVRAMBackup;

  ////"%$LNSEjecutable%" %$LNSFichAct% -input_directory inp -afs -throttle
  ////   -speed 1 -pb "%$SubSFFichero%" -inpview 1 -inplayout standard
  //ExecuteProcess(MAMEExe, Juego + ' -input_directory inp -afs -throttle' +
  //  ' -speed 1 -pb "' + Partida + '" -inpview 1 -inplayout standard');

  //NVRAMRestore;

  //  if MAMEFolder <> '' then
  //  chdir(ProgramDirectory);
end;

procedure TfrmLNSCompFE.CrearAVI;
var
  MAMEFolder, CurrFolder, Partida: string;
begin
  //if rgbJuegos.ItemIndex = -1 then
  //  Exit;

  //MAMEFolder := ExtractFileDir(MAMEExe);
  //if MAMEFolder <> '' then
  //  chdir(MAMEFolder);
  //Juego := Config.Juegos[rgbJuegos.ItemIndex];
  //// Partida no puede contener el directorio y se le quita la extension
  //Partida := ;

  //NVRAMBackup;

  //// "%$LNSEjecutable%" %$LNSFichAct% -noafs -fs 0 -nothrottle
  ////   -pb "%$SubSFFichero%.inp" -exit_after_playback
  ////   -aviwrite "%$SubSFFichero%.avi"
  //ExecuteProcess(MAMEExe, Juego + ' -noafs -fs 0 -nothrottle -pb "' +
  //  + Partida + '.inp" -exit_after_playback -aviwrite "' + Partida +
  //  '.avi"');

  //NVRAMRestore;

  //if MAMEFolder <> '' then
  //  chdir(ProgramDirectory);
end;

procedure TfrmLNSCompFE.ProbarJuego;
var
  MAMEFolder, CurrFolder: string;
begin
  if Juego = '' then
    Exit;

  MAMEFolder := ExtractFileDir(MAMEExe);
  CurrFolder := GetCurrentDirUTF8;

  if MAMEFolder <> '' then
    SetCurrentDirUTF8(MAMEFolder);

  ExecuteProcess(MAMEExe, Juego);

  if MAMEFolder <> '' then
    SetCurrentDirUTF8(CurrFolder);
end;

procedure TfrmLNSCompFE.NVRAMRestore;
var
  aFile: string;
begin
  if Juego = '' then
    Exit;

  // Borramos primero los archivos por si previamente no exisistían
  //   y fueron creados en la sesion.

  aFile := HIFolder + Juego;
  if FileExistsUTF8(aFile + '.hi') then
    DeleteFileUTF8(aFile + '.hi');
  if FileExistsUTF8(aFile + '.hi.bak') then
    RenameFileUTF8(aFile + '.hi.bak', aFile + '.hi');
  if DirectoryExistsUTF8(aFile) then
    DeleteDirectory(aFile, False);
  if DirectoryExistsUTF8(aFile + '.bak') then
    RenameFileUTF8(aFile + '.bak', aFile);

  aFile := NVRAMFolder + Juego;
  if FileExistsUTF8(aFile + '.nv') then
    DeleteFileUTF8(aFile + '.nv');
  if FileExistsUTF8(aFile + '.nv.bak') then
    RenameFileUTF8(aFile + '.nv.bak', aFile + '.nv');
  if DirectoryExistsUTF8(aFile) then
    DeleteDirectory(aFile, False);
  if DirectoryExistsUTF8(aFile + '.bak') then
    RenameFileUTF8(aFile + '.bak', aFile);

  aFile := DIFFFolder + Juego;
  if FileExistsUTF8(aFile + '.dif') then
    DeleteFileUTF8(aFile + '.dif');
  if FileExistsUTF8(aFile + '.dif.bak') then
    RenameFileUTF8(aFile + '.dif.bak', aFile + '.dif');
  if DirectoryExistsUTF8(aFile) then
    DeleteDirectory(aFile, False);
  if DirectoryExistsUTF8(aFile + '.bak') then
    RenameFileUTF8(aFile + '.bak', aFile);
end;

end.
