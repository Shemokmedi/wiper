unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Winapi.SHFolder, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, System.IniFiles, Vcl.FileCtrl, MMSystem, Registry, ShellAPI,
  WipeFile, Vcl.ComCtrls;

Const
  DBT_DEVICEARRIVAL = $8000;
  DBT_DEVTYP_VOLUME = 2;
  DBT_DEVICEREMOVECOMPLEATE = $8004;

type

  PDEV_BROADCAST_HDR = ^DEV_BROADCAST_HDR;

  DEV_BROADCAST_HDR = record
    dbch_size, dbch_devicetype, dbch_reserved: DWORD;
  end;

  PDEV_BROADCAST_VOLUME = ^DEV_BROADCAST_VOLUME;

  DEV_BROADCAST_VOLUME = record
    dbcv_size, dbcv_devicetype, dbcv_reserved, dbcv_unitmask: DWORD;
  end;

  TWipeStatus = (wsWait, wsExecute, wsFinish);

  TfrmMain = class(TForm)
    grbDropBox: TGroupBox;
    Label1: TLabel;
    edtDropBoxStatus: TEdit;
    Label2: TLabel;
    edtDropBoxUninstaller: TEdit;
    Label3: TLabel;
    edtDropBoxDataDir: TEdit;
    grb1C: TGroupBox;
    Label4: TLabel;
    Label6: TLabel;
    edt1CStatus: TEdit;
    edt1CDataDir: TEdit;
    grbFiles: TGroupBox;
    Label5: TLabel;
    Label8: TLabel;
    edtFilesStatus: TEdit;
    lbxDirList: TListBox;
    btnOpenUninstaller: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    grbKey: TGroupBox;
    Label7: TLabel;
    Label9: TLabel;
    edtKeyFileStatus: TEdit;
    edtKeyFileName: TEdit;
    grbOptions: TGroupBox;
    chbAutoload: TCheckBox;
    chbAutokill: TCheckBox;
    Button6: TButton;
    Label10: TLabel;
    edt1CExeName: TEdit;
    Label11: TLabel;
    edtFinalWave: TEdit;
    Button7: TButton;
    opdMain: TOpenDialog;
    btnOpen1CExe: TButton;
    chbLog: TCheckBox;
    Timer1: TTimer;
    btnClose: TButton;
    btnSave: TButton;
    TrayIcon1: TTrayIcon;
    GroupBox1: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    edtSDeleteStatus: TEdit;
    edtSDeleteWoW: TEdit;
    edtSDeleteFileName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure edtKeyFileNameKeyPress(Sender: TObject; var Key: Char);
    procedure Button6Click(Sender: TObject);
    procedure btnOpenUninstallerClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnOpen1CExeClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure chbAutoloadMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
    procedure chbAutokillMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
    procedure chbLogMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
    procedure Button7Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TrayIcon1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    WipeStatus: TWipeStatus;
    NeedToClose: Boolean;

    DataWiper: TDataWiper;
    DropBoxWiper: TDropBoxWiper;
    OnesWiper: TOnesWiper;

    function DriveMaskToString(mask: DWORD): string;
    function GetSpecialFolderPath(folder: Integer): string;
    //
    procedure ReadParam;
    procedure WriteParam;
    //
    procedure CheckKeyStatus;
    procedure CheckDropBoxStatus;
    procedure Check1CStatus;
    procedure CheckFilesStatus;
    procedure CheckSDeleteStatus;
    //
    function GetSDeleteWithParam: string;
    function GetSDeleteWipeDisk: string;
    procedure SetAutoload;
    //
    procedure StartProcess;
  public
    procedure WMDeviceChange(var Msg: TMessage); message WM_DEVICECHANGE;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}
{ TfrmMain }

procedure TfrmMain.btnOpen1CExeClick(Sender: TObject);
begin
  opdMain.InitialDir := GetSpecialFolderPath(CSIDL_PROGRAM_FILES);
  opdMain.Filter := 'Программы|*.exe';
  if opdMain.Execute then
  begin
    edt1CExeName.text := ExtractFileName(opdMain.FileName);
    btnSave.Enabled := true;
    Check1CStatus;
  end;
end;

procedure TfrmMain.btnOpenUninstallerClick(Sender: TObject);
begin
  opdMain.InitialDir := ExtractFileDir(edtDropBoxUninstaller.text);
  opdMain.Filter := 'Программы|*.exe';
  if opdMain.Execute then
  begin
    edtDropBoxUninstaller.text := opdMain.FileName;
    btnSave.Enabled := true;
    CheckDropBoxStatus;
  end;
end;

procedure TfrmMain.btnSaveClick(Sender: TObject);
begin
  btnSave.Enabled := false;
  WriteParam;
  CheckKeyStatus;
  CheckDropBoxStatus;
  Check1CStatus;
  CheckFilesStatus;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  if MessageDlg('Закрыть программу?', mtWarning, [mbOK, mbCancel], 0) = mrOK then
  begin
    NeedToClose := true;
    Close;
  end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  S: string;
begin
  S := edtDropBoxDataDir.text;
  if SelectDirectory('Выбор папки с данными DropBox', '', S) then
  begin
    edtDropBoxDataDir.text := S;
    btnSave.Enabled := true;
    CheckDropBoxStatus;
  end;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
var
  S: string;
begin
  S := edt1CDataDir.text;
  if SelectDirectory('Выбор папки с данными 1C', '', S) then
  begin
    edt1CDataDir.text := S;
    btnSave.Enabled := true;
    Check1CStatus;
  end;
end;

procedure TfrmMain.Button4Click(Sender: TObject);
var
  S: string;
begin
  S := '';
  if SelectDirectory('Выбор папки с данными', '', S) then
  begin
    lbxDirList.Items.Add(S);
    btnSave.Enabled := true;
    CheckFilesStatus;
  end;
end;

procedure TfrmMain.Button5Click(Sender: TObject);
begin
  if lbxDirList.ItemIndex <> -1 then
    lbxDirList.Items.Delete(lbxDirList.ItemIndex);

  btnSave.Enabled := true;
  CheckFilesStatus;
end;

procedure TfrmMain.Button6Click(Sender: TObject);
begin
  if MessageDlg('Произвести запуск очистки?', mtWarning, [mbOK, mbCancel], 0) = mrOK then
    StartProcess;
end;

procedure TfrmMain.Button7Click(Sender: TObject);
begin
  opdMain.InitialDir := ExtractFileDir(edtFinalWave.text);
  opdMain.Filter := 'Звуки|*.wav';
  if opdMain.Execute then
  begin
    edtFinalWave.text := opdMain.FileName;
    btnSave.Enabled := true;
  end;
end;

procedure TfrmMain.chbAutokillMouseActivate(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
begin
  btnSave.Enabled := true;
end;

procedure TfrmMain.chbAutoloadMouseActivate(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
begin
  btnSave.Enabled := true;
  SetAutoload;
end;

procedure TfrmMain.chbLogMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
begin
  btnSave.Enabled := true;
end;

procedure TfrmMain.Check1CStatus;
begin
  //
  if edt1CExeName.text = '' then
  begin
    edt1CExeName.color := clWebPink;

    edt1CStatus.text := ' Настройте процесс';
    edt1CStatus.color := clWebPink;
  end
  else
  begin
    edt1CExeName.color := clInfoBk;
    //
    if not DirectoryExists(edt1CDataDir.text) then
    begin
      edt1CDataDir.color := clWebPink;
      edt1CStatus.text := ' Настройте путь к папке с данными';
      edt1CStatus.color := clWebPink;
    end
    else
    begin
      edt1CDataDir.color := clInfoBk;
      edt1CStatus.text := ' Готов к удалению';
      edt1CStatus.color := clWebLightGreen;
    end;
  end;
end;

procedure TfrmMain.CheckDropBoxStatus;
begin
  if FileExists(edtDropBoxUninstaller.text) then
  begin
    edtDropBoxUninstaller.color := clInfoBk;
    //
    if not DirectoryExists(edtDropBoxDataDir.text) then
    begin
      edtDropBoxDataDir.color := clWebPink;
      edtDropBoxStatus.text := ' Настройте путь к папке с данными';
      edtDropBoxStatus.color := clWebPink;
    end
    else
    begin
      edtDropBoxDataDir.color := clInfoBk;
      edtDropBoxStatus.text := ' Готов к удалению';
      edtDropBoxStatus.color := clWebLightGreen;
    end;
  end
  else
  begin
    edtDropBoxUninstaller.color := clWebPink;
    edtDropBoxStatus.text := ' Настройте деинсталлятор';
    edtDropBoxStatus.color := clWebPink;
    // ещё может быть вариант, когда дропбокса нет вообще, но это тоже самое, что отсутствие деинсталлятора.
  end;
end;

procedure TfrmMain.CheckFilesStatus;
begin
  //
  if lbxDirList.Items.Count > 0 then
  begin
    edtFilesStatus.text := ' Готов к удалению';
    edtFilesStatus.color := clWebLightGreen;
  end
  else
  begin
    edtFilesStatus.text := ' Нет данных для удаления';
    edtFilesStatus.color := clWebAliceBlue;
  end;
end;

procedure TfrmMain.CheckKeyStatus;
begin
  if edtKeyFileName.text = '' then
  begin
    edtKeyFileStatus.text := ' Укажите имя ключевого файла';
    edtKeyFileStatus.color := clWebPink;
  end
  else
  begin
    edtKeyFileStatus.text := ' Ожидание...';
    edtKeyFileStatus.color := clWebLightGreen;
  end;
end;

procedure TfrmMain.CheckSDeleteStatus;
begin
  edtSDeleteFileName.text := GetSpecialFolderPath(CSIDL_WINDOWS);
  //
  if IsWOW64 then
  begin
    edtSDeleteWoW.text := 'х64';
    edtSDeleteFileName.text := edtSDeleteFileName.text + '\sdelete64.exe';
  end
  else
  begin
    edtSDeleteWoW.text := 'х32';
    edtSDeleteFileName.text := edtSDeleteFileName.text + '\sdelete.exe';
  end;
  //
  if FileExists(edtSDeleteFileName.text) then
  begin
    edtSDeleteStatus.text := ' Готов к удалению';
    edtSDeleteStatus.color := clWebLightGreen;
  end
  else
  begin
    edtSDeleteStatus.text := ' Утилита не найдена';
    edtSDeleteStatus.color := clWebAliceBlue;
  end;
end;

function TfrmMain.DriveMaskToString(mask: DWORD): string;
var
  DriveLetter: Char;
  Drives: string;
  i: Integer;
  pom: Integer;
begin
  Drives := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  i := 0;
  pom := Trunc(mask / 2);
  while (pom <> 0) do
  begin
    pom := Trunc(pom / 2);
    i := i + 1;
  end;
  if (i < Length(Drives)) then
    DriveLetter := Drives[i + 1]
  else
    DriveLetter := '?';
  result := DriveLetter + ':\';
end;

procedure TfrmMain.edtKeyFileNameKeyPress(Sender: TObject; var Key: Char);
begin
  btnSave.Enabled := true;
end;

function GetTempDirectory(): String;
var
  tempFolder: array [0 .. MAX_PATH] of Char;
begin
  GetTempPath(MAX_PATH, @tempFolder);
  result := StrPas(tempFolder);
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  BatFile: TextFile;
  S: string;
begin
  if NeedToClose then
  begin
    if (WipeStatus = wsWait) then
      CanClose := true
    else if (WipeStatus = wsFinish) then
    begin
      S := GetTempDirectory + 'TEMP.BAT';
      AssignFile(BatFile, S);
      ReWrite(BatFile);
      if chbAutokill.Checked then // самоудаление
      begin
        // задержка 3 секунд для гарантированного закрытия приложения
        WriteLn(BatFile, 'ping -n 4 127.0.0.1 >nul');
        WriteLn(BatFile, GetSDeleteWithParam + ExtractFileDir(ParamStr(0)));
      end;
      WriteLn(BatFile, GetSDeleteWipeDisk);
      WriteLn(BatFile, 'del ' + S);
      CloseFile(BatFile);
      ChDir(GetTempDirectory);
      ShellExecute(0, 'OPEN', PWideChar(S), '', '', SW_HIDE);
      // WinExec( PAnsiChar(s), 0);
      CanClose := true;
    end
    else

    begin
      // остановить обработку
      DataWiper.Terminate;
      DropBoxWiper.Terminate;
      OnesWiper.Terminate;
      CanClose := false;
      btnClose.Enabled := false;
    end;
  end
  else
  begin
    CanClose := false;
    Hide;
    TrayIcon1.visible := true;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  WipeStatus := wsWait;
  NeedToClose := false;
  ReadParam;
  CheckKeyStatus;
  CheckDropBoxStatus;
  Check1CStatus;
  CheckFilesStatus;
  CheckSDeleteStatus;
  //
  Hide;
  TrayIcon1.visible := true;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(DataWiper) then
    DataWiper.Free;
  if Assigned(DropBoxWiper) then
    DropBoxWiper.Free;
  if Assigned(OnesWiper) then
    OnesWiper.Free;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  CheckSDeleteStatus;
end;

procedure TfrmMain.WMDeviceChange(var Msg: TMessage);
var
  DriveLetter: string;
begin
  if WipeStatus = wsWait then
  begin
    if (Msg.WParam = DBT_DEVICEARRIVAL) then
      if (PDEV_BROADCAST_HDR(Msg.LParam)^.dbch_devicetype = DBT_DEVTYP_VOLUME) then
      begin
        // Определим букву, которую система присвоила флешке
        DriveLetter := DriveMaskToString(PDEV_BROADCAST_VOLUME(Msg.LParam)^.dbcv_unitmask);
        // есть ли на флешке ключ?
        if FileExists(DriveLetter + '\' + edtKeyFileName.text) then
        begin
          edtKeyFileStatus.text := ' Обнаружен ключ инициализации';
          edtKeyFileStatus.color := clWebNavy;
          edtKeyFileStatus.font.color := clWebLightYellow;
          // запускаем процесс
          StartProcess;
        end;
      end;
  end;
end;

procedure TfrmMain.WriteParam;
var
  IniFile: TIniFile;
  i: Integer;
begin
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  //
  IniFile.WriteString('OPTIONS', 'KEY_FILE_NAME', edtKeyFileName.text);
  IniFile.WriteString('OPTIONS', 'DROPBOX_UNINSTALLER', edtDropBoxUninstaller.text);
  IniFile.WriteString('OPTIONS', 'DROPBOX_DATA_DIR', edtDropBoxDataDir.text);
  IniFile.WriteString('OPTIONS', '1C_EXE_NAME', edt1CExeName.text);
  IniFile.WriteString('OPTIONS', '1C_EXE_DATA_DIR', edt1CDataDir.text);

  IniFile.EraseSection('DATA');
  IniFile.WriteInteger('OPTIONS', 'DATA_DIR_COUNT', lbxDirList.Count);

  for i := 0 to lbxDirList.Count - 1 do
  begin
    IniFile.WriteString('DATA', 'DATA_DIR.' + inttostr(i), lbxDirList.Items[i]);
  end;

  IniFile.WriteBool('OPTIONS', 'AUTOLOAD', chbAutoload.Checked);
  IniFile.WriteBool('OPTIONS', 'AUTOKILL', chbAutokill.Checked);
  IniFile.WriteBool('OPTIONS', 'LOG', chbLog.Checked);

  IniFile.WriteString('OPTIONS', 'FINAL_WAVE', edtFinalWave.text);
  //
  IniFile.Free;
  //
end;

function TfrmMain.GetSDeleteWipeDisk: string;
begin
  result := edtSDeleteFileName.text + ' -p 1 -c c:';
end;

function TfrmMain.GetSDeleteWithParam: string;
begin
  result := edtSDeleteFileName.text + ' -nobanner -p 1 -r -s ';
end;

function TfrmMain.GetSpecialFolderPath(folder: Integer): string;
const
  SHGFP_TYPE_CURRENT = 0;
var
  path: array [0 .. MAX_PATH] of Char;
begin
  if SUCCEEDED(SHGetFolderPath(0, folder, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    result := path
  else
    result := '';
end;

procedure TfrmMain.ReadParam;
var
  IniFile: TIniFile;
  i: Integer;
begin
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  //
  edtKeyFileName.text := IniFile.ReadString('OPTIONS', 'KEY_FILE_NAME', '');
  edtDropBoxUninstaller.text := IniFile.ReadString('OPTIONS', 'DROPBOX_UNINSTALLER',
    GetSpecialFolderPath(CSIDL_PROGRAM_FILES) + '\Dropbox\Client\DropboxUninstaller.exe');
  edtDropBoxDataDir.text := IniFile.ReadString('OPTIONS', 'DROPBOX_DATA_DIR', '?');
  edt1CExeName.text := IniFile.ReadString('OPTIONS', '1C_EXE_NAME', '');
  edt1CDataDir.text := IniFile.ReadString('OPTIONS', '1C_EXE_DATA_DIR', '?');
  //
  lbxDirList.Tag := IniFile.ReadInteger('OPTIONS', 'DATA_DIR_COUNT', 0);
  for i := 0 to lbxDirList.Tag - 1 do
  begin
    lbxDirList.Items.Add(IniFile.ReadString('DATA', 'DATA_DIR.' + inttostr(i), ''));
  end;

  chbAutoload.Checked := IniFile.ReadBool('OPTIONS', 'AUTOLOAD', false);
  chbAutokill.Checked := IniFile.ReadBool('OPTIONS', 'AUTOKILL', false);
  chbLog.Checked := IniFile.ReadBool('OPTIONS', 'LOG', false);

  edtFinalWave.text := IniFile.ReadString('OPTIONS', 'FINAL_WAVE', '');

  IniFile.Free;
  //
end;

procedure TfrmMain.SetAutoload;
var
  Reg: TRegistry;
begin
  // событие приходит в момент клика, а не после установки чекера,
  // поэтому логика инверсная
  if not chbAutoload.Checked then
  begin
    Reg := TRegistry.Create;
    Reg.RootKey := hkey_current_user;
    Reg.OpenKey('software\microsoft\windows\currentversion\run', true);
    Reg.WriteString('wiper', Application.ExeName);
    Reg.CloseKey;
    Reg.Free;
  end
  else
  begin
    Reg := TRegistry.Create;
    Reg.RootKey := hkey_current_user;
    Reg.OpenKey('software\microsoft\windows\currentversion\run', true);
    Reg.DeleteValue('wiper');
    Reg.CloseKey;
    Reg.Free;
  end;
end;

procedure TfrmMain.StartProcess;
var
  DataWiperParam: TProcParam;
  DropBoxWiperParam: TProcParam;
  OnesWiperParam: TProcParam;
begin
  WipeStatus := wsExecute;
  // процесс очистки
  grbKey.Enabled := false;
  grbDropBox.Enabled := false;
  grb1C.Enabled := false;
  grbFiles.Enabled := false;
  grbOptions.Enabled := false;
  //
  DataWiperParam.SDelete := GetSDeleteWithParam;
  DataWiperParam.DirList := lbxDirList.Items;
  if chbLog.Checked then
    DataWiperParam.LogFileName := ChangeFileExt(ParamStr(0), '.log1')
  else
    DataWiperParam.LogFileName := '';
  DataWiper := TDataWiper.Create(DataWiperParam);
  DataWiper.Start;
  //
  edtFilesStatus.color := clWebNavy;
  edtFilesStatus.font.color := clWebLightYellow;
  edtFilesStatus.text := ' Подготовка к удалению';
  //
  //
  DropBoxWiperParam.SDelete := GetSDeleteWithParam;
  DropBoxWiperParam.DirList := nil;
  DropBoxWiperParam.Dir := edtDropBoxDataDir.text;
  DropBoxWiperParam.Process := edtDropBoxUninstaller.text;
  if chbLog.Checked then
    DropBoxWiperParam.LogFileName := ChangeFileExt(ParamStr(0), '.log2')
  else
    DropBoxWiperParam.LogFileName := '';
  DropBoxWiper := TDropBoxWiper.Create(DropBoxWiperParam);
  DropBoxWiper.Start;
  //
  edtDropBoxStatus.color := clWebNavy;
  edtDropBoxStatus.font.color := clWebLightYellow;
  edtDropBoxStatus.text := ' Подготовка к удалению';
  //
  //
  OnesWiperParam.SDelete := GetSDeleteWithParam;
  OnesWiperParam.DirList := nil;
  OnesWiperParam.Dir := edt1CDataDir.text;
  OnesWiperParam.Process := edt1CExeName.text;
  if chbLog.Checked then
    OnesWiperParam.LogFileName := ChangeFileExt(ParamStr(0), '.log3')
  else
    OnesWiperParam.LogFileName := '';
  OnesWiper := TOnesWiper.Create(OnesWiperParam);
  OnesWiper.Start;
  //
  edt1CStatus.color := clWebNavy;
  edt1CStatus.font.color := clWebLightYellow;
  edt1CStatus.text := ' Подготовка к удалению';
  //
  Timer1.Enabled := true;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  if DataWiper.Finished then
  begin
    edtFilesStatus.text := ' Удаление завершено';
    edtFilesStatus.font.color := clLime;
    edtFilesStatus.color := clBlack;
  end
  else
  begin
    edtFilesStatus.text := ' Удаление данных';
  end;
  //
  if DropBoxWiper.Finished then
  begin
    edtDropBoxStatus.text := ' Удаление завершено';
    edtDropBoxStatus.font.color := clLime;
    edtDropBoxStatus.color := clBlack;
  end
  else
  begin
    edtDropBoxStatus.text := ' Удаление данных';
  end;
  //
  if OnesWiper.Finished then
  begin
    edt1CStatus.text := ' Удаление завершено';
    edt1CStatus.font.color := clLime;
    edt1CStatus.color := clBlack;
  end
  else
  begin
    edt1CStatus.text := ' Удаление данных';
  end;
  // завершение всех процессов
  if DataWiper.Finished and DropBoxWiper.Finished and OnesWiper.Finished then
  begin
    Timer1.Enabled := false;
    //
    WipeStatus := wsFinish;
    // было прерывание
    if NeedToClose then
      Close;
    // нормальное завершение
    // звучёк
    if (edtFinalWave.text <> '') then
    begin
      try
        sndPlaySound(PWideChar(edtFinalWave.text), SND_NODEFAULT Or SND_ASYNC Or SND_NOSTOP);
      except
      end;
    end;
    if chbLog.Checked then
      ShowMessage('Процесс окончен');
    //
    NeedToClose := true;
    Close;
  end;

end;

procedure TfrmMain.TrayIcon1Click(Sender: TObject);
begin
  Show;
  TrayIcon1.visible := false;
end;

end.
