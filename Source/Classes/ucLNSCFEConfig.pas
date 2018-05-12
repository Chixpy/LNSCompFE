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
  krsImagesFolder = 'ImagesFolder';
  krsJuegos = 'Juegos';

type

  { cLNSCFEConfig }

  cLNSCFEConfig = class(caCHXConfig)
  private
    FImagesFolder: string;
    FJuegos: TStringList;
    FMAMEExe: string;
    procedure SetImagesFolder(const aImagesFolder: string);
    procedure SetMAMEExe(const aMAMEExe: string);

  public
    procedure ResetDefaultConfig; override;

    procedure LoadFromIni(aIniFile: TMemIniFile); override;
    procedure SaveToIni(aIniFile: TMemIniFile); override;

    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

  published
    property MAMEExe: string read FMAMEExe write SetMAMEExe;
    {< Ruta del ejecutable de MAME. }

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

procedure cLNSCFEConfig.SetImagesFolder(const aImagesFolder: string);
begin
  FImagesFolder := SetAsFolder(aImagesFolder);
end;

procedure cLNSCFEConfig.ResetDefaultConfig;
begin
  MAMEExe := '';
  ImagesFolder := '';
  Juegos.Clear;
end;

procedure cLNSCFEConfig.LoadFromIni(aIniFile: TMemIniFile);
begin
  MAMEExe := aIniFile.ReadString(krsSeccion, krsMAMEExe, MAMEExe);
  ImagesFolder := aIniFile.ReadString(krsSeccion, krsImagesFolder, ImagesFolder);
  Juegos.CommaText := aIniFile.ReadString(krsSeccion, krsJuegos, Juegos.CommaText);
end;

procedure cLNSCFEConfig.SaveToIni(aIniFile: TMemIniFile);
begin
  aIniFile.WriteString(krsSeccion, krsMAMEExe, MAMEExe);
  aIniFile.WriteString(krsSeccion, krsImagesFolder, ImagesFolder);
  aIniFile.WriteString(krsSeccion, krsJuegos, Juegos.CommaText);
end;

constructor cLNSCFEConfig.Create(aOwner: TComponent);
begin
  // Creando la lista de juegos antes de llamar al Create de caCHXConfig,
  //   porque llama automáticamente a ResetDefaultConfig que hace uso de ella.
  FJuegos := TStringList.Create;

  inherited Create(aOwner);
end;

destructor cLNSCFEConfig.Destroy;
begin
  Juegos.Free;

  inherited Destroy;
end;

end.

