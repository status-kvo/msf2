unit msfDbFbUtils;

// {$mode ObjFPC}{$H+}
//{$PACKRECORDS 8}

interface

uses
  {$IFDEF FPC}
   LCLType,
  {$ELSE}
   WinAPI.Windows,
  {$ENDIF}
  SysUtils, DateUtils,
  msfDbFbApi;

type
  // типы Firebird
  eFbType = (
    /// <summary>
    /// VARCHAR
    /// </summary>
    SQL_VARYING = 448,
    /// <summary>
    /// CHAR
    /// </summary>
    SQL_TEXT = 452,
    /// <summary>
    /// DOUBLE PRECISION
    /// </summary>
    SQL_DOUBLE = 480,
    /// <summary>
    /// FLOAT
    /// </summary>
    SQL_FLOAT = 482,
    /// <summary>
    /// INTEGER - Целое число
    /// </summary>
    SQL_LONG = 496,
    /// <summary>
    /// SMALLINT
    /// </summary>
    SQL_SHORT = 500,
    /// <summary>
    /// TIMESTAMP
    /// </summary>
    SQL_TIMESTAMP = 510,
    /// <summary>
    /// BLOB
    /// </summary>
    SQL_BLOB = 520,
    /// <summary>
    /// DOUBLE PRECISION
    /// </summary>
    SQL_D_FLOAT = 530,
    /// <summary>
    /// ARRAY
    /// </summary>
    SQL_ARRAY = 540,
    /// <summary>
    /// BLOB_ID (QUAD)
    /// </summary>
    SQL_QUAD = 550,
    /// <summary>
    /// TIME
    /// </summary>
    SQL_TIME = 560,
    /// <summary>
    /// DATE
    /// </summary>
    SQL_DATE = 570,
    /// <summary>
    /// BIGINT
    /// </summary>
    SQL_INT64 = 580,
    /// <summary>
    /// BOOLEAN
    /// </summary>
    SQL_BOOLEAN = 32764,
    /// <summary>
    /// NULL
    /// </summary>
    SQL_NULL = 32766);

type
  ISC_SMALLINT = -32768 .. 65535; // SMALLINT	2 bytes	Range from -32 768 to 32 767 (unsigned: from 0 to 65 535)

type
  rVarChar = record
    Length: UInt16;
    Data: array[0..0] of AnsiChar;
  end;
  rVarCharP = ^rVarChar;

type
  // TIMESTAMP
  ISC_TIMESTAMP = record
    date: ISC_DATE;
    time: ISC_TIME;
  end;

type
  // указатели на специальные типы
  PISC_DATE = ^ISC_DATE;
  PISC_TIME = ^ISC_TIME;
  PISC_TIMESTAMP = ^ISC_TIMESTAMP;
  PISC_QUAD = ^ISC_QUAD;

function VarCharToString(const aVarChar: rVarCharP): String;
procedure StringToVarChar(const aVarChar: rVarCharP; const aStr: RawByteString);
function IscDateToDate(const aData: PISC_DATE): TDate;
function IscTimeToTime(const aTime: PISC_TIME): TTime;
function IscTimestampToDateTime(const aTimeStamp: PISC_TIMESTAMP): TDateTime;

var
  FbMaster: Master;
  FbStatus: Status;
  FbUtil: Util;
  {$IFNDEF DbFirebirdStaticLibrary}
   {$IFDEF FPC}
    FbLibrary: TLibHandle;
   {$ELSE}
    FbLibrary: HMODULE;
   {$ENDIF}
  {$ENDIF}

function FbLibraryLoad(const aPath: String): boolean;

implementation

{$IFDEF DbFirebirdStaticLibrary}
  function fb_get_master_interface: Master; cdecl; external 'fbclient';
{$ENDIF}

type
  TFbGetMasterInterface = function (): Master; cdecl;

function VarCharToString(const aVarChar: rVarCharP): String;
 var
  LString: RawByteString;
begin
  LString := '';
  try
    if (aVarChar^.Length = 0) then
      Exit;
    SetLength(LString, aVarChar^.Length);
    Move(aVarChar^.Data[0], LString[1], aVarChar^.Length);
	finally
  	Result := String(LString);
	end;
end;

procedure StringToVarChar(const aVarChar: rVarCharP; const aStr: RawByteString);
begin
  aVarChar^.Length := Length(aStr);
  Move(aStr[1], aVarChar^.Data[0], Length(aStr));
end;

function IscDateToDate(const aData: PISC_DATE): TDate;
 var
  LYear, LMonth, LDay: Cardinal;
begin
  FbUtil.DecodeDate(aData^, @LYear, @LMonth, @LDay);
  Result := EncodeDate(LYear, LMonth, LDay);
end;

function IscTimeToTime(const aTime: PISC_TIME): TTime;
 var
  LHour, LMinutes, LSeconds, LFractions: Cardinal;
begin
  FbUtil.decodeTime(aTime^, @LHour, @LMinutes, @LSeconds, @LFractions);
  Result := EncodeTime(LHour, LMinutes, LSeconds, LFractions div 10);
end;

function IscTimestampToDateTime(const aTimeStamp: PISC_TIMESTAMP): TDateTime;
var
  LYear, LMonth, LDay, LHour, LMinutes, LSeconds, LFractions: Cardinal;
begin
  FbUtil.DecodeDate(aTimeStamp^.date, @LYear, @LMonth, @LDay);
  FbUtil.DecodeTime(aTimeStamp^.time, @LHour, @LMinutes, @LSeconds, @LFractions);
  Result := EncodeDateTime(LYear, LMonth, LDay, LHour, LMinutes, LSeconds, LFractions div 10);
end;

function InitFunction: Boolean;
begin
  Result := False;

  if (FbMaster = nil) then
    Exit;

  FbStatus := FbMaster.getStatus();
  if (FbStatus = nil) then
    Exit;

  FbUtil := FbMaster.getUtilInterface();
  if (FbUtil = nil) then
    Exit;

  Result := True
end;

procedure Init;
begin
  Pointer(FbMaster) := nil;
  Pointer(FbStatus) := nil;
  Pointer(FbUtil) := nil;

  {$IFDEF DbFirebirdStaticLibrary}
    FbMaster := fb_get_master_interface();
    InitFunction;
  {$ELSE}
    FbLibrary := 0;
  {$ENDIF}
end;

procedure DeInit;
begin
  FbUtil := nil;

  if (FbStatus <> nil) then
  begin
    FbStatus.dispose();
    FbStatus := nil;
  end;

  FbMaster := nil;

  if (FbLibrary <> INVALID_HANDLE_VALUE) and (FbLibrary <> 0) then
  begin
    FreeLibrary(FbLibrary);
    FbLibrary := 0;
  end;
end;

function FbLibraryLoad(const aPath: String): Boolean;
 var
  LMaster: TFbGetMasterInterface;
begin
  if (FbMaster <> nil) then
  begin
    Result := True;
    Exit;
  end;

  Result := False;
  DeInit;
  {$IFDEF FPC}
   FbLibrary := LoadLibrary(UnicodeString(aPath));
  {$ELSE}
   FbLibrary := LoadLibraryW(PWideChar(WideString(aPath)));
  {$ENDIF}
  if (FbLibrary <> INVALID_HANDLE_VALUE) and (FbLibrary <> 0) then
  begin
   {$IFDEF FPC}
    Pointer(LMaster) := GetProcAddress(FbLibrary, 'fb_get_master_interface');
   {$ELSE}
    LMaster := GetProcAddress(FbLibrary, PWideChar('fb_get_master_interface'));
   {$ENDIF}

    if (LMaster = nil) then
      Exit;

    FbMaster := LMaster();
    Result := InitFunction;
  end
end;

initialization
  Init;

finalization
  DeInit;

end.
