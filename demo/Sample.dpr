program Sample;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit23 in 'Unit23.pas' {Form23},
  FMX.WndProcHook in '..\FMX.WndProcHook.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm23, Form23);
  Application.Run;
end.
