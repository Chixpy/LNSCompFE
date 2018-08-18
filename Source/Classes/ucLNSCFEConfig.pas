unit ucLNSCFEConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles,
  // CHX units
  uCHXStrUtils,
  // CHX abstracts
  uaCHXConfig;

const
  krsSeccion = 'Config';
  krsMAMEExe = 'MAMEExe';
  krsAutoMAME = 'AutoMAME';
  krsImagesFolder = 'ImagesFolder';
  krsJuegos = 'Juegos';
  krsNick = 'Nick';
  krsParGrabarINP = 'ParGrabarINP';
  krsParReprINP = 'ParReprINP';
  krsParGrabarAVI = 'ParGrabarAVI';
  krsParProbarJuego = 'ParProbarJuego';

type

  { cLNSCFEConfig }

  cLNSCFEConfig = class(caCHXConfig)
  private
    FAutoMAMEList: TStringList;
    FImagesFolder: string;
    FJuegos: TStringList;
    FMAMEExe: string;
    FNick: string;
    FParAdicGrabarAVI: string;
    FParAdicGrabarINP: string;
    FParAdicProbarJuego: string;
    FParAdicReprINP: string;
    procedure SetImagesFolder(const aImagesFolder: string);
    procedure SetMAMEExe(const aMAMEExe: string);
    procedure SetNick(const aNick: string);
    procedure SetParAdicGrabarAVI(const aParAdicGrabarAVI: string);
    procedure SetParAdicGrabarINP(const aParAdicGrabarINP: string);
    procedure SetParAdicProbarJuego(const aParAdicProbarJuego: string);
    procedure SetParAdicReprINP(const aParAdicReprINP: string);

  public
    procedure ResetDefaultConfig; override;

    procedure LoadFromIni(aIniFile: TMemIniFile); override;
    procedure SaveToIni(aIniFile: TMemIniFile); override;

    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

  published
    property Nick: string read FNick write SetNick;
    {< Ruta del ejecutable de MAME. }

    property MAMEExe: string read FMAMEExe write SetMAMEExe;
    {< Ruta del ejecutable de MAME. }

    property AutoMAMEList: TStringList read FAutoMAMEList;
    {< Lista de nombre de ejeutables MAME a buscar por defecto. }

    property ImagesFolder: string read FImagesFolder write SetImagesFolder;
    {< Carpeta donde buscar las imágenes de los juegos. }

    property Juegos: TStringList read FJuegos;
    {< Lista de claves de juegos. }

    property ParAdicGrabarINP: string read FParAdicGrabarINP
      write SetParAdicGrabarINP;
    {< Parámetros adicionales a usar cuando se graba un .INP}
    property ParAdicReprINP: string read FParAdicReprINP
      write SetParAdicReprINP;
    {< Parámetros adicionales a usar cuando se reproduce un .INP}
    property ParAdicGrabarAVI: string read FParAdicGrabarAVI
      write SetParAdicGrabarAVI;
    {< Parámetros adicionales a usar cuando se graba un .AVI}
    property ParAdicProbarJuego: string
      read FParAdicProbarJuego write SetParAdicProbarJuego;
    {< Parámetros adicionales a usar cuando se prueba un juego.}

  end;

implementation

{ cLNSCFEConfig }

procedure cLNSCFEConfig.SetMAMEExe(const aMAMEExe: string);
begin
  FMAMEExe := SetAsFile(aMAMEExe);
end;

procedure cLNSCFEConfig.SetNick(const aNick: string);
begin
  if FNick = aNick then
    Exit;
  FNick := aNick;
end;

procedure cLNSCFEConfig.SetParAdicGrabarAVI(const aParAdicGrabarAVI: string);
begin
  if FParAdicGrabarAVI = aParAdicGrabarAVI then
    Exit;
  FParAdicGrabarAVI := aParAdicGrabarAVI;
end;

procedure cLNSCFEConfig.SetParAdicGrabarINP(const aParAdicGrabarINP: string);
begin
  if FParAdicGrabarINP = aParAdicGrabarINP then
    Exit;
  FParAdicGrabarINP := aParAdicGrabarINP;
end;

procedure cLNSCFEConfig.SetParAdicProbarJuego(
  const aParAdicProbarJuego: string);
begin
  if FParAdicProbarJuego = aParAdicProbarJuego then
    Exit;
  FParAdicProbarJuego := aParAdicProbarJuego;
end;

procedure cLNSCFEConfig.SetParAdicReprINP(const aParAdicReprINP: string);
begin
  if FParAdicReprINP = aParAdicReprINP then
    Exit;
  FParAdicReprINP := aParAdicReprINP;
end;

procedure cLNSCFEConfig.SetImagesFolder(const aImagesFolder: string);
begin
  FImagesFolder := SetAsFolder(aImagesFolder);
end;

procedure cLNSCFEConfig.ResetDefaultConfig;
begin
  Nick := '';
  MAMEExe := '';
  AutoMAMEList.CommaText :=
    'mamearcade.exe,wolfmame.exe,wolfmame64.exe,' +
    'wolfmame32.exe,mame.exe,mame64.exe,mame32.exe';
  ImagesFolder := '';
  Juegos.Clear;
end;

procedure cLNSCFEConfig.LoadFromIni(aIniFile: TMemIniFile);
begin
  Nick := aIniFile.ReadString(krsSeccion, krsNick, Nick);

  MAMEExe := aIniFile.ReadString(krsSeccion, krsMAMEExe, MAMEExe);
  AutoMAMEList.CommaText :=
    aIniFile.ReadString(krsSeccion, krsAutoMAME, AutoMAMEList.CommaText);

  ImagesFolder := aIniFile.ReadString(krsSeccion, krsImagesFolder,
    ImagesFolder);
  Juegos.CommaText := aIniFile.ReadString(krsSeccion, krsJuegos,
    Juegos.CommaText);

  ParAdicGrabarINP := aIniFile.ReadString(krsSeccion, krsParGrabarINP,
    ParAdicGrabarINP);
  ParAdicReprINP := aIniFile.ReadString(krsSeccion, krsParReprINP,
    ParAdicReprINP);
  ParAdicGrabarAVI := aIniFile.ReadString(krsSeccion, krsParGrabarAVI,
    ParAdicGrabarAVI);
  ParAdicProbarJuego := aIniFile.ReadString(krsSeccion,
    krsParProbarJuego, ParAdicProbarJuego);
end;

procedure cLNSCFEConfig.SaveToIni(aIniFile: TMemIniFile);
begin
  aIniFile.WriteString(krsSeccion, krsNick, Nick);

  aIniFile.WriteString(krsSeccion, krsMAMEExe, MAMEExe);
  aIniFile.WriteString(krsSeccion, krsAutoMAME, AutoMAMEList.CommaText);

  aIniFile.WriteString(krsSeccion, krsImagesFolder, ImagesFolder);
  aIniFile.WriteString(krsSeccion, krsJuegos, Juegos.CommaText);

  aIniFile.WriteString(krsSeccion, krsParGrabarINP, ParAdicGrabarINP);
  aIniFile.WriteString(krsSeccion, krsParReprINP, ParAdicReprINP);
  aIniFile.WriteString(krsSeccion, krsParGrabarAVI, ParAdicGrabarAVI);
  aIniFile.WriteString(krsSeccion, krsParProbarJuego, ParAdicProbarJuego);
end;

constructor cLNSCFEConfig.Create(aOwner: TComponent);
begin
  // Creando la lista de juegos antes de llamar al Create de caCHXConfig,
  //   porque llama automáticamente a ResetDefaultConfig que hace uso de ella.
  FJuegos := TStringList.Create;

  FAutoMAMEList := TStringList.Create;

  inherited Create(aOwner);
end;

destructor cLNSCFEConfig.Destroy;
begin
  Juegos.Free;
  AutoMAMEList.Free;

  inherited Destroy;
end;

end.
