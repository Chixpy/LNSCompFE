program LNSCompFE;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  // CHX units
  uCHXRscStr, uCHXConst,
  // CHX abstracts
  uaCHXStorable,
  // CHX forms
  ufrCHXForm,
  // CHX frames
  ufCHXFileListPreview, ufCHXImgViewer, ufCHXListPreview,
  // LNSCompFE classes
  ucLNSCFEConfig,
  // LNSCompFE forms
  ufrLNSCompFE,
  // LNSCompFE frames
  ufLNSCFEConfig, ufLNSCFEGrabarINP;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmLNSCompFE, frmLNSCompFE);
  Application.Run;
end.

