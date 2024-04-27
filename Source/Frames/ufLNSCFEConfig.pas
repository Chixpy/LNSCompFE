unit ufLNSCFEConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ActnList, EditBtn, ComCtrls,
  // CHX units
  uCHXDlgUtils,
  // CHX frames
  ufCHXPropEditor,
  // LNSCompFE classes
  ucLNSCFEConfig;

type

  { TfmLNSCFEConfig }

  TfmLNSCFEConfig = class(TfmCHXPropEditor)
    eImagesFolder: TDirectoryEdit;
    eMAMEExe: TFileNameEdit;
    eParGrabarINP: TEdit;
    eParGrabarAVI: TEdit;
    eParProbarJuego: TEdit;
    eParReprINP: TEdit;
    gbxImagenes: TGroupBox;
    gbxJuegos: TGroupBox;
    gbxMAMEConfig: TGroupBox;
    gbxParAdicionales: TGroupBox;
    gbxParGrabarAVI: TGroupBox;
    gbxParGrabarINP: TGroupBox;
    gbxParProbarJuego: TGroupBox;
    gbxParReprINP: TGroupBox;
    lAyudaEjecutable: TLabel;
    lAyudaImagenes: TLabel;
    lAyudaParametros: TLabel;
    lJuegos: TLabel;
    lMAMEExe: TLabel;
    lAyudaParGrabarINP: TLabel;
    lAyudaParGrabarAVI: TLabel;
    lAyudaParProbarJuego: TLabel;
    lAyudaParReprINP: TLabel;
    mJuegos: TMemo;
    PageControl1: TPageControl;
    pagBasica: TTabSheet;
    pagAvanzada: TTabSheet;
    procedure eImagesFolderChange(Sender: TObject);
    procedure eMAMEExeButtonClick(Sender: TObject);

  private
    FConfig: cLNSCFEConfig;
    procedure SetConfig(const aConfig: cLNSCFEConfig);

  public
    property Config: cLNSCFEConfig read FConfig write SetConfig;

    class function SimpleModalForm(aConfig: cLNSCFEConfig;
      const aConfigIni, aIconsIni: string): integer;

    procedure ClearFrameData; override;
     procedure LoadFrameData; override;
     procedure SaveFrameData; override;

    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.lfm}

{ TfmLNSCFEConfig }

procedure TfmLNSCFEConfig.eMAMEExeButtonClick(Sender: TObject);
begin
  SetFileEditInitialDir(eMAMEExe, '');
end;

procedure TfmLNSCFEConfig.eImagesFolderChange(Sender: TObject);
begin
  SetDirEditInitialDir(eImagesFolder, '');
end;

procedure TfmLNSCFEConfig.SetConfig(const aConfig: cLNSCFEConfig);
begin
  if FConfig = aConfig then
    Exit;
  FConfig := aConfig;

  LoadFrameData;
end;

procedure TfmLNSCFEConfig.ClearFrameData;
begin
  inherited;

  // Basico
  eMAMEExe.Clear;
  eImagesFolder.Clear;
  mJuegos.Clear;

  // Avanzado
  eParGrabarINP.Clear;
  eParReprINP.Clear;
  eParGrabarAVI.Clear;
  eParProbarJuego.Clear;
end;

procedure TfmLNSCFEConfig.LoadFrameData;
begin
  inherited;

  Enabled := Assigned(Config);
  if not Enabled then
  begin
    ClearFrameData;
    Exit;
  end;

  // Básico
  eMAMEExe.Text := Config.MAMEExe;
  eImagesFolder.Text := Config.ImagesFolder;
  mJuegos.Lines.Assign(Config.Juegos);

  // Avanzado
  eParGrabarINP.Text := Config.ParAdicGrabarINP;
  eParReprINP.Text := Config.ParAdicReprINP;
  eParGrabarAVI.Text := Config.ParAdicGrabarAVI;
  eParProbarJuego.Text := Config.ParAdicProbarJuego;
end;

procedure TfmLNSCFEConfig.SaveFrameData;
begin
  inherited;

  // Básico
  Config.MAMEExe := eMAMEExe.Text;
  Config.ImagesFolder := eImagesFolder.Text;
  Config.Juegos.Assign(mJuegos.Lines);

  // Avanzado
  Config.ParAdicGrabarINP := eParGrabarINP.Text;
  Config.ParAdicReprINP := eParReprINP.Text;
  Config.ParAdicGrabarAVI := eParGrabarAVI.Text;
  Config.ParAdicProbarJuego := eParProbarJuego.Text;
end;

class function TfmLNSCFEConfig.SimpleModalForm(aConfig: cLNSCFEConfig;
  const aConfigIni, aIconsIni: string): integer;
var
  aFrame: TfmLNSCFEConfig;
begin
  aFrame := TfmLNSCFEConfig.Create(nil);
  try
    aFrame.Config := aConfig;
    aFrame.ButtonClose := True;

    Result := GenSimpleModalForm(aFrame, 'frmLNSCFEConfig',
      'LNSCompFE: Config', aConfigIni, aIconsIni);
  finally
    // aFrame.Free; Autoliberado al cerrar el formulario
  end;
end;

constructor TfmLNSCFEConfig.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);

  PageControl1.ActivePageIndex := 0;
end;

destructor TfmLNSCFEConfig.Destroy;
begin
  inherited Destroy;
end;

end.
