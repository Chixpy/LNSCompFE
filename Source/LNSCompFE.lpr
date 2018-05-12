program LNSCompFE;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  // CHX forms
  ufrCHXForm, uCHXRscStr, uCHXConst, ufCHXStrLstPreview, ufCHXImgViewer,
  uaCHXStorable, ufrLNSCompFE, ucLNSCFEConfig, ufLNSCFEConfig;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmLNSCompFE, frmLNSCompFE);
  Application.Run;
end.

