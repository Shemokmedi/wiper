program Wiper;

uses
  System.SysUtils,
  Vcl.Forms,
  Main in 'Main.pas' {frmMain},
  WipeFile in 'WipeFile.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  if FileExists( ChangeFileExt(ParamStr(0), '.ini') ) then
    Application.ShowMainForm := False;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
