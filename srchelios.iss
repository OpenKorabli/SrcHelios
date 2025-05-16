#define MyAppName "源曜SrcHelios字体（Mir Korabley）"
#define MyAppInstallerName "源曜SrcHelios字体模组-MK"
#define MyAppVersion "1.1.3"
#define MyAppPublisher "OpenKorabli"
#define MyAppPublisherURL "https://github.com/OpenKorabli"
#define MyAppSupportURL "https://github.com/OpenKorabli"

[Setup]
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppPublisherURL}
AppSupportURL={#MyAppSupportURL}
WizardImageFile=assets\wizard.bmp
WizardSmallImageFile=assets\wizard_small.bmp
DisableWelcomePage=no
OutputBaseFilename={#MyAppInstallerName}-{#MyAppVersion}
DefaultDirName={tmp}
DisableDirPage=yes
DisableProgramGroupPage=yes
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
Uninstallable=no
SetupIconFile=assets\logo.ico

[Files]
Source: "SrcHelios\*"; DestDir: "{tmp}\mods"; Flags: ignoreversion recursesubdirs createallsubdirs

[Languages]
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"; InfoBeforeFile: "assets\welcome_chs.txt"; LicenseFile: "assets\license_chs.txt";
//Name: "chinesetraditional"; MessagesFile: "InstallerL10n\ChineseTraditional.isl"; InfoBeforeFile: "assets\welcome_cht.txt"; LicenseFile: "assets\license_cht.txt";
Name: "english"; MessagesFile: "compiler:Default.isl"; InfoBeforeFile: "assets\welcome_en.txt"; LicenseFile: "assets\license_en.txt";
//Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"; InfoBeforeFile: "assets\welcome_ru.txt"; LicenseFile: "assets\license_ru.txt";

[Code]
function GetInstallRootFromRegistry(): String;
begin
  if RegQueryStringValue(HKEY_CURRENT_USER, 'Software\Classes\lgc\DefaultIcon', '', Result) then
  begin
    if Pos(',', Result) > 0 then
      Result := Copy(Result, 1, Pos(',', Result) - 1);
    Result := ExtractFilePath(Result);
    Log('Registry path resolved to: ' + Result);
  end
  else
  begin
    Result := 'C:\ProgramData\Lesta\GameCenter\';
    Log('Registry key not found. Using fallback: ' + Result);
  end;
end;

function CheckGameInfo(filePath: String): Boolean;
var
  Lines: TArrayOfString;
  i: Integer;
  s: String;
begin
  Result := False;
  if not LoadStringsFromFile(filePath, Lines) then Exit;
  for i := 0 to GetArrayLength(Lines) - 1 do
  begin
    s := Trim(Lines[i]);
    if Pos('<id>', s) > 0 then
    begin
      StringChange(s, '<id>', '');
      StringChange(s, '</id>', '');
      // 若要安装到PT端，将下一行的值改为——'WOWS.RPT.PRODUCTION'
      if (s = 'WOWS.RU.PRODUCTION') or (s = 'WOWS.RPT.PRODUCTION') then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function ExtractWorkingDirs(xmlPath: String; var dirs: TArrayOfString): Boolean;
var
  Lines: TArrayOfString;
  i, count: Integer;
  dir: String;
begin
  Result := False;
  count := 0;
  if not LoadStringsFromFile(xmlPath, Lines) then Exit;
  for i := 0 to GetArrayLength(Lines) - 1 do
  begin
    dir := Trim(Lines[i]);
    if Pos('<working_dir>', dir) > 0 then
    begin
      StringChange(dir, '<working_dir>', '');
      StringChange(dir, '</working_dir>', '');
      if FileExists(dir + '\game_info.xml') then
      begin
        if CheckGameInfo(dir + '\game_info.xml') then
        begin
          SetArrayLength(dirs, count + 1);
          dirs[count] := dir;
          count := count + 1;
        end;
      end;
    end;
  end;
  Result := count > 0;
end;

function IsNumericDir(name: String): Boolean;
var i: Integer;
begin
  Result := True;
  for i := 1 to Length(name) do
    if (name[i] < '0') or (name[i] > '9') then
    begin
      Result := False;
      Break;
    end;
end;

function DirHasResSubdir(path: String): Boolean;
begin
  Result := DirExists(path + '\res');
end;

procedure GetTopTwoValidNumericBinDirs(basePath: String; var dir1, dir2: String);
var
  binPath: String;
  FindRec: TFindRec;
  n, max1, max2: Integer;
  cur: String;
begin
  max1 := -1;
  max2 := -1;
  dir1 := '';
  dir2 := '';
  binPath := basePath + '\bin';
  if not DirExists(binPath) then Exit;

  if FindFirst(binPath + '\*', FindRec) then
  begin
    try
      repeat
        if ((FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY) <> 0) and
           (FindRec.Name <> '.') and (FindRec.Name <> '..') and IsNumericDir(FindRec.Name) then
        begin
          cur := binPath + '\' + FindRec.Name;
          if DirHasResSubdir(cur) then
          begin
            n := StrToInt(FindRec.Name);
            if n > max1 then
            begin
              max2 := max1;
              dir2 := dir1;
              max1 := n;
              dir1 := FindRec.Name;
            end
            else if n > max2 then
            begin
              max2 := n;
              dir2 := FindRec.Name;
            end;
          end;
        end;
      until not FindNext(FindRec);
    finally
      FindClose(FindRec);
    end;
  end;
end;

procedure CopyDirectoryTree(const SourceDir, TargetDir: string);
var
  FindRec: TFindRec;
  SourcePath, TargetPath: string;
begin
  if FindFirst(SourceDir + '\*', FindRec) then
  begin
    try
      repeat
        SourcePath := SourceDir + '\' + FindRec.Name;
        TargetPath := TargetDir + '\' + FindRec.Name;
        if FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY <> 0 then
        begin
          if (FindRec.Name <> '.') and (FindRec.Name <> '..') then
          begin
            ForceDirectories(TargetPath);
            CopyDirectoryTree(SourcePath, TargetPath); // recursive
          end;
        end
        else
        begin
          Log('Copying file: ' + SourcePath + ' -> ' + TargetPath);
          CopyFile(SourcePath, TargetPath, False);
        end;
      until not FindNext(FindRec);
    finally
      FindClose(FindRec);
    end;
  end;
end;


procedure CurStepChanged(CurStep: TSetupStep);
var
  basePath, xmlPath: String;
  gameDirs: TArrayOfString;
  i: Integer;
  d1, d2, target1, target2: String;
begin
  if CurStep = ssPostInstall then
  begin
    basePath := GetInstallRootFromRegistry();
    xmlPath := basePath + 'preferences.xml';
    if ExtractWorkingDirs(xmlPath, gameDirs) then
    begin
      for i := 0 to GetArrayLength(gameDirs) - 1 do
      begin
        Log('Found valid working_dir: ' + gameDirs[i]);
        GetTopTwoValidNumericBinDirs(gameDirs[i], d1, d2);
        if d1 <> '' then
        begin
          target1 := gameDirs[i] + '\bin\' + d1;
          Log('Installing to: ' + target1);
          ForceDirectories(target1);
          CopyDirectoryTree(ExpandConstant('{tmp}\mods'), target1);
        end;
        if d2 <> '' then
        begin
          target2 := gameDirs[i] + '\bin\' + d2;
          Log('Installing to: ' + target2);
          ForceDirectories(target2);
          CopyDirectoryTree(ExpandConstant('{tmp}\mods'), target2);
        end;
      end;
    end
    else
      MsgBox('Unable to parse working_dir in the preferences.xml, or game_info.xml invalid.', mbError, MB_OK);
  end;
end;
