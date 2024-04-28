unit ufLNSCFEGrabarINP;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ActnList, Spin,
  // CHX frames
  ufCHXPropEditor;

type

  // Un simple record para obtener los datos del formulario, hacer una clase
  //   es excesivo...
  // Aunque usar un record implica trastear con punteros XD

  RGrabarINPDatos = record
    Tiempo : integer;
    //< Tiempo en segundos
    Puntuacion : LongInt;
    //< Exclusivanmente número: Tiempo o puntos.
    Comentario: array[1..3] of string;
    //< Tres serán suficiente... por no hacerlo dinámico...
    MantComentario: array[1..3] of Boolean;
    //< Recordar el comentario N entre intentos.
    Conservar : Boolean;
    OutputMAME : string;
  end;
  PGrabarINPDatos = ^RGrabarINPDatos;

  { TfmLNSCFEGrabarINP }

  TfmLNSCFEGrabarINP = class(TfmCHXPropEditor)
    chkComentario1 : TCheckBox;
    chkComentario2 : TCheckBox;
    chkComentario3 : TCheckBox;
    eComentario1 : TEdit;
    eComentario2 : TEdit;
    eComentario3 : TEdit;
    gbxComentarios : TGroupBox;
    lComentario1 : TLabel;
    lComentario2 : TLabel;
    lComentario3 : TLabel;
    pComentario1 : TPanel;
    gbxPuntuacion : TGroupBox;
    lPuntuacion : TLabel;
    pComentario2 : TPanel;
    pComentario3 : TPanel;
    pConservar : TPanel;
    pEstadisticas : TPanel;
    pInfo : TPanel;
    rgbConservar : TRadioGroup;
    sePuntuacion : TSpinEdit;

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
    // Format('La partida duró %0:d segundos', [aDatos^.Tiempo]);
  end;

  // Restableciendo comentarios que se han querido mantener
  if aDatos^.MantComentario[1] then
  begin
    chkComentario1.Checked := True;
    eComentario1.Text := aDatos^.Comentario[1];
  end;
  if aDatos^.MantComentario[2] then
  begin
    chkComentario2.Checked := True;
    eComentario2.Text := aDatos^.Comentario[2];
  end;
  if aDatos^.MantComentario[3] then
  begin
    chkComentario3.Checked := True;
    eComentario3.Text := aDatos^.Comentario[3];
  end;
end;

procedure TfmLNSCFEGrabarINP.SaveFrameData;
begin
  inherited;

  if not assigned(Datos) then
    Exit;

  // Sólo conservamos la partida si se pulsa aceptar.
  Datos^.Conservar := rgbConservar.ItemIndex = 0;

  Datos^.MantComentario[1] := chkComentario1.Checked;
  Datos^.Comentario[1] := eComentario1.Text;
  Datos^.MantComentario[2] := chkComentario2.Checked;
  Datos^.Comentario[2] := eComentario2.Text;
  Datos^.MantComentario[3] := chkComentario3.Checked;
  Datos^.Comentario[3] := eComentario3.Text;
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
  Datos^.Puntuacion := sePuntuacion.Value;

  inherited Destroy;
end;

end.
