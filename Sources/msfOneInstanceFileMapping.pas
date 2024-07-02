unit msfOneInstanceFileMapping;

{$INCLUDE msfBase.inc}

{$IFDEF SUPPORTS_SECTION_INTERFACE}
interface
{$ENDIF}

uses
  {$IFDEF OS_WIN}
    Windows,
  {$ENDIF OS_WIN}
  {$IFDEF SUPPORTS_POSIX}
    //Posix.Base, Posix.Dlfcn, Posix.Fcntl, Posix.SysStat, Posix.SysTime, Posix.SysTypes, Posix.Locale,
  {$ENDIF SUPPORTS_POSIX}
  SysUtils, Classes;

function IsOneInstance(const aName: string): Boolean;
function IsOneInstanceFile(const aName, aPath: string): TStream;

implementation

const
  cMemFileSize = 1024;


function IsOneInstanceFile(const aName, aPath: string): TStream;
begin
  try
    Result := TFileStream.Create(IncludeTrailingPathDelimiter(aPath) + aName, fmCreate or fmOpenReadWrite, fmShareExclusive);
  except
    Result := nil;
  end;
end;

{$IFDEF SUPPORTS_POSIX}
const
  libc = 'libc.so';
  _PU = '';

  O_RDWR   = $2;
  O_CREAT  = $42;

  S_IRGRP  = $0020;

  S_IROTH  = $0004;

  S_IREAD  = $0100;
  S_IWRITE = $0080;

  S_IRUSR  = S_IREAD;
  S_IWUSR  = S_IWRITE;

function shm_open(aName: PAnsiChar; aFlag: Int32; aMode: UInt32): Int32;  cdecl; external libc name  _PU + 'shm_open';
function shm_unlink(aName: PAnsiChar): Int32; cdecl; external libc name  _PU + 'shm_unlink';
function mmap(aAddr: Pointer; aLen: UInt32; aProtected, aFlags, aHandle, aOffset: Int32): Pointer; cdecl; external libc name _PU + 'mmap';
function ftruncate(aHandle, aLength: Int32): Int32; cdecl; external libc name _PU + 'ftruncate';

function IsOneInstance(const aName: string): Boolean;
 var
  fd: integer;
  LName: AnsiString;
begin
  if (aName = '') then
    raise Exception.Create('Name is empty for IsOneInstance');

  Result := True;
  LName := AnsiString(aName);
  fd := shm_open(@LName[1], O_RDWR or O_CREAT, S_IRUSR or S_IWUSR or S_IRGRP or S_IROTH);
  ftruncate(fd, cMemFileSize);
  //mmap(nil, cMemFileSize, PROT_READ or PROT_WRITE, MAP_SHARED, fd, 0);
end;

{$ENDIF SUPPORTS_POSIX}

{$IFDEF OS_WIN}

const
  cHandleDefault = INVALID_HANDLE_VALUE;

var
  LHandle: THandle = cHandleDefault;

function IsOneInstance(const aName: string): Boolean;
begin
  Result := True;
  if (LHandle = cHandleDefault) then
  begin
    LHandle := CreateFileMappingA(THandle($FFFFFFFF), nil, PAGE_READWRITE, 0, cMemFileSize, PAnsiChar(AnsiString(aName)));
    Result := (GetLastError <> ERROR_ALREADY_EXISTS);
  end;
end;

initialization

finalization
  if (LHandle <> cHandleDefault) then
    CloseHandle(LHandle);
{$ENDIF OS_WIN}

end.
