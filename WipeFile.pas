unit WipeFile;

interface

uses Winapi.Windows, System.Classes, System.SysUtils, TlHelp32; // , ShellApi;

type

  TProcParam = record
    Dir: string; // одна папка
    DirList: TStrings; // список папок
    LogFileName: string; // лог-файл
    //
    Process: string; // путь к деинсталлятору или имя процесса для убиения
    SDelete: string; // путь к утилите удаления
  end;

  // базовый класс потоковых обработчиков файлов
  TProcFiles = class(TThread)
  private
    //
    FileList: TStringList; // список обрабатываемых файлов/папок
    Log: TStringList; // лог
    NeedLog: boolean;
    // получить список файлов из указанной директории
  protected
    // параметры
    ProcParam: TProcParam;
    //
    procedure Execute; override;
    //
    procedure WriteToLog(_S: string);
    procedure ProcData; virtual; abstract;
    // запустить и подождать завершения
    function RunAndWait(const _FileName: String): DWORD;
    //
    procedure Wipe;
    //
    function KillProcessByExeName(ExeFileName: string): integer;
  public
    destructor Destroy; override;
    constructor Create(_ProcParam: TProcParam);
  end;

  // удаление файлов из папок.
  TDataWiper = class(TProcFiles)
  protected
    procedure ProcData; override;
  end;

  // удаление файлов из DropBox.
  TDropBoxWiper = class(TProcFiles)
  protected
    procedure ProcData; override;
  end;

  // удаление файлов из DropBox.
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
  inherited Create(true); // всегда создаём приостановленным
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
        // подготовка списка файлов
        for I := 0 to ProcParam.DirList.Count - 1 do
        begin
          if DirectoryExists(ProcParam.DirList.Strings[I]) then
          begin
            FileList.Add( ProcParam.DirList.Strings[I] );
          end
          else
          begin
            WriteToLog('Не найдена папка ' + ProcParam.DirList.Strings[I])
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
          WriteToLog('Не найдена папка ' + ProcParam.Dir)
        end;
      end;
      //
      if not Terminated then
        ProcData;
    except
      On E: Exception do
      begin
        WriteToLog('Ошибка обработки данных: ' + E.Message);
      end
    end;
  finally
    // сохранение лога
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
  // скрыть окно...
  StartUpInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartUpInfo.wShowWindow := SW_HIDE;

  if not CreateProcess(nil, PChar(_FileName), nil, nil, false, NORMAL_PRIORITY_CLASS, nil, nil,
    StartUpInfo, ProcessInfo) then
  begin
    ErrNum := GetLastError;
    WriteToLog('Ошибка запуска приложения ' + _FileName + ' - ' + inttostr(ErrNum));
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
        WriteToLog('Ошибка обработки файла ' + CurrentFileName + ' - ' + E.Message);
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
      { открываем и убиваем процесс }
      hProcess := OpenProcess(PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID);
      if not TerminateProcess(hProcess, 0) then
        WriteToLog('Процесс не был завершён - ' + ExeFileName);
      // фишка с ожиданием завершения
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
  // удаляем...
  Wipe;
end;

{ TDropBoxWiper }

procedure TDropBoxWiper.ProcData;
begin
  KillProcessByExeName('Dropbox.exe');
  RunAndWait('"' + ProcParam.Process + '" /S');
  // процесс закрываются, а файлы не всегда доступны
  sleep(1000); // чтобы файлы успели освободиться
  Wipe;
end;


{ TOneSWiper }

procedure TOneSWiper.ProcData;
begin
  KillProcessByExeName(ProcParam.Process);
  // процесс закрываются, а файлы не всегда доступны
  sleep(1000); // чтобы файлы успели освободиться
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

  Единственным способом удостовериться,
  что удаленные или зашифрованные с помощью EFS файлы невозможно восстановить,
  является использование приложений для безопасного удаления файлов.Такие приложения с помощью
  приведенных ниже методик перезаписывают участки диска,
  на которых были расположены удаленные файлы.Таким образом,
  даже при использовании технологий восстановления,
  при которых производится считывание данных непосредственно с магнитных носителей,
  восстановить удаленные файлы будет невозможно.Одним из таких приложений является программа SDelete
  (Secure Delete).Ее можно использовать как для удаления существующих файлов,
  так и для очистки данных, расположенных на свободных участках жесткого диска
  (включая уже удаленные или зашифрованные файлы).программа SDelete является реализацией поддержки
  стандарта очистки данных DOD 5220.22 - M,
  разработанного министерством обороны США.можно быть уверенным, что файл,
  удаленный с помощью программы SDelete, восстановлению подлежать не будет.Необходимо иметь в виду,
  что программа SDelete очищает содержимое, но не удаляет имена очищенных файлов,
  расположенных в свободном дисковом пространстве.

  Синтаксис: SDelete[-p количество_проходов][-S][-q] < файл или папка >
  SDelete[-p количество_проходов] - z[буква диска]

  -p количество_проходов Количество проходов перезаписи.
  -S Рекурсивный обход вложенных папок.
  -q не выводить на экран ошибки(тихий режим).
  -z Произвести очистку свободного места.

  *)
