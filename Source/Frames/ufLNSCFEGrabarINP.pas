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
  // Aunque usar un record implica trastear con punteros XD

  { TODO : Dividir el campo puntuación al menos en dos:
      - Uno para la puntuación numérica en sí (Puntos o tiempo)
      - Otro (o más) para añadir comentarios (Por ejemplo, nivel de dificultad,
        personaje, etc.) }

  RGrabarINPDatos = record
    Segundos : integer;
    Puntuacion : string;
    Conservar : Boolean;
    OutputMAME : string;
  end;
  PGrabarINPDatos = ^RGrabarINPDatos;

  { TfmLNSCFEGrabarINP }

  TfmLNSCFEGrabarINP = class(TfmCHXPropEditor)
    ePuntuacion : TEdit;
    gbxPuntuacion : TGroupBox;
    lPuntuacion : TLabel;
    pEstadisticas : TPanel;
    pInfo : TPanel;
    rgbConservar : TRadioGroup;

  private
    FDatos : PGrabarINPDatos;
    procedure SetDatos(const aDatos : PGrabarINPDatos);
  public
    property Datos : PGrabarINPDatos read FDatos write SetDatos;

    class procedure SimpleForm(const aDatos : PGrabarINPDatos;
      const aGUIConfigIni, aGUIIconsIni : string);

    procedure SaveFrameData; override;

    constructor Create(TheOwner : TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.lfm}

{ TfmLNSCFEGrabarINP }

procedure TfmLNSCFEGrabarINP.SetDatos(const aDatos : PGrabarINPDatos);
begin
  if FDatos = aDatos then
    Exit;
  FDatos := aDatos;

  Enabled := Assigned(Datos);

  if Enabled then
  begin
    pEstadisticas.Caption := aDatos^.OutputMAME;
    // Format('La partida duró %0:d segundos', [aDatos^.Segundos]);
  end;
end;

procedure TfmLNSCFEGrabarINP.SaveFrameData;
begin
  inherited;

  if not assigned(Datos) then
    Exit;

  // Sólo conservamos la partida si se pulsa aceptar.
  Datos^.Conservar := rgbConservar.ItemIndex = 0;
end;

class procedure TfmLNSCFEGrabarINP.SimpleForm(const aDatos : PGrabarINPDatos;
  const aGUIConfigIni, aGUIIconsIni : string);
var
  aFrame : TfmLNSCFEGrabarINP;
begin
  aFrame := TfmLNSCFEGrabarINP.Create(nil);
  try
    aFrame.Datos := aDatos;
    aFrame.ButtonClose := True;

    GenSimpleModalForm(aFrame, 'frmGrabarINP', 'LNSCompFE: Grabar INP',
      aGUIConfigIni,
      aGUIIconsIni);
  finally
    // aFrame.Free; Autoliberado al cerrar el formulario
  end;
end;

constructor TfmLNSCFEGrabarINP.Create(TheOwner : TComponent);
begin
  inherited Create(TheOwner);
end;

destructor TfmLNSCFEGrabarINP.Destroy;
begin
  // Grabamos la puntuación de todas formas, para las estadísticas
  Datos^.Puntuacion := ePuntuacion.Text;

  inherited Destroy;
end;

end.
