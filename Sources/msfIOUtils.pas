﻿unit msfIOUtils;

{$INCLUDE msfBase.inc}

{$IFDEF SUPPORTS_SECTION_INTERFACE}
interface
{$ENDIF}

uses
{$IFDEF OS_WIN}
  Windows,
//  Winapi.ShlObj,
//  Winapi.KnownFolders,
//  Winapi.ActiveX,
{$ENDIF}
{$IFDEF SUPPORTS_POSIX}
  fileutil,
  //Posix.SysTypes, Posix.Errno, Posix.Unistd,
{$ENDIF}
{$IFDEF OS_MAC}
{$IFDEF OS_IOS}
  iOSApi.Foundation,
{$ELSE !OS_IOS}
  Macapi.CocoaTypes,
{$ENDIF OS_IOS}
{$ENDIF OS_MAC}
  RTLConsts, SysUtils, Classes, Types, Masks,
  msfErrors;

type
  cEventFile = class abstract
   protected
    var fIsNotError: Boolean;
   protected
    procedure Event(const aPath, aName: String; out aIsContinue: Boolean); virtual; abstract;
   public
    procedure Restart; virtual;
   public
    constructor Create;
  end;

type
  cEventFileAction = class abstract(cEventFile)
   protected var
    fDestPath: String;
    fIsOverwrite: Boolean;
   public
    constructor Create(const aDestPath: String; const aIsOverwrite: Boolean);
  end;

type
  cEventFileCopy = class sealed(cEventFileAction)
   protected
    procedure Event(const aPath, aName: String; out aIsContinue: Boolean); override;
  end;

type
  cEventFileMove = class sealed(cEventFileAction)
   protected
    procedure Event(const aPath, aName: String; out aIsContinue: Boolean); override;
  end;

type
  cEventFileRemove = class sealed(cEventFile)
   protected
    procedure Event(const aPath, aName: String; out aIsContinue: Boolean); override;
  end;

type
  TPathPrefixType = (pptNoPrefix, pptExtended, pptExtendedUNC);

  rPath = {$IFDEF FPC}class{$ELSE}record{$ENDIF}
   private
    const fCCurrentDir = '.'; // DO NOT LOCALIZE
    const fCParentDir = '..'; // DO NOT LOCALIZE
    const fCExtendedPrefix = '\\?\'; // DO NOT LOCALIZE
    const fCExtendedUNCPrefix = '\\?\UNC\'; // DO NOT LOCALIZE
   private
    class var
      FAltDirectorySeparatorChar: Char;
      FDirectorySeparatorChar: Char;
      FPathSeparator: Char;
      FVolumeSeparatorChar: Char;
      FExtensionSeparatorChar: Char;
      FInvalidPathChars: TCharArray;
      FInvalidFileNameChars: TCharArray;
      FFileNameWildCardChars: TCharArray;
   private
    {$IFDEF OS_WIN}
      class function GetPosAfterExtendedPrefix(const Path: string): Integer; overload; inline; static;
      class function GetPosAfterExtendedPrefix(const Path: string; out Prefix: TPathPrefixType): Integer; overload; static;
      class function PrefixExtendsPath(const Prefix: TPathPrefixType): Boolean; inline; static;
    {$ENDIF OS_WIN}
   private
    class function DoCombine(const Path1, Path2: string; const ValidateParams: Boolean): string; static;
    class function HasValidPathChars(const Path: string; const UseWildcards: Boolean): Boolean; static;
    class function DoIsPathRooted(const Path: string; const ValidateParam, UseWildcards: Boolean): Boolean; static;
   public
    class function GetTempFileName: String; static;
    class function GetTempPath: String; static;
   public
    class function Combine(const Path1, Path2: string; const ValidateParams: Boolean = True): string; overload; inline; static;
   public
    class function IsExtendedPrefixed(const Path: string): Boolean; inline; static;
    class function IsPathSeparator(const AChar: Char): Boolean; inline; static;
    class function IsValidPathChar(const AChar: Char): Boolean; inline; static;
    class function IsCharInOrderedArray(const AChar: Char; const AnArray: TCharArray): Boolean; static;
    class function GetExtendedPrefix(const Path: string): TPathPrefixType; static;
   public
    class property ExtensionSeparatorChar: Char read FExtensionSeparatorChar;
    class property AltDirectorySeparatorChar: Char read FAltDirectorySeparatorChar;
    class property DirectorySeparatorChar: Char read FDirectorySeparatorChar;
    class property PathSeparator: Char read FPathSeparator;
    class property VolumeSeparatorChar: Char read FVolumeSeparatorChar;
   public
    class function LibraryPathGet: string; static;
    class function ApplicationPathGet(const aIsDeleteDirectorySeparator: Boolean = False): string; static;
    class function ApplicationBinaryGet: string; static;
    class function ApplicationFileName: string; static;
   public
    class constructor Create;
  end;

type
  rFile = {$IFDEF FPC}class{$ELSE}record{$ENDIF}
   public
    class function OpenRead(const aPath: String): TFileStream; inline; static;
    class function OpenWrite(const aPath: String; const aIsPositionToEnd: Boolean; const aIsRemoveAfterClose: Boolean = False): TFileStream; static;
   public
    class function ReadAllRaw(const aPath: String): RawByteString; {$IFNDEF DEBUG}inline;{$ENDIF DEBUG} static;
   public
    class procedure WriteString(const aPath, aString: String; const aIsContinue: Boolean = False); {$IFNDEF DEBUG}inline;{$ENDIF DEBUG} static;
   public
    class procedure WriteStringRaw(const aPath: String; const aString: RawByteString; const aIsContinue: Boolean = False); {$IFNDEF DEBUG}inline;{$ENDIF DEBUG} static;
   public
    class function Remove(const aPath: String): Boolean; inline; static;
   public
    class function Exists(const aPath: String; aIsFollowLink: Boolean = True): Boolean; static;
   public
    class function Copy(const aSourcePath, aDestPath: String; const aIsOverwrite: Boolean): Boolean; inline; static;
   public
    class function ExtractPath(const aPath: String): String; inline; static;
    class function ExtractName(const aPath: String): String; inline; static;
   public
    class function ChangeExt(const aFileName, aExtension: String): String; inline; static;
    class function ChangePath(const aFileName, aPath: string): string; inline; static;
   public
    class function ReName(const aOldName, aNewName: string): Boolean; static;
    class function Move(const aFilePath, aNewPath: string; const aIsOverwrite: Boolean = False): Boolean; static;
  end;

type
  rDirectory = {$IFDEF FPC}class{$ELSE}record{$ENDIF}
   private
    class procedure innerFilesGet(const aPath, aSearchPattern: String; const aOnlyCurrentDirectory: Boolean; const aCallBack: cEventFile); static;
   public
    class procedure FilesGet(const aPath, aSearchPattern: String; const aOnlyCurrentDirectory: Boolean; const aCallBack: cEventFile); static;
   public
    class function Remove(const aPath: String): Boolean; static; // inline; static;
   public
    class function CopyFiles(const aSourcePath, aDestPath, aSearchPattern: String): Boolean; {inline; } static;
   public
    class function MoveFiles(const aSourcePath: String; aDestPath: String; const aSearchPattern: String): Boolean; {inline; } static;
   public
    class function Exists(const aPath: String): Boolean; inline; static;
  end;

implementation

uses
{$IFDEF SUPPORTS_POSIX}
//f  Posix.Base, Posix.Stdio, Posix.Stdlib, Posix.SysStat, Posix.Time, Posix.Utime,
{$ENDIF}
{$IFDEF OS_MAC}
  Macapi.Helpers,
{$IFDEF OS_IOS}
{$ELSE !OS_IOS}
  Macapi.Foundation,
{$ENDIF OS_IOS}
{$ENDIF OS_MAC}
{$IFDEF OS_WIN}
//  Winapi.SHFolder,
{$ENDIF OS_WIN}
{$IFDEF OS_ANDROID}
  Androidapi.IOUtils,
{$ENDIF}
  StrUtils, DateUtils, Math;

type
  cFileStreamRemoveAfterClose = class sealed(TFileStream)
   private
    var fIsRemove: Boolean;
   public
    constructor Create(const aFileName: string; aMode: Word; const aIsRemove: Boolean); reintroduce;
    destructor Destroy; override;
  end;


class function rPath.ApplicationBinaryGet: String;
begin
  Result := ParamStr(0)
end;

class function rPath.ApplicationFileName: String;
begin
  Result := rFile.ExtractName(ApplicationBinaryGet)
end;

class function rPath.ApplicationPathGet(const aIsDeleteDirectorySeparator: Boolean): String;
begin
  Result := rFile.ExtractPath(rPath.ApplicationBinaryGet);
  if (aIsDeleteDirectorySeparator = False) then
    Exit;
  if (Result = '') then
    Exit;
  if (Result[Length(Result)] = DirectorySeparatorChar) then
    SetLength(Result, High(Result));
end;

class function rPath.Combine(const Path1, Path2: string; const ValidateParams: Boolean): string;
begin
  Result := DoCombine(Path1, Path2, ValidateParams);
end;

class constructor rPath.Create;
begin
  Randomize;

  { Common on all platforms }
  FAltDirectorySeparatorChar := '/'; // DO NOT LOCALIZE;
  FExtensionSeparatorChar := '.';    // DO NOT LOCALIZE;
  FFileNameWildcardChars := TCharArray.Create('*', '?'); // DO NOT LOCALIZE;

{$IFDEF OS_WIN}
  FDirectorySeparatorChar := '\';    // DO NOT LOCALIZE;
  FPathSeparator := ';';             // DO NOT LOCALIZE;
  FVolumeSeparatorChar := ':';       // DO NOT LOCALIZE;

  FInvalidPathChars := TCharArray.Create(#0, #1, #2, #3, #4, #5, #6, #7, #8, #9, #10, #11, #12, #13, #14, #15, #16, #17, #18, #19, #20, #21, #22, #23,
    #24, #25, #26, #27, #28, #29, #30, #31, '"', '<', '>', '|');            // DO NOT LOCALIZE;

  FInvalidFileNameChars := TCharArray.Create(#0, #1, #2, #3, #4, #5, #6, #7, #8, #9, #10, #11, #12, #13, #14, #15, #16, #17, #18, #19, #20, #21, #22,
    #23, #24, #25, #26, #27, #28, #29, #30, #31, '"', '*', '/', ':', '<', '>', '?', '\', '|');  // DO NOT LOCALIZE;
{$ENDIF}
{$IFDEF SUPPORTS_POSIX}
  FDirectorySeparatorChar := '/';    // DO NOT LOCALIZE;
  FPathSeparator := ':';             // DO NOT LOCALIZE;
  FVolumeSeparatorChar := #0;        // Not supported on Unix;

  FInvalidPathChars := TCharArray.Create(
    #0, #1, #2, #3, #4, #5, #6, #7, #8, #9, #10, #11, #12,
    #13, #14, #15, #16, #17, #18, #19, #20, #21, #22, #23, #24,
    #25, #26, #27, #28, #29, #30, #31);

  FInvalidFileNameChars := TCharArray.Create(
    #0, #1, #2, #3, #4, #5, #6, #7, #8, #9, #10, #11, #12,
    #13, #14, #15, #16, #17, #18, #19, #20, #21, #22, #23, #24,
    #25, #26, #27, #28, #29, #30, #31, '/', '~');
{$ENDIF}
end;

type
  EInOutArgumentException = class(Exception);

class function rPath.DoCombine(const Path1, Path2: string; const ValidateParams: Boolean): string;
var
  Ch: Char;
begin
  // if one path is empty, return the other one
  if Path1 = '' then // DO NOT LOCALIZE
    Result := Path2
  else
    if Path2 = '' then // DO NOT LOCALIZE
      Result := Path1
    else
    begin
      // paths are not empty strings; check if they have invalid chars
      if ValidateParams then
      begin
        if not HasValidPathChars(Path1, True) then
          raise EInOutArgumentException.CreateFmt(rsInvalidCharsInPath, [Path1]);
        if not HasValidPathChars(Path2, True) then
          raise EInOutArgumentException.CreateFmt(rsInvalidCharsInPath, [Path2]);
      end;

      // if Path2 is absolute, return it; if not, combine the paths
      if DoIsPathRooted(Path2, ValidateParams, True) or IsExtendedPrefixed(Path2) then
        Result := Path2
      else
      begin
        Ch := Path1[High(Path1)];

        if not IsPathSeparator(Ch) then
          Result := Path1 + DirectorySeparatorChar + Path2
        else
          Result := Path1 + Path2;
      end;
    end;
end;

class function rPath.DoIsPathRooted(const Path: string; const ValidateParam, UseWildcards: Boolean): Boolean;
{$IFDEF OS_WIN}
var
  PPath: PChar;
  Prefix: TPathPrefixType;
  StartIdx: Integer;
  Len: Integer;
begin
  Result := False;
  if Path <> '' then // DO NOT LOCALIZE
  begin
    if ValidateParam and (not HasValidPathChars(Path, UseWildcards)) then
      raise EInOutArgumentException.CreateResFmt(@rsInvalidCharsInPath, [Path]);

    // Path is rooted if either it starts with Directory-/AltDirectory- SeparatorChar,
    // either the second char is a VolumeSeparatorChar
    StartIdx := GetPosAfterExtendedPrefix(Path, Prefix);
    PPath := PChar(Path);
    Len := Length(Path) - StartIdx + 1;
    // check if drive rooted
    Result := (Len >= 2) and
              (PPath[StartIdx] = VolumeSeparatorChar);
    // check if backslash rooted without prefix (so it is valid)
    Result := Result or
              (Prefix = TPathPrefixType.pptNoPrefix) and
              (Len >= 1) and ((PPath[StartIdx - 1] = DirectorySeparatorChar) or
                              (PPath[StartIdx - 1] = AltDirectorySeparatorChar));
    // check if UNC rooted with prefix
    Result := Result or
              (Prefix = TPathPrefixType.pptExtendedUNC) and
              IsValidPathChar(PPath[StartIdx - 1]);
  end;
end;
{$ENDIF OS_WIN}
{$IFDEF SUPPORTS_POSIX}
begin
  { Check the first char of the path (must be /) for rooted paths on Unixes }
  Result := (Path <> '') and (Path[Low(string)] = DirectorySeparatorChar); // DO NOT LOCALIZE
end;
{$ENDIF SUPPORTS_POSIX}

{$IFDEF OS_WIN}
class function rPath.GetPosAfterExtendedPrefix(const Path: string; out Prefix: TPathPrefixType): Integer;
begin
  Prefix := GetExtendedPrefix(Path);
  case Prefix of
    TPathPrefixType.pptNoPrefix:
      Result := 1;
    TPathPrefixType.pptExtended:
      Result := Length(FCExtendedPrefix) + 1;
    TPathPrefixType.pptExtendedUNC:
      Result := Length(FCExtendedUNCPrefix) + 1;
  else
    Result := 1;
  end;
end;

class function rPath.GetPosAfterExtendedPrefix(const Path: string): Integer;
var
  Prefix: TPathPrefixType;
begin
  Result := GetPosAfterExtendedPrefix(Path, Prefix);
end;

class function rPath.PrefixExtendsPath(const Prefix: TPathPrefixType): Boolean;
begin
  Result := Prefix in [TPathPrefixType.pptExtended, TPathPrefixType.pptExtendedUNC]
end;
{$ENDIF OS_WIN}

class function rPath.GetTempFileName: String;
{$IFDEF OS_WIN}
var
  TempPath: String;
  ErrCode: UINT;
begin
  TempPath := GetTempPath;
  SetLength(Result, MAX_PATH);

  SetLastError(ERROR_SUCCESS);
  ErrCode := Windows.GetTempFileName(PChar(TempPath), 'tmp', 0, PChar(Result)); // DO NOT LOCALIZE
  if ErrCode = 0 then
    raise EInOutError.Create(SysErrorMessage(GetLastError));

  SetLength(Result, StrLen(PChar(Result)));
end;
{$ENDIF}
{$IFDEF SUPPORTS_POSIX}
{$IFDEF OS_LINUX}
  function RandomName: String;
  var
    LRand: TGUID;
  begin
    LRand := TGUID.NewGuid;
    Result := Format('File_%8x%4x%4x%16x_tmp', [LRand.D1, LRand.D2, LRand.D3, PInt64(@LRand.D4[0])^]);
  end;
begin
  { Obtain a temporary file name }
  repeat
    Result := rPath.Combine(GetTempPath, RandomName);
  until (not FileExists(Result, False));
end;
{$ELSE !OS_LINUX}
var
  LTempPath: TBytes;
  M: TMarshaller;
  LRet: MarshaledAString;
begin
//   char * tempnam(const char *dir, const char *pfx);

  { Obtain a temporary file name }
  // This code changed from getting the temp name from the temp path via system
  // to get the temp name inside the specified temp path. We get the system temp path.
//  LTempPath := TEncoding.UTF8.GetBytes(String(tmpnam(nil)));
  LRet := tempnam(MarshaledAString(M.AsUTF8(GetTempPath).ToPointer),nil);
  LTempPath := TEncoding.UTF8.GetBytes(String(LRet));
  free(LRet);

  { Convert to UTF16 or leave blank on possible error }
  if LTempPath <> nil then
    Result := TEncoding.UTF8.GetString(LTempPath)
  else
    Result := '';
end;
{$ENDIF OS_LINUX}
{$ENDIF SUPPORTS_POSIX}

class function rPath.HasValidPathChars(const Path: string; const UseWildcards: Boolean): Boolean;
var
  PPath: PChar;
  PathLen: Integer;
  Ch: Char;
  S: Integer;
  I: Integer;
begin
  // Result will become True if an invalid path char is found
  PathLen := Length(Path);
  if PathLen > 0 then
  begin
  {$IFDEF OS_WIN}
    S := GetPosAfterExtendedPrefix(Path) - 1;
  {$ENDIF OS_WIN}
  {$IFDEF SUPPORTS_POSIX}
    S := 0;
  {$ENDIF SUPPORTS_POSIX}
    PPath := PChar(Path);
    for I := S to PathLen - 1 do
    begin
      Ch := PPath[I];
     {$IFDEF OS_WIN}
      if (Ch = '?') or (Ch = '*') then
        if not UseWildcards then
          Exit(False);
     {$ENDIF}
      if not IsValidPathChar(Ch) then
        Exit(False);
    end;
  end;
  Result := True;
end;

class function rPath.GetTempPath: String;
{$IFDEF OS_WIN}
var
  Tmp: array[0..MAX_PATH] of Char;
  Len: Integer;
begin
  SetLastError(ERROR_SUCCESS);

  Len := Windows.GetTempPath(MAX_PATH, Tmp);
  if Len <> 0 then
  begin
    Len := GetLongPathName(Tmp, nil, 0);
    SetLength(Result, Len - 1);
    GetLongPathName(Tmp, PChar(Result), Len);
  end
  else
    Result := '';
end;
{$ENDIF}
{$IFDEF SUPPORTS_POSIX}
{$IF defined(OS_IOS) and defined(CPUARM)}
begin
  // This is the only temporary path that we can write under IOS Device
  result := ExpandFileName('~/tmp/');
end;
{$ELSEIF defined(OS_ANDROID)}
begin
  Result := GetExternalFilesDir+'/tmp';
  // Ensure that the folder exists.
  ForceDirectories(Result);
end;
{$ELSE}
const
  CTmpDir = '/tmp'; // Do not localize

var
  LTempPathVar: String;
begin
  Result := CTmpDir;

  LTempPathVar := GetEnvironmentVariable('TMP');
  if (LTempPathVar = '') then
  begin
    LTempPathVar := GetEnvironmentVariable('TMPDIR');
    if (LTempPathVar = '') then
      LTempPathVar := GetEnvironmentVariable('TEMP');
  end;

//  if (LTempPathVar > '') then
//    Result := UTF8ToString(LTempPathVar);
end;
{$ENDIF defined(OS_IOS) and defined(CPUARM)}
{$ENDIF SUPPORTS_POSIX}

class function rPath.IsCharInOrderedArray(const AChar: Char; const AnArray: TCharArray): Boolean;
var
  LeftIdx, RightIdx: Integer;
  MidIdx: Integer;
  MidChar: Char;
begin
  // suppose AChar is not present in AnArray
  Result := False;

  // the code point of AChar is in the range of the chars bounding the string;
  // use divide-et-impera to search AChar in AnArray
  LeftIdx := 0;
  RightIdx := Length(AnArray) - 1;
  if (RightIdx >= 0) and (AnArray[LeftIdx] <= AChar) and (AChar <= AnArray[RightIdx]) then
    repeat
      MidIdx := LeftIdx + (RightIdx - LeftIdx) div 2;
      MidChar := AnArray[MidIdx];
      if AChar < MidChar then
        RightIdx := MidIdx - 1
      else
        if AChar > MidChar then
          LeftIdx := MidIdx + 1
        else
          Result := True;
    until (Result) or (LeftIdx > RightIdx);
end;

class function rPath.GetExtendedPrefix(const Path: string): TPathPrefixType;
begin
  {$IFDEF OS_WIN}
    Result := TPathPrefixType.pptNoPrefix;
    if Path <> '' then
    begin
      if Path.StartsWith(FCExtendedUNCPrefix, True) then
        Result := TPathPrefixType.pptExtendedUNC
      else
        if Path.StartsWith(FCExtendedPrefix) then
          Result := TPathPrefixType.pptExtended;
    end;
  {$ENDIF OS_WIN}
  {$IFDEF SUPPORTS_POSIX}
    Result := TPathPrefixType.pptNoPrefix;  // No support for extended prefixes on Unixes
  {$ENDIF SUPPORTS_POSIX}
end;

class function rPath.IsExtendedPrefixed(const Path: string): Boolean;
begin
  {$IFDEF OS_WIN}
    Result := PrefixExtendsPath(GetExtendedPrefix(Path));
  {$ENDIF OS_WIN}
  {$IFDEF SUPPORTS_POSIX}
    Result := false;  // No support for extended prefixes on Unixes
  {$ENDIF SUPPORTS_POSIX}
end;

class function rPath.IsPathSeparator(const AChar: Char): Boolean;
begin
  {$IFDEF OS_WIN}
    Result := (AChar = DirectorySeparatorChar) or
              (AChar = AltDirectorySeparatorChar) or
              (AChar = VolumeSeparatorChar);
  {$ENDIF OS_WIN}
  {$IFDEF SUPPORTS_POSIX}
    Result := AChar = DirectorySeparatorChar;
  {$ENDIF}
end;

class function rPath.IsValidPathChar(const AChar: Char): Boolean;
begin
  Result := not IsCharInOrderedArray(AChar, FInvalidPathChars)
end;

class function rPath.LibraryPathGet: string;
begin
  {$IFDEF OS_WIN}
    Result := rPath.ApplicationPathGet;
  {$ENDIF}
  {$IFDEF SUPPORTS_POSIX}
    {$IFDEF OS_MACOS}
      Result := TPath.InternalGetMACOSPath(NSLibraryDirectory, NSUserDomainMask);
    {$ENDIF OS_MACOS}
    {$IFDEF OS_ANDROID}
      Result := AndroidApi.IOUtils.GetLibraryPath;
    {$ENDIF OS_ANDROID}
    {$IFDEF OS_LINUX}
      Result := GetCurrentDir;
    {$ENDIF OS_LINUX}
  {$ENDIF SUPPORTS_POSIX}
end;

{ rFile }

class function rFile.ChangeExt(const aFileName, aExtension: String): String;
var
  LIndex, LSize: NativeInt;
begin
  {$IFDEF FPC}
    LIndex := aFileName.LastDelimiter('.' + PathDelim {$IFDEF OS_WIN} + DriveDelim {$ENDIF});
  {$ELSE}
    LIndex := aFileName.LastDelimiter(['.', PathDelim {$IFDEF OS_WIN}, DriveDelim {$ENDIF}]);
  {$ENDIF}
  if (LIndex < 0) or (aFileName.Chars[LIndex] <> '.') then
  begin
    Result := aFileName + aExtension;
    Exit
  end;

  LSize := Length(aExtension);
  SetLength(Result, LIndex + LSize);
  System.Move(aFileName[1], Result[1], LIndex * SizeOf(Char));
  if (LSize > 0) then
    System.Move(aExtension[1], Result[1 + LIndex], LSize * SizeOf(Char));
end;

class function rFile.ReName(const aOldName, aNewName: string): Boolean;
{$IFDEF SUPPORTS_POSIX}
// var
//  M1, M2: TMarshaller;
{$ENDIF SUPPORTS_POSIX}
begin
{$IFDEF OS_WIN}
  Result := MoveFile(PChar(aOldName), PChar(aNewName));
{$ENDIF OS_WIN}
{$IFDEF SUPPORTS_POSIX}
  if CopyFile(aOldName, aNewName, [cffOverwriteFile]) then
     Result := Remove(aOldName);
  //Result := __rename( M1.AsAnsi(aOldName, CP_UTF8).ToPointer, M2.AsAnsi(aNewName, CP_UTF8).ToPointer) = 0;
{$ENDIF SUPPORTS_POSIX}
end;

class function rFile.ChangePath(const aFileName, aPath: string): string;
begin
  Result := IncludeTrailingPathDelimiter(aPath) + ExtractFileName(aFileName);
end;

class function rFile.Copy(const aSourcePath, aDestPath: String; const aIsOverwrite: Boolean): Boolean;
 var
  LSource, LDest: TFileStream;
begin
  Result := False;

  if Exists(aDestPath) then
    if (aIsOverwrite = False) then
      Exit;

  if (Exists(aSourcePath) = False) then
    Exit;

  LSource := nil;
  LDest := nil;
  try
    try
      LSource := TFileStream.Create(aSourcePath, fmOpenRead or fmShareDenyWrite);
      LDest := TFileStream.Create(aDestPath, fmOpenWrite or fmCreate);
      LDest.CopyFrom(LSource, LSource.Size);
      Result := True
    except
    end;
  finally
    LDest.Free;
    LSource.Free;
  end;
end;

class function rFile.Exists(const aPath: String; aIsFollowLink: Boolean): Boolean;
{$IFDEF OS_WIN}

  function innerExistsLockedOrShared(const aPath: string): Boolean;
   var
    FindData: TWin32FindData;
    LHandle: THandle;
  begin
    Result := False;
    LHandle := FindFirstFile(PChar(aPath), FindData);
    if (LHandle = INVALID_HANDLE_VALUE) then
      Exit;
    Windows.FindClose(LHandle);
    Result := ((FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0)
  end;

var
  LFlags: Cardinal;
  LHandle: THandle;
  LLastError: Cardinal;
begin
  LFlags := GetFileAttributes(PChar(aPath));

  if (LFlags <> INVALID_FILE_ATTRIBUTES) then
  begin
    if ((faSymLink and LFlags) <> 0) then
    begin
      if (aIsFollowLink = False) then
        Exit(True);
      if (faDirectory and LFlags <> 0) then
        Exit(False);
      LHandle := CreateFile(PChar(aPath), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
      if (LHandle <> INVALID_HANDLE_VALUE) then
      begin
        CloseHandle(LHandle);
        Exit(True);
      end;
      LLastError := GetLastError;
      Exit(LLastError = ERROR_SHARING_VIOLATION);
    end;

    Exit(faDirectory and LFlags = 0);
  end;

  LLastError := GetLastError;
  Result := (LLastError <> ERROR_FILE_NOT_FOUND) and (LLastError <> ERROR_PATH_NOT_FOUND) and (LLastError <> ERROR_INVALID_NAME) and innerExistsLockedOrShared(aPath);
end;
{$ENDIF OS_WIN}

{$IFDEF SUPPORTS_POSIX}
//var
//  StatBuf: _stat;
//  M: TMarshaller;
begin
  Result := FileExists(aPath, aIsFollowLink);
  //if lstat(M.AsAnsi(aPath, CP_UTF8).ToPointer, StatBuf) = 0 then
  //begin
  //  if S_ISLNK(StatBuf.st_mode) then
  //  begin
  //    if (aIsFollowLink = False) then
  //      Exit(True);
  //    if stat(M.AsAnsi(aPath, CP_UTF8).ToPointer, StatBuf) = 0 then
  //      Exit(not S_ISDIR(StatBuf.st_mode));
  //    Exit(False);
  //  end;
  //
  //  Exit(not S_ISDIR(StatBuf.st_mode));
  //end;
  //
  //Result := False;
end;
{$ENDIF SUPPORTS_POSIX}

class function rFile.ReadAllRaw(const aPath: String): RawByteString;
 var
  LFile: TFileStream;
begin
  LFile := nil;
  try
    LFile := OpenRead(aPath);
    SetLength(Result, LFile.Size);
    LFile.ReadBuffer(Pointer(Result)^, Length(Result));
  finally
    LFile.Free
  end;
end;

class function rFile.Remove(const aPath: String): Boolean;
begin
  Result := DeleteFile(aPath)
end;

class procedure rFile.WriteString(const aPath, aString: String; const aIsContinue: Boolean);
begin
  WriteStringRaw(aPath, RawByteString(aString), aIsContinue);
end;

class procedure rFile.WriteStringRaw(const aPath: String; const aString: RawByteString; const aIsContinue: Boolean);
 var
  LFile: TFileStream;
begin
  LFile := nil;
  try
    LFile := OpenWrite(aPath, aIsContinue);
    if (aIsContinue = False) then
    begin
      LFile.Size := Length(aString);
      LFile.Position := 0;
    end;
    LFile.WriteBuffer(PAnsiChar(aString)^, Length(aString));
  finally
    LFile.Free
  end;
end;

class function rFile.ExtractName(const aPath: String): String;
 var
  LIndex: NativeInt;
  LChars: {$IFDEF FPC}String{$ELSE}TSysCharSet{$ENDIF};
begin
  LChars := {$IFDEF FPC}rPath.DirectorySeparatorChar{$ELSE}[rPath.DirectorySeparatorChar]{$ENDIF};
  {$IFDEF OS_WIN}
    LChars := LChars + {$IFDEF FPC}rPath.VolumeSeparatorChar{$ELSE}[rPath.VolumeSeparatorChar]{$ENDIF};
  {$ENDIF}
  LIndex := aPath.LastDelimiter(LChars);

  if (LIndex >= 0) then
    Result := System.Copy(aPath, LIndex + 2)
  else
    Result := aPath
end;

class function rFile.ExtractPath(const aPath: String): String;
 var
  LIndex: NativeInt;
  LChars: {$IFDEF FPC}String{$ELSE}TSysCharSet{$ENDIF};
begin
  LChars := {$IFDEF FPC}rPath.DirectorySeparatorChar{$ELSE}[rPath.DirectorySeparatorChar]{$ENDIF};
  {$IFDEF OS_WIN}
    LChars := LChars + {$IFDEF FPC}rPath.VolumeSeparatorChar{$ELSE}[rPath.VolumeSeparatorChar]{$ENDIF};
  {$ENDIF}
  LIndex := aPath.LastDelimiter(LChars);
  Result := System.Copy(aPath, 1, LIndex + 1);
end;

class function rFile.Move(const aFilePath, aNewPath: string; const aIsOverwrite: Boolean): Boolean;
 var
  LNewPath: String;
begin
  LNewPath := ChangePath(aFilePath, aNewPath);
  if aIsOverwrite then
    rFile.Remove(LNewPath);
  Result := ReName(aFilePath, LNewPath);
end;

class function rFile.OpenRead(const aPath: String): TFileStream;
begin
  Result := TFileStream.Create(aPath, fmOpenRead);
  Result.Position := 0;
end;

class function rFile.OpenWrite(const aPath: String; const aIsPositionToEnd: Boolean; const aIsRemoveAfterClose: Boolean): TFileStream;
begin
  if rFile.Exists(aPath) then
    Result := cFileStreamRemoveAfterClose.Create(aPath, fmOpenReadWrite, aIsRemoveAfterClose)
  else
    Result := cFileStreamRemoveAfterClose.Create(aPath, fmCreate or fmOpenReadWrite, aIsRemoveAfterClose);
  if aIsPositionToEnd then
    Result.Position := Result.Size
  else
    Result.Position := 0;
end;

{ rDirectory }

class function rDirectory.CopyFiles(const aSourcePath, aDestPath, aSearchPattern: String): Boolean;
 var
  LEvent: cEventFileAction;
begin
  Result := False;
  if (rDirectory.Exists(aDestPath) = False) then
    Exit;
  LEvent := nil;
  try
    LEvent := cEventFileCopy.Create(aDestPath, True);
    rDirectory.FilesGet(aSourcePath, aSearchPattern, True, LEvent);
    Result := LEvent.fIsNotError
  finally
    LEvent.Free
  end;
end;

class function rDirectory.Exists(const aPath: String): Boolean;
begin
  Result := DirectoryExists(aPath)
end;

class procedure rDirectory.FilesGet(const aPath, aSearchPattern: String; const aOnlyCurrentDirectory: Boolean; const aCallBack: cEventFile);
begin
  innerFilesGet(IncludeTrailingPathDelimiter(aPath), aSearchPattern, aOnlyCurrentDirectory, aCallBack)
end;

class procedure rDirectory.innerFilesGet(const aPath, aSearchPattern: String; const aOnlyCurrentDirectory: Boolean; const aCallBack: cEventFile);
 var
  LSearchRec: TSearchRec;
  LIsContinue: Boolean;
  LAttr: Integer;
begin
  LAttr := faAnyFile;
  if aOnlyCurrentDirectory then
    LAttr := LAttr - faDirectory;
  if (FindFirst(aPath + '*.*', LAttr, LSearchRec) = 0) then
  begin
    LIsContinue := True;
    while LIsContinue do
      try
        if ((LSearchRec.Attr and faDirectory) = faDirectory) then
        begin
          if aOnlyCurrentDirectory then
            Continue;
          if (LSearchRec.name = '.') then
            Continue;
          if (LSearchRec.name = '..') then
            Continue;
          innerFilesGet(IncludeTrailingPathDelimiter(aPath + LSearchRec.name), aSearchPattern, aOnlyCurrentDirectory, aCallBack);
          Continue;
        end;

        if MatchesMask(LSearchRec.Name, aSearchPattern) then
        begin
          LIsContinue := True;
          aCallBack.Event(aPath, LSearchRec.Name, LIsContinue);
          if (LIsContinue = False) then
            Break
        end

      finally
        LIsContinue := (FindNext(LSearchRec) = 0)
      end;
    FindClose(LSearchRec);
  end;

end;

class function rDirectory.MoveFiles(const aSourcePath: String; aDestPath: String; const aSearchPattern: String): Boolean;
 var
  LEvent: cEventFileAction;
begin
  Result := False;
  if (rDirectory.Exists(aDestPath) = False) then
    Exit;
  LEvent := nil;
  try
    LEvent := cEventFileMove.Create(aDestPath, True);
    rDirectory.FilesGet(aSourcePath, aSearchPattern, True, LEvent);
    Result := LEvent.fIsNotError
  finally
    LEvent.Free
  end;
end;

class function rDirectory.Remove(const aPath: String): Boolean;
 var
  LEvent: cEventFile;
begin
  Result := False;
  if (rDirectory.Exists(aPath) = False) then
    Exit;
  LEvent := nil;
  try
    LEvent := cEventFileRemove.Create;
    rDirectory.FilesGet(aPath, '*.*', True, LEvent);
    Result := LEvent.fIsNotError
  finally
    LEvent.Free
  end;
  if Result then
    Result := RemoveDir(aPath)
end;

{ cEventFile }

constructor cEventFile.Create;
begin
  inherited Create;
  Restart
end;

procedure cEventFile.Restart;
begin
  fIsNotError := True
end;

{ cEventFileAction }

constructor cEventFileAction.Create(const aDestPath: String; const aIsOverwrite: Boolean);
begin
  inherited Create();
  fIsOverwrite := aIsOverwrite;
  fDestPath := IncludeTrailingPathDelimiter(aDestPath)
end;

{ cEventFileCopy }

procedure cEventFileCopy.Event(const aPath, aName: String; out aIsContinue: Boolean);
begin
  fIsNotError := rFile.Copy(aPath + aName, fDestPath + aName, fIsOverwrite);
  aIsContinue := fIsNotError
end;

{ cEventFileMove }

procedure cEventFileMove.Event(const aPath, aName: String; out aIsContinue: Boolean);
begin
  fIsNotError := rFile.Move(aPath + aName, fDestPath, fIsOverwrite);
  aIsContinue := fIsNotError
end;

{ cEventFileRemove }

procedure cEventFileRemove.Event(const aPath, aName: String; out aIsContinue: Boolean);
begin
  fIsNotError := rFile.Remove(aPath + aName);
  aIsContinue := fIsNotError
end;

{ cFileStreamRemoveAfterClose }

constructor cFileStreamRemoveAfterClose.Create(const aFileName: string; aMode: Word; const aIsRemove: Boolean);
begin
  inherited Create(aFileName, aMode);
  fIsRemove := aIsRemove;
end;

destructor cFileStreamRemoveAfterClose.Destroy;
 var
  LPath: String;
begin
  if fIsRemove then
    LPath := FileName
  else
    LPath := '';
  inherited;
  if (LPath > '') then
    rFile.Remove(LPath)
end;

end.
