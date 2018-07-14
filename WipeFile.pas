unit WipeFile;

interface

uses Winapi.Windows, System.Classes, System.SysUtils, TlHelp32; // , ShellApi;

type

  TProcParam = record
    Dir: string; // ���� �����
    DirList: TStrings; // ������ �����
    LogFileName: string; // ���-����
    //
    Process: string; // ���� � �������������� ��� ��� �������� ��� �������
    SDelete: string; // ���� � ������� ��������
  end;

  // ������� ����� ��������� ������������ ������
  TProcFiles = class(TThread)
  private
    //
    FileList: TStringList; // ������ �������������� ������/�����
    Log: TStringList; // ���
    NeedLog: boolean;
    // �������� ������ ������ �� ��������� ����������
  protected
    // ���������
    ProcParam: TProcParam;
    //
    procedure Execute; override;
    //
    procedure WriteToLog(_S: string);
    procedure ProcData; virtual; abstract;
    // ��������� � ��������� ����������
    function RunAndWait(const _FileName: String): DWORD;
    //
    procedure Wipe;
    //
    function KillProcessByExeName(ExeFileName: string): integer;
  public
    destructor Destroy; override;
    constructor Create(_ProcParam: TProcParam);
  end;

  // �������� ������ �� �����.
  TDataWiper = class(TProcFiles)
  protected
    procedure ProcData; override;
  end;

  // �������� ������ �� DropBox.
  TDropBoxWiper = class(TProcFiles)
  protected
    procedure ProcData; override;
  end;

  // �������� ������ �� DropBox.
  TOneSWiper = class(TProcFiles)
  private

  protected
    procedure ProcData; override;
  end;

  function IsWow64: BOOL;

implementation

{ TProcFiles }

constructor TProcFiles.Create(_ProcParam: TProcParam);
begin
  inherited Create(true); // ������ ������ ����������������
  ProcParam := _ProcParam;
  //
  FileList := TStringList.Create;
end;

destructor TProcFiles.Destroy;
begin
  FileList.Free;
  inherited;
end;

procedure TProcFiles.Execute;
var
  I: integer;
begin
  inherited;
  NeedLog := ProcParam.LogFileName <> '';
  if NeedLog then
    Log := TStringList.Create;
  try
    try
      if Assigned(ProcParam.DirList) then
      begin
        // ���������� ������ ������
        for I := 0 to ProcParam.DirList.Count - 1 do
        begin
          if DirectoryExists(ProcParam.DirList.Strings[I]) then
          begin
            FileList.Add( ProcParam.DirList.Strings[I] );
          end
          else
          begin
            WriteToLog('�� ������� ����� ' + ProcParam.DirList.Strings[I])
          end;
          //
          if Terminated then
            break;
        end;
      end;
      //
      if ProcParam.Dir <> '' then
      begin
        if DirectoryExists(ProcParam.Dir) then
        begin
          FileList.Add( ProcParam.Dir );
        end
        else
        begin
          WriteToLog('�� ������� ����� ' + ProcParam.Dir)
        end;
      end;
      //
      if not Terminated then
        ProcData;
    except
      On E: Exception do
      begin
        WriteToLog('������ ��������� ������: ' + E.Message);
      end
    end;
  finally
    // ���������� ����
    if NeedLog then
      Log.SaveToFile(ProcParam.LogFileName);
  end;
end;

function TProcFiles.RunAndWait(const _FileName: String): DWORD;
var
  StartUpInfo: TStartUpInfo;
  ProcessInfo: TProcessInformation;
  ErrNum: integer;
begin
  result := STILL_ACTIVE;
  GetStartupInfo(StartUpInfo);
  // ������ ����...
  StartUpInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartUpInfo.wShowWindow := SW_HIDE;

  if not CreateProcess(nil, PChar(_FileName), nil, nil, false, NORMAL_PRIORITY_CLASS, nil, nil,
    StartUpInfo, ProcessInfo) then
  begin
    ErrNum := GetLastError;
    WriteToLog('������ ������� ���������� ' + _FileName + ' - ' + inttostr(ErrNum));
  end
  else
  begin
    try
      if WaitForSingleObject(ProcessInfo.hProcess, INFINITE) = WAIT_OBJECT_0 then
        GetExitCodeProcess(ProcessInfo.hProcess, result);
    finally
      CloseHandle(ProcessInfo.hThread);
      CloseHandle(ProcessInfo.hProcess);
    end;
  end;
end;


procedure TProcFiles.Wipe;
var
  I: integer;
  S: string;
  CurrentFileName: string;
begin
  for I := 0 to FileList.Count - 1 do
  begin
    if Terminated then
      break;
    try
      CurrentFileName := FileList.Strings[I];
      S:= ProcParam.SDelete+CurrentFileName;
      RunAndWait(S);
    except
      On E: Exception do
      begin
        WriteToLog('������ ��������� ����� ' + CurrentFileName + ' - ' + E.Message);
      end
    end;
  end;
end;


procedure TProcFiles.WriteToLog(_S: string);
begin
  if NeedLog then
    Log.Add(_S);
end;

function TProcFiles.KillProcessByExeName(ExeFileName: string): integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  hProcess: Cardinal;
begin
  result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  ExeFileName := UpperCase(ExeFileName);
  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = ExeFileName) or
      (UpperCase(FProcessEntry32.szExeFile) = ExeFileName)) then
    begin
      { ��������� � ������� ������� }
      hProcess := OpenProcess(PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID);
      if not TerminateProcess(hProcess, 0) then
        WriteToLog('������� �� ��� �������� - ' + ExeFileName);
      // ����� � ��������� ����������
      begin
        WaitForSingleObject(hProcess, INFINITE);
        CloseHandle(hProcess); //
        // GetExitCodeProcess(hProcess, result);
      end;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

{ TDataWiper }

procedure TDataWiper.ProcData;
begin
  // �������...
  Wipe;
end;

{ TDropBoxWiper }

procedure TDropBoxWiper.ProcData;
begin
  KillProcessByExeName('Dropbox.exe');
  RunAndWait('"' + ProcParam.Process + '" /S');
  // ������� �����������, � ����� �� ������ ��������
  sleep(1000); // ����� ����� ������ ������������
  Wipe;
end;


{ TOneSWiper }

procedure TOneSWiper.ProcData;
begin
  KillProcessByExeName(ProcParam.Process);
  // ������� �����������, � ����� �� ������ ��������
  sleep(1000); // ����� ����� ������ ������������
  Wipe;
end;

{ ---------- }


function IsWow64: BOOL;
type
  TIsWow64Process = function(hProcess: THandle;
    var Wow64Process: BOOL): BOOL; stdcall;
var
  IsWow64Process: TIsWow64Process;
begin
  Result := False;
  @IsWow64Process := GetProcAddress(GetModuleHandle(kernel32),
    'IsWow64Process');
  if Assigned(@IsWow64Process) then
    IsWow64Process(GetCurrentProcess, Result);
end;

end.


(*

  ������������ �������� ��������������,
  ��� ��������� ��� ������������� � ������� EFS ����� ���������� ������������,
  �������� ������������� ���������� ��� ����������� �������� ������.����� ���������� � �������
  ����������� ���� ������� �������������� ������� �����,
  �� ������� ���� ����������� ��������� �����.����� �������,
  ���� ��� ������������� ���������� ��������������,
  ��� ������� ������������ ���������� ������ ��������������� � ��������� ���������,
  ������������ ��������� ����� ����� ����������.����� �� ����� ���������� �������� ��������� SDelete
  (Secure Delete).�� ����� ������������ ��� ��� �������� ������������ ������,
  ��� � ��� ������� ������, ������������� �� ��������� �������� �������� �����
  (������� ��� ��������� ��� ������������� �����).��������� SDelete �������� ����������� ���������
  ��������� ������� ������ DOD 5220.22 - M,
  �������������� ������������� ������� ���.����� ���� ���������, ��� ����,
  ��������� � ������� ��������� SDelete, �������������� ��������� �� �����.���������� ����� � ����,
  ��� ��������� SDelete ������� ����������, �� �� ������� ����� ��������� ������,
  ������������� � ��������� �������� ������������.

  ���������: SDelete[-p ����������_��������][-S][-q] < ���� ��� ����� >
  SDelete[-p ����������_��������] - z[����� �����]

  -p ����������_�������� ���������� �������� ����������.
  -S ����������� ����� ��������� �����.
  -q �� �������� �� ����� ������(����� �����).
  -z ���������� ������� ���������� �����.

  *)
