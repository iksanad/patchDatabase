program patchDatabase;

uses
  Vcl.Forms,
  umain in 'umain.pas' {FPATCH};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFPATCH, FPATCH);
  Application.Run;
end.
