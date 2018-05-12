unit ufrLNSCompFE;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, ActnList, IniPropStorage, Buttons, StdCtrls,
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rgbJuegosClick(Sender: TObject);

  private
    FConfig: cLNSCFEConfig;
    FConfigFile: string;
    FImpPreview: TfmCHXImgListPreview;
    procedure SetConfigFile(const aConfigFile: string);

  protected
    property ConfigFile: string read FConfigFile write SetConfigFile;

    property Config: cLNSCFEConfig read FConfig;

    property ImpPreview: TfmCHXImgListPreview read FImpPreview;

    procedure ActualizarJuegos;

    procedure ActualizarMedia;

  public

  end;

var
  frmLNSCompFE: TfrmLNSCompFE;

implementation

{$R *.lfm}

{ TfrmLNSCompFE }

procedure TfrmLNSCompFE.FormCreate(Sender: TObject);
begin
  Application.Title := Format('%0:s %1:s', [Application.Title, GetFileVersion]);
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

  ActualizarJuegos;
end;

procedure TfrmLNSCompFE.actEditarConfigExecute(Sender: TObject);
begin
  TfmLNSCFEConfig.SimpleModalForm(Config, ConfigFile, '');
end;

procedure TfrmLNSCompFE.FormDestroy(Sender: TObject);
begin
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

procedure TfrmLNSCompFE.ActualizarJuegos;
begin
  rgbJuegos.Items.Assign(Config.Juegos);
  if rgbJuegos.Items.Count > 0 then
    rgbJuegos.ItemIndex := 0;
end;

procedure TfrmLNSCompFE.ActualizarMedia;
begin

end;

end.

