unit ufLNSCFEGrabarINP;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ActnList,
  // CHX frames
  ufCHXPropEditor;

type

  // Un simple record para obtener los datos del formulario, hacer una clase
  //   es excesivo...
  // Aunque usar un record implica rastear con punteros XD

  RGrabarINPDatos = record
    Segundos: integer;
    Puntuacion: string;
    Conservar: boolean;
  end;
  PGrabarINPDatos = ^RGrabarINPDatos;

  { TfmLNSCFEGrabarINP }

  TfmLNSCFEGrabarINP = class(TfmCHXPropEditor)
    ePuntuacion: TEdit;
    gbxPuntuacion: TGroupBox;
    lPuntuacion: TLabel;
    pEstadisticas: TPanel;
    pInfo: TPanel;
    rgbConservar: TRadioGroup;
  private
    FDatos: PGrabarINPDatos;
    procedure SetDatos(const aDatos: PGrabarINPDatos);

  protected
    procedure DoSaveData;

  public
    property Datos: PGrabarINPDatos read FDatos write SetDatos;

    class procedure SimpleForm(const aDatos: PGrabarINPDatos;
      const aGUIConfigIni, aGUIIconsIni: string);

    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.lfm}

{ TfmLNSCFEGrabarINP }

procedure TfmLNSCFEGrabarINP.SetDatos(const aDatos: PGrabarINPDatos);
begin
  if FDatos = aDatos then
    Exit;
  FDatos := aDatos;

  Enabled := Assigned(Datos);
  if Enabled then
    pEstadisticas.Caption :=
      Format('La partida duró %0:d segundos', [aDatos^.Segundos]);
end;

procedure TfmLNSCFEGrabarINP.DoSaveData;
begin
  if not assigned(Datos) then
    Exit;

  Datos^.Puntuacion := ePuntuacion.Text;
  Datos^.Conservar := rgbConservar.ItemIndex = 0;
end;

class procedure TfmLNSCFEGrabarINP.SimpleForm(const aDatos: PGrabarINPDatos;
  const aGUIConfigIni, aGUIIconsIni: string);
var
  aFrame: TfmLNSCFEGrabarINP;
begin
  aFrame := TfmLNSCFEGrabarINP.Create(nil);
  aFrame.Datos := aDatos;
  aFrame.ButtonClose := True;

  GenSimpleModalForm(aFrame, 'frmGrabarINP', 'Grabar INP', aGUIConfigIni,
    aGUIIconsIni);
end;

constructor TfmLNSCFEGrabarINP.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);

  OnSaveFrameData := @DoSaveData;
end;

destructor TfmLNSCFEGrabarINP.Destroy;
begin
  inherited Destroy;
end;

end.
