unit ufLNSCFEConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ActnList, EditBtn,
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
    gbxJuegos: TGroupBox;
    gbxMAMEConfig: TGroupBox;
    lAyudaEjecutable: TLabel;
    lAyudaImagenes: TLabel;
    lImages: TLabel;
    lJuegos: TLabel;
    lMAMEExe: TLabel;
    mJuegos: TMemo;
    procedure eImagesFolderChange(Sender: TObject);
    procedure eMAMEExeButtonClick(Sender: TObject);

  private
    FConfig: cLNSCFEConfig;
    procedure SetConfig(const aConfig: cLNSCFEConfig);

  protected
    procedure DoClearFrameData;
    procedure DoLoadFrameData;
    procedure DoSaveFrameData;

  public
    property Config: cLNSCFEConfig read FConfig write SetConfig;

    class function SimpleModalForm(aConfig: cLNSCFEConfig;
      const aConfigIni, aIconsIni: string): integer;

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

procedure TfmLNSCFEConfig.DoClearFrameData;
begin
  eMAMEExe.Text := '';
  eImagesFolder.Text := '';
  mJuegos.Clear;
end;

procedure TfmLNSCFEConfig.DoLoadFrameData;
begin
  Enabled := Assigned(Config);
  if not Enabled then
  begin
    ClearFrameData;
    Exit;
  end;

  eMAMEExe.Text := Config.MAMEExe;
  eImagesFolder.Text := Config.ImagesFolder;
  mJuegos.Lines.Assign(Config.Juegos);
end;

procedure TfmLNSCFEConfig.DoSaveFrameData;
begin
  Config.MAMEExe := eMAMEExe.Text;
  Config.ImagesFolder := eImagesFolder.Text;
  Config.Juegos.Assign(mJuegos.Lines);
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

  OnClearFrameData := @DoClearFrameData;
  OnLoadFrameData := @DoLoadFrameData;
  OnSaveFrameData := @DoSaveFrameData;
end;

destructor TfmLNSCFEConfig.Destroy;
begin
  inherited Destroy;
end;

end.
