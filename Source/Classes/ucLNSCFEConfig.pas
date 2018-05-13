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

type

  { cLNSCFEConfig }

  cLNSCFEConfig = class(caCHXConfig)
  private
    FAutoMAMEList: TStringList;
    FImagesFolder: string;
    FJuegos: TStringList;
    FMAMEExe: string;
    FNick: string;
    procedure SetImagesFolder(const aImagesFolder: string);
    procedure SetMAMEExe(const aMAMEExe: string);
    procedure SetNick(const aNick: string);

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

    property ImagesFolder: string read FImagesFolder write SetImagesFolder;
    {< Carpeta donde buscar las imágenes de los juegos. }

    property Juegos: TStringList read FJuegos;

  end;

implementation

{ cLNSCFEConfig }

procedure cLNSCFEConfig.SetMAMEExe(const aMAMEExe: string);
begin
  FMAMEExe := SetAsFile(aMAMEExe);
end;

procedure cLNSCFEConfig.SetNick(const aNick: string);
begin
  if FNick = aNick then Exit;
  FNick := aNick;
end;

procedure cLNSCFEConfig.SetImagesFolder(const aImagesFolder: string);
begin
  FImagesFolder := SetAsFolder(aImagesFolder);
end;

procedure cLNSCFEConfig.ResetDefaultConfig;
begin
  Nick := '';
  MAMEExe := '';
  AutoMAMEList.CommaText := 'mamearcade.exe,wolfmame.exe,wolfmame64.exe,' +
    'wolfmame32.exe,mame.exe,mame64.exe,mame32.exe';
  ImagesFolder := '';
  Juegos.Clear;
end;

procedure cLNSCFEConfig.LoadFromIni(aIniFile: TMemIniFile);
begin
  Nick := aIniFile.ReadString(krsSeccion, krsNick, Nick);
  MAMEExe := aIniFile.ReadString(krsSeccion, krsMAMEExe, MAMEExe);
  AutoMAMEList.CommaText := aIniFile.ReadString(krsSeccion, krsAutoMAME, AutoMAMEList.CommaText); ;
  ImagesFolder := aIniFile.ReadString(krsSeccion, krsImagesFolder, ImagesFolder);
  Juegos.CommaText := aIniFile.ReadString(krsSeccion, krsJuegos, Juegos.CommaText);
end;

procedure cLNSCFEConfig.SaveToIni(aIniFile: TMemIniFile);
begin
  aIniFile.WriteString(krsSeccion, krsNick, Nick);
  aIniFile.WriteString(krsSeccion, krsMAMEExe, MAMEExe);
  aIniFile.WriteString(krsSeccion, krsAutoMAME, AutoMAMEList.CommaText); ;
  aIniFile.WriteString(krsSeccion, krsImagesFolder, ImagesFolder);
  aIniFile.WriteString(krsSeccion, krsJuegos, Juegos.CommaText);
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

