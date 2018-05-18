unit ufrLNSCompFE;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, ActnList, IniPropStorage, Buttons, StdCtrls,
  LazFileUtils,
  // Misc units
  uVersionSupport,
  // CHX units
  uCHXStrUtils,
  // CHX forms
  ufrCHXForm,
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
    iLogo: TImage;
    lNick: TLabel;
    pBottom: TPanel;
    pMain: TPanel;
    pNick: TPanel;
    pRight: TPanel;
    pTop: TPanel;
    rgbJuegos: TRadioGroup;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    procedure actEditarConfigExecute(Sender: TObject);
    procedure actProbarJuegoExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rgbJuegosClick(Sender: TObject);

  private
    FConfig: cLNSCFEConfig;
    FConfigFile: string;
    FImagesFolder: string;
    FImpPreview: TfmCHXImgListPreview;
    FMAMEExe: string;
    procedure SetConfigFile(const aConfigFile: string);
    procedure SetImagesFolder(const aImagesFolder: string);
    procedure SetMAMEExe(const aMAMEExe: string);

  protected
    property ConfigFile: string read FConfigFile write SetConfigFile;
    property MAMEExe: string read FMAMEExe write SetMAMEExe;
    property ImagesFolder: string read FImagesFolder write SetImagesFolder;

    property Config: cLNSCFEConfig read FConfig;

    property ImpPreview: TfmCHXImgListPreview read FImpPreview;

    procedure ActualizarConfig;
    procedure ActualizarMedia;

    procedure NVRAMBackup;
    procedure CrearINP;
    procedure ReproducirINP;
    procedure CrearAVI;
    procedure ProbarJuego;
    procedure NVRAMRestore;

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

  LoadGUIConfig(ConfigFile);

  FConfig := cLNSCFEConfig.Create(Self);
  Config.DefaultFileName := ConfigFile;
  Config.LoadFromFile('');

  // Frames
  FImpPreview := TfmCHXImgListPreview.Create(self);
  ImpPreview.Align := alClient;
  ImpPreview.Parent := pRight;

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

procedure TfrmLNSCompFE.actProbarJuegoExecute(Sender: TObject);
begin
  ProbarJuego;
end;

procedure TfrmLNSCompFE.FormDestroy(Sender: TObject);
begin
  Config.Nick := eNick.Text;
  Config.SaveToFile('', False); // No borrar el contenido previo del archivo
  Config.Free;
end;

procedure TfrmLNSCompFE.rgbJuegosClick(Sender: TObject);
begin
  ActualizarMedia;
end;

procedure TfrmLNSCompFE.SetConfigFile(const aConfigFile: string);
begin
  FConfigFile := SetAsAbsoluteFile(aConfigFile, ProgramDirectory);
end;

procedure TfrmLNSCompFE.SetImagesFolder(const aImagesFolder: string);
begin
  FImagesFolder := SetAsAbsoluteFile(SetAsFolder(aImagesFolder),
    ProgramDirectory);
end;

procedure TfrmLNSCompFE.SetMAMEExe(const aMAMEExe: string);
begin
  FMAMEExe := SetAsAbsoluteFile(aMAMEExe, ProgramDirectory);
end;

procedure TfrmLNSCompFE.ActualizarConfig;
var
  i: integer;
begin
  rgbJuegos.Items.Assign(Config.Juegos);
  if rgbJuegos.Items.Count > 0 then
    rgbJuegos.ItemIndex := 0;

  MAMEExe := Config.MAMEExe;
  // Comprobar que exite; sino buscar en el directorio del programa
  //   algún ejecutable...
  i := 0;
  while (not FileExistsUTF8(MAMEExe)) and (i < Config.AutoMAMEList.Count) do
  begin
    MAMEExe := Config.AutoMAMEList[i];
    Inc(i);
  end;

  ImagesFolder := Config.ImagesFolder;
  { TODO: Si no existe el directorio obtener la configuración del
    MAME.ini... si existe.

  if not DirectoryExistsUTF8(ImagesFolder) do
  begin

  end;
  }
end;

procedure TfrmLNSCompFE.ActualizarMedia;
begin

end;

procedure TfrmLNSCompFE.NVRAMBackup;
begin

end;

procedure TfrmLNSCompFE.CrearINP;
var
  MAMEFolder, Juego: string;
begin
  if rgbJuegos.ItemIndex = -1 then
    Exit;

  MAMEFolder := ExtractFileDir(MAMEExe);
  if MAMEFolder <> '' then
    chdir(MAMEFolder);

  Juego := Config.Juegos[rgbJuegos.ItemIndex];

  NVRAMBackup;

  // "%$LNSEjecutable%" %$LNSFichAct% -input_directory inp
  //   -afs -throttle -speed 1 -rec %$LNSFichAct%.inp
  ExecuteProcess(MAMEExe, Juego + ' -input_directory inp -afs -throttle' +
    ' -speed 1 -rec ' + Juego + '.inp');

  NVRAMRestore;

    if MAMEFolder <> '' then
    chdir(ProgramDirectory);
end;

procedure TfrmLNSCompFE.ReproducirINP;
var
  MAMEFolder, Juego, Partida: string;
begin
  if rgbJuegos.ItemIndex = -1 then
    Exit;

  MAMEFolder := ExtractFileDir(MAMEExe);
  if MAMEFolder <> '' then
    chdir(MAMEFolder);

  Juego := Config.Juegos[rgbJuegos.ItemIndex];
  // Partida no puede contener el directorio
  Partida :=

  NVRAMBackup;

  //"%$LNSEjecutable%" %$LNSFichAct% -input_directory inp -afs -throttle
  //   -speed 1 -pb "%$SubSFFichero%" -inpview 1 -inplayout standard
  ExecuteProcess(MAMEExe, Juego + ' -input_directory inp -afs -throttle' +
    ' -speed 1 -pb "' + Partida + '" -inpview 1 -inplayout standard');

  NVRAMRestore;

    if MAMEFolder <> '' then
    chdir(ProgramDirectory);
end;

procedure TfrmLNSCompFE.CrearAVI;
var
  MAMEFolder: string;
  Juego: string;
begin
  if rgbJuegos.ItemIndex = -1 then
    Exit;

  MAMEFolder := ExtractFileDir(MAMEExe);
  if MAMEFolder <> '' then
    chdir(MAMEFolder);
  Juego := Config.Juegos[rgbJuegos.ItemIndex];
  // Partida no puede contener el directorio y se le quita la extension
  Partida :=

  NVRAMBackup;

  // "%$LNSEjecutable%" %$LNSFichAct% -noafs -fs 0 -nothrottle
  //   -pb "%$SubSFFichero%.inp" -exit_after_playback
  //   -aviwrite "%$SubSFFichero%.avi"
  ExecuteProcess(MAMEExe, Juego + ' -noafs -fs 0 -nothrottle -pb "' +
    + Partida + '.inp" -exit_after_playback -aviwrite "' + Partida +
    '.avi"');

  NVRAMRestore;

  if MAMEFolder <> '' then
    chdir(ProgramDirectory);
end;

procedure TfrmLNSCompFE.ProbarJuego;
var
  MAMEFolder: string;
begin
  if rgbJuegos.ItemIndex = -1 then
    Exit;

  MAMEFolder := ExtractFileDir(MAMEExe);
  if MAMEFolder <> '' then
    chdir(MAMEFolder);

  ExecuteProcess(MAMEExe, Config.Juegos[rgbJuegos.ItemIndex]);

  if MAMEFolder <> '' then
    chdir(ProgramDirectory);
end;

procedure TfrmLNSCompFE.NVRAMRestore;
begin

end;

end.
