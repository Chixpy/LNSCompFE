unit ufrLNSCompFE;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  IniPropStorage, ComCtrls, ExtCtrls,
  // Misc units
  uVersionSupport,
  // CHX forms
  ufrCHXForm;

type

  { TfrmLNSCompFE }

  TfrmLNSCompFE = class(TfrmCHXForm)
    iLogo: TImage;
    pBottom: TPanel;
    pMain: TPanel;
    pRight: TPanel;
    pTop: TPanel;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);

  private

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

    // Windows Caption
  Caption := Format('%0:s: %1:s', [Application.Title, 'Ventana principal']);

  LoadGUIConfig('LNSCompFE.ini');
end;

end.

