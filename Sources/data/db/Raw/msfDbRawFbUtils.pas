unit msfDbRawFbUtils;

// {$mode ObjFPC}{$H+}
//{$PACKRECORDS 8}

interface

uses
  {$IFDEF MSWINDOWS}Windows,{$ENDIF}
  SysUtils, DateUtils, Classes,
  msfAtomicity,  msfErrors,
  msfDbRawFbApi, msfDbRawFbCharsets, msfEncodingBase64;

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

//type
//  ISC_SMALLINT = -32768 .. 65535; // SMALLINT	2 bytes	Range from -32 768 to 32 767 (unsigned: from 0 to 65 535)

type
  rVarChar = record
    Length: ISC_USHORT;
    Data: ansichar//array[0..0] of AnsiChar;
  end;
  rVarCharP = ^rVarChar;

type
  // указатели на специальные типы
  ISC_DATEPtr = ^ISC_DATE;
  ISC_TIMEPtr = ^ISC_TIME;
  ISC_TIMESTAMPPtr = ^ISC_TIMESTAMP;

type
  ISC_SHORTPtr = ^ISC_SHORT;
  ISC_USHORTPtr = ^ISC_USHORT;
  Bool16Ptr = ISC_SHORTPtr;


type
  tFbHanled = {$IFDEF FPC}TLibHandle{$ELSE}HMODULE{$ENDIF};

type
  cFirebird = class
   private class var
    fDefault: cFirebird;
   private class var
    fAtomicity: cAtomicity;
   private var
    fLibrary: tFbHanled;
   private var
    fMaster: Master;
   private var
    fStatus: Status;
   private var
    fProvider: Provider;
   private var
    fAttachment: Attachment;
   private var
    fUtil: Util;
   protected
    function innerLibraryLoad(const aPath: String): Boolean;
   public
    function IsLoadLibrary: Boolean;
   public
    property &Library: tFbHanled read fLibrary;
   public
    property Master: Master read fMaster;
   public
    property Status: Status read fStatus;
   public
    property Util: Util read fUtil;
   public
    property Provider: Provider read fProvider;
   public
    property Attachment: Attachment read fAttachment;
   public
    function Init(const aPath: String): Boolean;
    procedure DeInit;
   public
    function IscDateToDate(const aData: ISC_DATE): TDate;
    function IscTimeToTime(const aTime: ISC_TIME): TTime;
    function IscTimestampToDateTime(const aTimeStamp: ISC_TIMESTAMP): TDateTime;
   public
    procedure BlobToStream(const aQUAD: ISC_QUADPtr; aTransaction: Transaction; aStream: TStream); overload;
    function BlobToStream(const aQUAD: ISC_QUADPtr; aTransaction: Transaction): TMemoryStream; overload;
   public
    constructor Create;
   public
    constructor CreateDBC(const aDBC: String);
   public
    destructor Destroy; override;
   public
    class function ByDefault: cFirebird;
  end;

type
 cText = class
  protected
   function innerStringGet: String; virtual; abstract;
   procedure innerStringSet(const aInput: String); virtual; abstract;
  public
    property AsString: String read innerStringGet write innerStringSet;
 end;

type
 cVarChar = class(cText)
  private
   var fCharset: TFBCharSet;
  private
   var fMetaLength: Cardinal;
  private
   var fCharBuffer: TBytes;
  private
   var fLength: ISC_USHORTPtr;
  private
   var fData: PByte;
  private
   var fIsNull: Bool16Ptr;
  private
   var fIsTrimMax: Boolean;
  protected
   function innerStringGet: String; override;
   procedure innerStringSet(const aInput: String); override;
  public
   constructor Create(aStatus: Status; aMeta: MessageMetadata; const aIndex: Cardinal; aData: PByte; const aIsTrimMax: Boolean = False);
 end;

implementation

{$IFDEF DbFirebirdStaticLibrary}
  function fb_get_master_interface: Master; cdecl; external 'fbclient';
{$ENDIF}

type
  TFbGetMasterInterface = function (): Master; cdecl;

{ cFirebird }

constructor cFirebird.Create;
begin
  inherited;
  fLibrary := 0;
  Pointer(fMaster) := nil;
  Pointer(fStatus) := nil;
  Pointer(fUtil) := nil;
  Pointer(fAttachment) := nil;
  Pointer(fProvider) := nil;
end;

constructor cFirebird.CreateDBC(const aDBC: String);
var
  LParams, LDBC: TStrings;
  LStr: String;
  LIndex: NativeInt;
  LDpb: XpbBuilder;
  LDpbSize: Cardinal;
  LConnect: TBytes;
  LBuffer: BytePtr;
begin
  Create;

  LParams := nil;
  LDBC := nil;
  LDpb := nil;
  try
    LDBC := TStringList.Create;

    LDBC.Delimiter := ':';
    LDBC.DelimitedText := aDBC;
    if (LDBC.Count < 3) then
      raise Exception.Create(rsErrorFormatPDBC);

    if (SameText(LDBC.Strings[0], 'pDBC') = False) then
      raise Exception.Create(rsErrorFormatPDBC);

    if (SameText(LDBC.Strings[1], 'FirebirdSQL') = False) then
      raise Exception.Create(rsDriverSupportOnlyFirebirdSQL);

    LDBC.Delete(1);
    LDBC.Delete(0);
    LStr := LDBC.DelimitedText;

    LDBC.Delimiter := ';';
    LDBC.DelimitedText := LStr;

    LParams := TStringList.Create;
    for LIndex := 0 to Pred(LDBC.Count) do
    begin
      LStr := LDBC.Names[LIndex];
      if (LStr > '') then
        LParams.Values[LStr] := LDBC.ValueFromIndex[LIndex]
      else
        LParams.Add(LDBC.Strings[LIndex])
    end;

    LStr := LParams.Values['LibLocation'].DeQuotedString.DeQuotedString('"');
    if (LStr > '') then
    begin
      LParams.Delete(LParams.IndexOfName('LibLocation'));
      if (innerLibraryLoad(LStr) = False) then
        raise Exception.CreateFmt(rsNotLoadingLibrary, [LStr]);
    end;

    fProvider := fMaster.getDispatcher();
    LDpb := fUtil.getXpbBuilder(fStatus, XpbBuilder.dpb, nil, 0);

    LStr := LParams.Values['CodePage'];
    if (LStr > '') then
      LDpb.insertInt(fStatus, isc_dpb_page_size, StrToInt(LStr));

    LDpb.insertString(fStatus, isc_dpb_user_name, PAnsiChar(AnsiString(LParams.Values['User_Name'])));
    LDpb.insertString(fStatus, isc_dpb_password, PAnsiChar(AnsiString(LParams.Values['Password'])));
    LStr := LParams.Values['Role'];
    if (LStr > '') then
      LDpb.insertString(fStatus, isc_dpb_sql_role_name, PAnsiChar(AnsiString(LStr)));

    LStr := LParams.Values['Server'];
    if (LStr > '') then
    begin
      LStr := 'inet4://' + LStr;
      if  (LParams.Values['Port'] > '') then
        LStr := LStr + ':' + LParams.Values['Port'];
      LStr := LStr + '/';
    end;
    LStr := LStr + LParams.Values['Database'];

    LConnect := TEncoding.Default.GetBytes(UnicodeString(LStr + #00));

    LDpbSize := LDpb.getBufferLength(fStatus);
    FbException.checkException(fStatus);

    LBuffer := LDpb.getBuffer(fStatus);
    FbException.checkException(fStatus);

    fAttachment := fProvider.attachDatabase(fStatus, @LConnect[0], LDpbSize, LBuffer);
    FbException.checkException(fStatus);

    fAttachment.addRef;
  finally
    if (LDpb <> nil) then
      LDpb.dispose;
    LParams.Free;
    LDBC.Free
  end;
end;

procedure cFirebird.BlobToStream(const aQUAD: ISC_QUADPtr; aTransaction: Transaction; aStream: TStream);
 const
  cBlockSize = 65535;
 var
  LBlob: Blob;
  LBuffer: TBytes;
  LReadSize: Cardinal;
  LStatus: Integer;
begin
  LBlob := fAttachment.openBlob(fStatus, aTransaction, aQUAD, 0, nil);
  FbException.checkException(fStatus);

  LBuffer := [];
  try
    SetLength(LBuffer, cBlockSize);
    while True do
    begin
      LStatus := LBlob.getSegment(fStatus, cBlockSize, @LBuffer[0], @LReadSize);
      FbException.checkException(fStatus);
      case LStatus of
        Status.RESULT_OK, Status.RESULT_SEGMENT:
          aStream.WriteBuffer(LBuffer[0], LReadSize);
      else
        Break
      end;
    end;

  finally
    LBlob.close(fStatus);
  end;
end;

function cFirebird.BlobToStream(const aQUAD: ISC_QUADPtr; aTransaction: Transaction): TMemoryStream;
begin
  Result := nil;
  try
    Result := TMemoryStream.Create;
    BlobToStream(aQuad, aTransaction, Result);
    Result.Position := 0;
  except
    Result.Free;
    raise;
  end;
end;

class function cFirebird.ByDefault: cFirebird;
begin
  cFirebird.fAtomicity.Lock;
  try
    if (fDefault = nil) then
      fDefault := Self.Create;
    Result := fDefault;
  finally
    cFirebird.fAtomicity.UnLock;
  end;
end;

procedure cFirebird.DeInit;
begin
  if (fAttachment <> nil) then
  begin
    fAttachment.detach(fStatus);
    fAttachment.release();
    fAttachment := nil;
  end;

  if (fProvider <> nil) then
  begin
    fProvider.release();
    fProvider := nil;
  end;

  fUtil := nil;

  if (fStatus <> nil) then
  begin
    fStatus.dispose();
    fStatus := nil;
  end;

  fMaster := nil;

  if IsLoadLibrary then
  begin
    if (Self = ByDefault) then
      FreeLibrary(fLibrary)
    else if (fLibrary <> ByDefault.fLibrary) then
      FreeLibrary(fLibrary);
    fLibrary := 0;
  end;
end;

destructor cFirebird.Destroy;
begin
  DeInit;
  inherited
end;

function cFirebird.Init(const aPath: String): Boolean;
begin
  DeInit;
  Result := innerLibraryLoad(aPath);
end;

function cFirebird.innerLibraryLoad(const aPath: String): Boolean;
 var
  LMasterFunc: TFbGetMasterInterface;
begin
  Result := False;

  {$IFDEF DbFirebirdStaticLibrary}
    if (aPath = '') then
      fMaster := fb_get_master_interface();
  {$ENDIF}

  if (fMaster = nil) then
  begin
    {$IFDEF FPC}
     fLibrary := LoadLibrary(UnicodeString(aPath));
    {$ELSE}
     fLibrary := LoadLibrary(PChar(aPath));
    {$ENDIF}

    if IsLoadLibrary then
    begin
     {$IFDEF FPC}
       LMasterFunc := GetProcAddress(fLibrary, 'fb_get_master_interface');
     {$ELSE}
      LMasterFunc := GetProcAddress(fLibrary, PChar(String('fb_get_master_interface')));
     {$ENDIF}

      if (LMasterFunc = nil) then
        Exit;

      fMaster := LMasterFunc();
    end
  end;

  fStatus := fMaster.getStatus();
  if (fStatus = nil) then
    Exit;

  fUtil := fMaster.getUtilInterface();
  if (fUtil = nil) then
    Exit;

  Result := True
end;

function cFirebird.IscDateToDate(const aData: ISC_DATE): TDate;
 var
  LYear, LMonth, LDay: Cardinal;
begin
  fUtil.DecodeDate(aData, @LYear, @LMonth, @LDay);
  Result := EncodeDate(LYear, LMonth, LDay)
end;

function cFirebird.IscTimestampToDateTime(const aTimeStamp: ISC_TIMESTAMP): TDateTime;
var
  LYear, LMonth, LDay, LHour, LMinutes, LSeconds, LFractions: Cardinal;
begin
  fUtil.DecodeDate(aTimeStamp.timestamp_date, @LYear, @LMonth, @LDay);
  fUtil.DecodeTime(aTimeStamp.timestamp_time, @LHour, @LMinutes, @LSeconds, @LFractions);
  Result := EncodeDateTime(LYear, LMonth, LDay, LHour, LMinutes, LSeconds, LFractions div 10)
end;

function cFirebird.IscTimeToTime(const aTime: ISC_TIME): TTime;
 var
  LHour, LMinutes, LSeconds, LFractions: Cardinal;
begin
  fUtil.decodeTime(aTime, @LHour, @LMinutes, @LSeconds, @LFractions);
  Result := EncodeTime(LHour, LMinutes, LSeconds, LFractions div 10)
end;

function cFirebird.IsLoadLibrary: Boolean;
begin
  Result := (fLibrary <> 0) {$IFDEF OS_WIN} and (fLibrary <> INVALID_HANDLE_VALUE){$ENDIF};
end;

procedure innerInit;
begin
  cFirebird.fAtomicity := cAtomicity.New;
  Pointer(cFirebird.fDefault) := nil;
end;

procedure innerDeInit;
begin
  cFirebird.fDefault.Free;
  cFirebird.fDefault := nil;
end;

{ cVarChar }

constructor cVarChar.Create(aStatus: Status; aMeta: MessageMetadata; const aIndex: Cardinal; aData: PByte; const aIsTrimMax: Boolean);
 var
  LOffset: Cardinal;
begin
  inherited Create;

  // размер буфера для VARCHAR
  fMetaLength := aMeta.getLength(aStatus, aIndex);
  FbException.checkException(aStatus);
  SetLength(fCharBuffer, fMetaLength);

  fCharSet := TFBCharSet(aMeta.getCharSet(aStatus, aIndex));
  FbException.checkException(aStatus);

  LOffset := aMeta.getOffset(aStatus, aIndex);
  FbException.checkException(aStatus);

  fLength := ISC_USHORTPtr(aData + LOffset);
  fData := PByte(aData + LOffset + SizeOf(ISC_SHORT));

  LOffset := aMeta.getNullOffset(aStatus, aIndex);
  FbException.checkException(aStatus);

  fIsNull := Bool16Ptr(aData + LOffset);
//  Inc(fIsNull, LOffset);

  fIsTrimMax := aIsTrimMax
end;

function cVarChar.innerStringGet: String;
begin
  Result := '';

  if (fIsNull^ = 1) then
    Exit;

  if (fLength^ = 0) then
    Exit;

  if (fCharSet = CS_BINARY) then
  begin
    {$IFDEF FPC}
      Move(fData^, fCharBuffer[0], fMetaLength);
      Result := fCharSet.GetString(fCharBuffer, 0, fLength^);
      Result := cEncodingBase64.EncodeStringToString(Result);
    {$ELSE}
      Result := cEncodingBase64.EncodeBytesToString(fData, fLength^);
    {$ENDIF}
  end
  else
  begin
    Move(fData^, fCharBuffer[0], fMetaLength);
    Result := fCharSet.GetString(fCharBuffer, 0, fLength^);
  end;
end;

procedure cVarChar.innerStringSet(const aInput: String);
 var
  LBytes: TBytes;
begin
  fIsNull^ := 0;

  fLength^ := Length(aInput);
  if (aInput = '') then
    Exit;

  if (fCharSet = CS_BINARY) then
    LBytes := fCharSet.GetBytes(cDecodingBase64.DecodeStringToString(aInput))
  else
    LBytes := fCharSet.GetBytes(aInput);

  if (Length(LBytes) > fMetaLength) then
    if fIsTrimMax then
      SetLength(LBytes, fMetaLength)
    else
      raise Exception.CreateFmt('Длина строки %s больше максимальной %', [Length(LBytes), fMetaLength]);

  Move(LBytes[0], fData^, Length(LBytes));
end;

initialization
  innerInit;

finalization
  innerDeInit;

end.
