unit WmqClient;

{$IFDEF FPC}
  {$mode ObjFPC}{$H+}
{$ENDIF}

interface

uses
  Types, SysUtils, Classes, StrUtils, Math,
  WmqIC, WmqIntfError, WmqErrorText,
  msfIOUtils, msfParams;

const
  ARR_LENGTH = 48;
  CONN_ATTEMPT_COUNT = 2;

  OPEN_FOR_READ_NON_DELETE = MQOO_BROWSE;
  OPEN_FOR_READ = MQOO_INPUT_AS_Q_DEF + MQOO_FAIL_IF_QUIESCING;
  OPEN_FOR_WRITE = MQOO_OUTPUT;

  GET_DESTRUCTIVE = MQGMO_NO_WAIT + MQGMO_SYNCPOINT;
  GET_NONDESTRUCTIVE = MQGMO_BROWSE_NEXT;

type
  { TMQClient }

  TMQClient = class
   private
    var fConnectionHandler: MQHCONN; // MQLONG
    var fObjectDecsriptor: MQOD; // record
    var fObjectHandler: MQHOBJ; // MQLONG
    var fMessageDescription: MQMD; // record
   private
    var fMessageText: RawByteString;
   private
    var fBufferData: PWideChar;
   private
    var fBufferLength: NativeInt;
   private
    var fDataLength: NativeInt;
   private
    var fUserPassword: AnsiString;
   private
    var fUserName: AnsiString;
   private
    var fSecurityOptions: MQCSP;
   private
    var fConnOptions: MQCNO;
   private
    var fServers: TStringDynArray;
   private
    var fQueueName: String;
   private
    var fQueueIdent: String;
   private
    function MQCommit: Boolean;
    function MQGet(const aGetMode: Integer; out aReason: MQLONG; const aSameLastMessage: Boolean = False): Integer;
    function MQPut(const aData: RawByteString; const aFormat: String): Boolean;
    function innerGetMessage(const aGetMode: Int32): Int32;

    function IsMQRFH2Message: Boolean;//проверка, что тело сообщения начинается с MQRFH2 заголовка
    procedure CutMQRFH2Header;
    procedure CopyFromBuffer;
    //function SaveMessageWithDescriptor: string;

    procedure BackOut;
   private
    procedure innerClose;
   private
    function innerIsConnected: Boolean;
    function innerIsOpen: Boolean;
    function innerConnect: Boolean;
    procedure innerDisconnect;
   private
    function innerOpen(const aOpenOptions: MQLONG): Boolean;
    function innerOpenRead: Boolean;
    function innerOpenWrite: Boolean;
   private
    procedure innerQueueNameSet(const aQueueName: String);
   private
    procedure innerQueueIdentSet(const aQueueIdent: String);
   private
    procedure innerServersSet(const aServers: TStringDynArray);
   private
    procedure innerUserDataUpdate;
    function innerUserNameGet: String;
    procedure innerUserNameSet(const aUserName: String);
   private
    function innerUserPasswordGet: String;
    procedure innerUserPasswordSet(const aUserPassword: String);
   public
    procedure GetFiles(const aFileMasks: TStringDynArray; const aEncoding: String; const aIsClose: Boolean);
    function PutMessage(const aMessage: String; const aIsConvert, aIsClose: Boolean): Boolean;
    function PutData(const aData: RawByteString; const aFormat: String; const aIsClose: Boolean): Boolean;
   public
    class function DeleteMessageFile(const aFileName: String): Boolean;
   public
    property Servers: TStringDynArray read fServers write innerServersSet;
   public
    property QueueName: String read fQueueName write innerQueueNameSet;
   public
    property QueueIdent: String read fQueueIdent write innerQueueIdentSet;
   public
    property UserName: String read innerUserNameGet write innerUserNameSet;
   public
    property UserPassword: String read innerUserPasswordGet write innerUserPasswordSet;
   public
    property IsConnected: Boolean read innerIsConnected;
    property IsOpen: Boolean read innerIsOpen;
   public
    procedure LoadDBС(const aDBС: String);
   public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

const
  cMessageCountMax: Int32 = 100000;
  cBufferLengthValue: Int32 = 500000;

procedure TMQClient.BackOut;
 var
  LCompCode, LReason: MQLONG;
begin
  if fConnectionHandler <> 0 then
  begin
    MQIC_BACK(fConnectionHandler, @LCompCode, @LReason);
    //FLog.CheckLibraryError;
  end;
end;

function TMQClient.MQCommit: Boolean;
 var
  LCompCode, LReason: MQLONG;
begin
  Result := False;
  if (innerIsConnected = False) then
    Exit;

  MQIC_CMIT(fConnectionHandler, LCompCode, LReason);
  Result := (LCompCode = 0)
end;

procedure TMQClient.CopyFromBuffer;
var
  LValueStr : AnsiString;
begin
  //Отбрасывание JMS заголовка если есть
  if IsMQRFH2Message then
    CutMQRFH2Header;
  SetLength(LValueStr, fDataLength);

  if fBufferData <> nil then
    Move(fBufferData[0], LValueStr[1], fDataLength);

  fMessageText := LValueStr;
end;

constructor TMQClient.Create;
begin
  fBufferLength := cBufferLengthValue;
  FillChar(fConnOptions, sizeof(MQCNO_DEFAULT), 0);
  Move(MQCNO_DEFAULT, fConnOptions, sizeof(MQCNO_DEFAULT));
  fConnOptions.Version := MQCNO_VERSION_2;
  LoadDLL;
  inherited Create;
end;

function PCharToInteger(const aData: PByte; out aInteger: Integer; aDirectByteOrder: Boolean): Boolean;
begin
  Result := False;

  if (@aData = nil) then
    Exit;

  if aDirectByteOrder then
  begin
    //в Utf16 обратный порядок байт, нужен swap, чтобы обменять байты у word
    LongRec(aInteger).Hi := swap(PWORD(@aData[0])^);
    LongRec(aInteger).Lo := swap(PWORD(@aData[1])^);
  end
  else
  begin
    LongRec(aInteger).Lo := PWORD(@aData[0])^;
    LongRec(aInteger).Hi := PWORD(@aData[1])^;
  end;

  Result := True;
end;

procedure TMQClient.CutMQRFH2Header;
 var
  LHeaderLength, LByteOrder: Integer;
  LHeaderId: AnsiString;
  LHeaderLengthArray: TBytes;
  LDirectByteOrder: Boolean;
begin
  LHeaderLengthArray := [];
  try
    SetLength(LHeaderId, 4);
    Move(fBufferData[0], LHeaderId[1], 4);
    if (LHeaderId <> 'RFH ') then
      Exit;

    SetLength(LHeaderLengthArray, 4);
    Move(fBufferData[4], LHeaderLengthArray[0], 4);

    LByteOrder := fMessageDescription.Encoding and MQENC_INTEGER_MASK;
    if (LByteOrder <> 1) and (LByteOrder <> 2) then
      raise Exception.Create(rsUnknownMqMDEncodingValue);

    LDirectByteOrder := (LByteOrder = 1);

    if (PCharToInteger(@LHeaderLengthArray[0], LHeaderLength, LDirectByteOrder) = False) then
       Exit;

    if (LHeaderLength >= fDataLength) then
      raise Exception.Create(rsIncorrectRFHLength);

    fDataLength := fDataLength - LHeaderLength;
    Move(fBufferData[Ceil(LHeaderLength / 2)], fBufferData[0], fDataLength);
  except
    on E: Exception do
    begin
      {$message 'Сделай Log'}
      //FLog.Add('CutMQRFH2Header error: ' + E.Message, -1);
      //FLog.Add('MQMD: ' + SaveMessageWithDescriptor, -2);
    end;
  end;
end;

class function TMQClient.DeleteMessageFile(const aFileName: string): Boolean;
begin
  Result := True;
  if (FileExists(aFileName, False) = False) then
    Exit;
  if DeleteFile(aFileName) then
    Exit;
  Result := False;
end;

destructor TMQClient.Destroy;
begin
  innerDisconnect;
  inherited;
end;

function innerAllocMem(var aData: PWideChar; const aSize: Integer; const aIsSameLastMessage: Boolean): Boolean;
// var
//  LDefaultSize: NativeInt;
begin
  Result := False;

 try
   if (aIsSameLastMessage) then
   begin
     //ReallocMem(aData, aSize)
     FreeMem(aData);
     aData := nil;
   end;

   aData := AllocMem(aSize);

   Result := True;
 except
   on E: Exception do
     {$message 'Сделай Log'}
     //FLog.Add('Message buffer reallocating failed: ' + E.Message, -1);
 end;
end;

function TMQClient.MQGet(const aGetMode: Integer; out aReason: MQLONG; const aSameLastMessage: Boolean): Integer;
  // GetMode - содержимое поля MQGMO.Options,  определяет режим работы GET
var
  LCompCode: MQLONG;
  LOptions: MQGMO;
//  LMQMDFile: string;
begin
  Result := MQCC_UNKNOWN;

  fMessageText := '';
  try
    FillChar(LOptions, sizeof(MQGMO_DEFAULT), 0);
    Move(MQGMO_DEFAULT, LOptions, sizeof(MQGMO_DEFAULT));
    LOptions.Options := aGetMode;

    if (innerAllocMem(fBufferData, fBufferLength + 16, aSameLastMessage) = False) then
      Exit;

    if (aSameLastMessage = False) then // опции по умолчанию message description
      Move(MQMD_DEFAULT, fMessageDescription, SizeOf(MQMD_DEFAULT));

    MQIC_GET(fConnectionHandler, fObjectHandler, @fMessageDescription, @LOptions, fBufferLength, PChar(fBufferData), @fDataLength, @LCompCode, @aReason);

    case aReason of
      MQRC_TRUNCATED_MSG_FAILED: // MQRC_NONE
      begin
        fBufferLength := fDataLength;
        //FLog.Add('Get:truncated msg failed', 0, aReason);
        if not aSameLastMessage then
          Result := MQGet(aGetMode, aReason, True)
        else
          Result := MQCC_FAILED;
      end;

      MQRC_NO_MSG_AVAILABLE:
      begin
        //FLog.Add('Get:no msg available', 0, aReason);
        Result := MQCC_FAILED;
      end;

      else
      begin
        Result := LCompCode;

//        if (LCompCode <> 0) then //or (constEnableFullLog) then
//        begin
//          LMQMDFile := SaveMessageWithDescriptor;
//          //FLog.Add('MQMD: ' + LMQMDFile, -2);
//        end;

        if LCompCode = 0 then
          CopyFromBuffer;

        //FLog.Add('Get', LCompCode, aReason);
      end;
    end;

  finally
    if fBufferData <> nil then
    begin
      FreeMem(fBufferData);
      fBufferData := nil;
    end;
  end;
end;

function BufferToHex(aByte: PByte; aSize: NativeInt): String;
begin
  Result := '';
  while (aSize > 0) do
  begin
    Result := Result + aByte^.ToHexString(2);
    Inc(aByte);
    Dec(aSize);
  end;
end;

procedure TMQClient.GetFiles(const aFileMasks: TStringDynArray; const aEncoding: String; const aIsClose: Boolean);
 var
  LStreams: array of TFileStream;

  procedure innerFileMasks(aData: RawByteString);
   var
    LFileMask: String;
    LFilePath, LUId: string;
    LStream: TFileStream;
  begin
    LFilePath := '';

    //if (fMessageDescription.CodedCharSetId = 1208) then
    //  fMessageText := RawByteString(Utf8ToString(fMessageText));
    if SameText(aEncoding, 'utf-8') then
      aData := UTF8Encode(aData);

    for LFileMask in aFileMasks do
    begin
      LStream := nil;
      try
        LUId := 'correlId=' + BufferToHex(@fMessageDescription.CorrelId[0], SizeOf(MQBYTE24));
        LUId := LUId + '_msgId=' + BufferToHex(@fMessageDescription.MsgId[0], SizeOf(MQBYTE24));

        LFilePath := GenerateFileName(LFileMask, fQueueIdent, LUId, '');
        if (LFilePath = '') then
          Exit;

        LStream := TFileStream.Create(LFilePath, fmCreate);
        LStream.Size := Length(fMessageText);
        LStream.Position := 0;
        LStream.WriteData(PAnsiChar(@aData[1]), Length(aData));

        LStreams := LStreams + [LStream];
        LStream := nil;
        LFilePath := '';
      finally
        if (LStream <> nil) then
          LStream.Size := 0;
        LStream.Free;
        if (LFilePath > '') then
          DeleteMessageFile(LFilePath)
      end;
    end;
  end;

var
  LGetResult: Int32;
  LStream: TFileStream;
  LError: Boolean;
begin
  if (innerOpenRead = False) then
    Exit;

  LError := False;
  try
    // точка синхр. отсюда и до коммита
    LGetResult := innerGetMessage(GET_DESTRUCTIVE);
    while LGetResult = 1 do
    begin
      LStreams := [];
      try
        try
          innerFileMasks(fMessageText);
        except
          BackOut;
          LError := True;
          Exit;
        end;

        if (MQCommit = False) then
        begin
          LError := True;
          Exit;
        end;

      finally
        for LStream in LStreams do
        begin
          if LError then
            LStream.Size := 0;
          LStream.Free;
        end;
        LStreams := [];
      end;

      LGetResult := innerGetMessage(GET_DESTRUCTIVE);
    end;
  finally
    if aIsClose then
      innerClose
  end;
end;

function TMQClient.innerGetMessage(const aGetMode: Int32): Int32;
  // option - содержимое поля MQGMO.Options,  определяет режим работы GET
 var
  LCompCode, LReason: MQLONG;
begin
  Result := -1;

  LCompCode := MQGet(aGetMode, LReason);
  case LCompCode of
    MQCC_OK:
      Result := 1;
    MQCC_WARNING:
      Result := 0;
    MQCC_FAILED:
    begin
      if LReason = MQRC_BACKED_OUT then
        BackOut; // последний get установил точку синхр но был неудачен
      Result := -1;
      if LReason = MQRC_NO_MSG_AVAILABLE then
        Result := 2;
    end;
  end;
end;

procedure TMQClient.innerClose;
 var
  LCloseOptions, LCompCode, LReason: MQLONG;
begin
  if (innerIsOpen = False) then
    Exit;

  LCloseOptions := 0;
  MQIC_CLOSE(fConnectionHandler, @fObjectHandler, LCloseOptions, @LCompCode, @LReason);
  fObjectHandler := 0;
end;

function TMQClient.innerIsConnected: Boolean;
begin
  Result := (fConnectionHandler > 0)
end;

function TMQClient.innerIsOpen: Boolean;
begin
  Result := (fObjectHandler > 0)
end;

function TMQClient.innerConnect: Boolean;
 var
  LCompCode, LReason: MQLONG;
  LAttempts: NativeInt;
  LQueueManager, LServerAdress, LChannelName: AnsiString;
  LServer: String;
  LClientConn: MQCD;
  LArray: TStringDynArray;
  //LQueueManagerArray: MQCHAR48;
begin
  Result := True;

  if IsConnected then
    Exit;

  innerClose;
  Result := False;

  FillChar(LClientConn, sizeof(MQCD_CLIENT_CONN_DEFAULT), 0);
  Move(MQCD_CLIENT_CONN_DEFAULT, LClientConn, sizeof(MQCD_CLIENT_CONN_DEFAULT));

  for LServer in fServers do
  begin
    LArray := LServer.Split(['/']);
    if (Length(LArray) < 3) then
      Continue;
    if (Length(LArray) > 4) then
      Continue;

    if (Length(LArray) = 4) then
    begin
      LQueueManager := AnsiString(LArray[0]) + #00;
      LChannelName := AnsiString(LArray[1]) + #00;
      LServerAdress := AnsiString(LArray[3]) + #00;
    end
    else
    begin
      LQueueManager := '';
      LChannelName := AnsiString(LArray[0]) + #00;
      LServerAdress := AnsiString(LArray[2]) + #00;
    end;

    Move(LServerAdress[1], LClientConn.ConnectionName[0], Length(LServerAdress));
    Move(LChannelName[1], LClientConn.ChannelName[0], Length(LChannelName));

    fConnOptions.ClientConnPtr := @LClientConn;

    //LQueueManager := LQueueManager.PadRight(sizeof(MQCHAR48), #00);
    //Move(AnsiString(LQueueManager)[1], LQueueManagerArray[0], Length(LQueueManager));
    SetLength(LQueueManager, sizeof(MQCHAR48));

    for LAttempts := 1 to CONN_ATTEMPT_COUNT do
    begin
      MQIC_CONNX(@LQueueManager[1], @fConnOptions, @fConnectionHandler, @LCompCode, @LReason);

      //FLog.CheckLibraryError;
      if (LCompCode = MQCC_OK) or ((LCompCode = MQCC_WARNING) and (LReason = MQRC_ALREADY_CONNECTED)) then
      begin
        Result := True;
        Writeln('connected');
        Exit;
      end
      else
        Writeln('connected error ', LCompCode, ' ', LReason);
    end;
  end;
end;

procedure TMQClient.innerDisconnect;
 var
  LCompCode, LReason: MQLONG;
begin
  if (innerIsConnected = False) then
    Exit;
  innerClose;

  MQIC_DISC(@fConnectionHandler, @LCompCode, @LReason);
end;

procedure TMQClient.innerQueueIdentSet(const aQueueIdent: String);
begin
  if IsOpen then
    innerClose;
  fQueueIdent := aQueueIdent
end;

procedure TMQClient.innerQueueNameSet(const aQueueName: String);
begin
  if IsOpen then
    innerClose;
  fQueueName := aQueueName
end;

procedure TMQClient.innerServersSet(const aServers: TStringDynArray);
begin
  innerDisconnect;
  fServers := aServers
end;

procedure TMQClient.innerUserDataUpdate;
begin
  //если имеется логин, подключаемся с аут-ей к менеджеру
  if (fUserName > '') then
  begin
    FillChar(fSecurityOptions, sizeof(MQCSP_DEFAULT), 0);
    Move(MQCSP_DEFAULT, fSecurityOptions, sizeof(MQCSP_DEFAULT));

    //включаем аутентификацию юзера по паролю и ид
    fSecurityOptions.AuthenticationType := MQCSP_AUTH_USER_ID_AND_PWD;

    if (fUserName > '') then
      fSecurityOptions.CSPUserIdPtr := @fUserName[1];
    fSecurityOptions.CSPUserIdLength := Length(fUserName);

    if (fUserPassword > '') then
      fSecurityOptions.CSPPasswordPtr := @fUserPassword[1];
    fSecurityOptions.CSPPasswordLength := Length(fUserPassword);

    fConnOptions.Version := MQCNO_VERSION_5;
    fConnOptions.SecurityParmsPtr := @fSecurityOptions;
  end
  else
    fConnOptions.Version := MQCNO_VERSION_2;
end;

function TMQClient.innerUserNameGet: String;
begin
  Result := String(fUserName)
end;

procedure TMQClient.innerUserNameSet(const aUserName: String);
begin
  innerDisconnect;
  fUserName := AnsiString(aUserName);
  innerUserDataUpdate;
end;

function TMQClient.innerUserPasswordGet: String;
begin
  Result := String(fUserPassword)
end;

procedure TMQClient.innerUserPasswordSet(const aUserPassword: String);
begin
  innerDisconnect;
  fUserPassword := AnsiString(aUserPassword);
  innerUserDataUpdate;
end;

function TMQClient.IsMQRFH2Message: Boolean;
var
  LFormatAnsi: AnsiString;
  LFormatUnicode: String;
begin
  SetLength(LFormatAnsi, 8);
  Move(fMessageDescription.Format[0], LFormatAnsi[1], 8);

  LFormatUnicode := Trim(String(LFormatAnsi));
  Result := LFormatUnicode = Trim(MQFMT_RF_HEADER_2);
end;

procedure TMQClient.LoadDBС(const aDBС: String);
var
  LDBC: TStrings;
  LStr: String;
begin
  LDBC := nil;
  try
    LDBC := TStringList.Create;

    LDBC.Delimiter := ':';
    LDBC.DelimitedText := aDBС;
    if (LDBC.Count < 3) then
      Exit;
    if (SameText(LDBC.Strings[0], 'pDBC') = False) then
      Exit;

    if (SameText(LDBC.Strings[1], 'WMQ') = False) then
      Exit;

    LDBC.Delete(1);
    LDBC.Delete(0);
    LStr := LDBC.DelimitedText;

    LDBC.Delimiter := ';';
    LDBC.DelimitedText := LStr;

    Servers := LDBC.Values['servers'].DeQuotedString.DeQuotedString('"').Split([',']);
    QueueName := LDBC.Values['QueueName'].DeQuotedString.DeQuotedString('"');
    QueueIdent := LDBC.Values['Ident'].DeQuotedString.DeQuotedString('"');
    UserName := LDBC.Values['UserName'].DeQuotedString.DeQuotedString('"');
    UserPassword := LDBC.Values['UserPassword'].DeQuotedString.DeQuotedString('"');
  finally
    LDBC.Free
  end;
end;

function TMQClient.innerOpen(const aOpenOptions: MQLONG): Boolean;
var
  LCompCode, LReason: MQLONG;
  LRec: MQOD;
  LQueueNameLength: NativeInt;
  LAnsiString: AnsiString;
begin
  Result := False;

  if (IsConnected = False) then
  begin
    innerConnect;
    if (IsConnected = False) then
      Exit;
  end;

  if (IsOpen) then
    innerClose;

  FillChar(LRec, sizeof(MQOD_DEFAULT), 0);
  Move(MQOD_DEFAULT, LRec, sizeof(MQOD_DEFAULT));
  fObjectDecsriptor := LRec;

  LQueueNameLength := Length(fQueueName);
  if (fQueueName = '') then
    exit;

  FillChar(fObjectDecsriptor.ObjectName, ARR_LENGTH, #0);
  LAnsiString := '';

  //lStr:=tencoding.UTF8.GetString(tencoding.Convert(tencoding.Unicode, tencoding.UTF8, tencoding.Unicode.GetBytes(fQName)));
  SetLength(LAnsiString, LQueueNameLength * 2);
  LQueueNameLength := UnicodeToUtf8(PAnsiChar(LAnsiString), LQueueNameLength * 2, @fQueueName[1], LQueueNameLength);
  Move(LAnsiString[1], fObjectDecsriptor.ObjectName[0], LQueueNameLength);

  MQIC_OPEN(fConnectionHandler, @fObjectDecsriptor, aOpenOptions, @fObjectHandler, @LCompCode, @LReason);

  //FLog.CheckLibraryError;
  Result := (LCompCode = MQCC_OK);

  if Result then
    Writeln('open ok')
  else
    Writeln('open erroe ', LCompCode, ' ', lReason)
  //FLog.Add('Open', lCompCode, lReason);
end;

function TMQClient.innerOpenRead: Boolean;
begin
  Result := innerOpen(OPEN_FOR_READ)
end;

function TMQClient.innerOpenWrite: Boolean;
begin
  Result := innerOpen(OPEN_FOR_WRITE)
end;

function TMQClient.MQPut(const aData: RawByteString; const aFormat: String): Boolean;
 var
  LPutMsgOptions: MQPMO;
  LMsgDesc: MQMD;
  LCompCode, LReason: MQLONG;
begin
  Result := False;

  try
    FillChar(LPutMsgOptions, sizeof(MQPMO_DEFAULT), 0);
    Move(MQPMO_STRUC_ID, LPutMsgOptions.StrucId, sizeof(MQPMO_STRUC_ID));

    LPutMsgOptions.Version := MQPMO_VERSION_1;
    LPutMsgOptions.Options := MQPMO_NEW_MSG_ID;

    FillChar(LMsgDesc, sizeof(MQMD_DEFAULT), 0);
    Move(MQMD_DEFAULT, LMsgDesc, sizeof(MQMD_DEFAULT));
    LMsgDesc.Version := MQMD_VERSION_1;
    LMsgDesc.Expiry := MQEI_UNLIMITED;
    LMsgDesc.Report := MQRO_NONE;
    LMsgDesc.MsgType := MQMT_DATAGRAM;
    LMsgDesc.Priority := 1;
    Move(AnsiString(aFormat.PadRight(SizeOf(MQCHAR8), ' '))[1], LMsgDesc.Format[0], SizeOf(MQCHAR8));

    FillChar(LMsgDesc.ReplyToQ, sizeof(LMsgDesc.ReplyToQ), 0);
    MQIC_PUT(fConnectionHandler, fObjectHandler, @LMsgDesc, @LPutMsgOptions, Length(aData), @aData[1], @LCompCode, @LReason);

    //LPAnsiChar := AllocMem(LBufferLength);
    //UnicodeToUtf8(LPAnsiChar, LBufferLength, addr(aMessage[1]), LBufferLength);
    //MQIC_PUT(fConnectionHandler, fObjectHandler, @LMsgDesc, @LPutMsgOptions, LBufferLength, LPAnsiChar, @LCompCode, @LReason);

    Result := (LCompCode = MQCC_OK);
    Writeln('Put', lCompCode, ' ', lReason);
  except
    on E: Exception do
    begin
      Writeln('MQPut error: ', E.Message);
      //FLog.Add('MQPut error: ' + E.Message, -1);
    end;
  end;
end;

function TMQClient.PutData(const aData: RawByteString; const aFormat: String; const aIsClose: Boolean): Boolean;
begin
  Result := False;

  if (aData = '') then
    Exit;
  if (IsOpen = False) then
    if (innerOpenWrite = False) then
      Exit;
  try
    Result := MQPut(aData, aFormat);
  finally
    if aIsClose then
      innerClose;
  end;
end;

function TMQClient.PutMessage(const aMessage: String; const aIsConvert, aIsClose: Boolean): Boolean;
 var
  LBuffer: RawByteString;
begin
  Result := False;

  if (aMessage = '') then
    Exit;
  if (innerOpenWrite = False) then
    Exit;

  try
    if aIsConvert then
      LBuffer := UTF8Encode(aMessage)
    else
      LBuffer := AnsiString(aMessage);
    Result := MQPut(LBuffer, 'MQFMT_STRING');
  finally
    if aIsClose then
      innerClose;
  end;
end;

function GetUniqueFileName(aOldFileName: string; aExtension: string): string;
var
  lStr: string;
  lCnt: integer;
begin
  if aOldFileName = '' then
    exit;

  lStr := aOldFileName;
  lCnt := 1;
  while FileExists(lStr + '.' + aExtension, false) do
  begin
    lStr := aOldFileName + '_' + IntToStr(lCnt);
    Inc(lCnt);
  end;

  result := lStr + '.' + aExtension;
end;

//function TMQClient.SaveMessageWithDescriptor: string;
//var
//  lFileName, lExt : string;
//  lText, lDesc, lFullText : ansistring;
//begin
//  lFileName := IncludeTrailingPathDelimiter(GetEnvironmentVariable('temp')) + 'MQMDs' + PathDelim;
//  if System.SysUtils.ForceDirectories(lFileName) then
//  begin
//    lExt := 'xml';
//    lFileName := lFileName + FormatDateTime('yymmdd_hhmmsszzz', now);
//    lFileName := GetUniqueFileName(lFileName, lExt);
//
//    SetLength(lText, fDataLength);
//    Move(fBufferData[0], lText[1], fDataLength);
//
//    SetLength(lDesc, sizeof(MQMD_DEFAULT));
//    Move(fMessageDescription, lDesc[1], sizeof(MQMD_DEFAULT));
//
//    lFullText := lDesc + lText;
//    if SaveMessageFile(lFileName, lFullText) = 0 then
//      Result := ExtractFileName(lFileName);
////      Result := ExtractWord(WordCount(lFileName, [PathDelim]), lFileName, [PathDelim]);
//  end;
//end;

//function XMLVar2Str(v: Variant): string;
//begin
//  result := '';
//
//  if v = null then
//    v := '';
//
//  result := trim(Variants.VarToStr(v));
//end;

function GetMQMessageType(aMessageText: AnsiString; aMQQueueIdent: string): string;
var
//  aiXmlDocument: iXmlDocument;
  aDocumentTypeCode: string;
begin
  result := '';

  if AnsiUpperCase(aMQQueueIdent) = 'CARGOSPOT' then
  begin
    raise Exception.Create('реализуй');
//    aDocumentTypeCode := '';
//
//    try
//      aiXmlDocument := TXmlDocument.Create(nil);
//      aiXmlDocument.LoadFromXML(aMessageText);
//
//      (*
//        <?xml version="1.0" encoding="UTF-8"?>
//        <rsm:HouseManifest xmlns:rsm="iata:housemanifest:1" xmlns:ccts="urn:un:unece:uncefact:.....
//        <rsm:MessageHeaderDocument>
//        <ram:ID/>
//        <ram:Name>Cargo Manifest</ram:Name>
//        <ram:TypeCode>785</ram:TypeCode>
//      *)
//
//      aDocumentTypeCode := XMLVar2Str(aiXmlDocument.ChildNodes[1].ChildNodes[0].ChildNodes[2].NodeValue);

//    except
//    end;

    (*
      XFFM, Flight Manifest,  122, Transport Loading Report
      XFHL, House Manifest,   785, Cargo Manifest
      XFWB, Waybill,          740, Air Waybill
      XFWB, Master Waybill,   741, Master Air Waybill
      XFZB, House Waybill,    703, House waybill
    *)

    if aDocumentTypeCode = '122' then
      result := 'XFFM'
    else if aDocumentTypeCode = '785' then
      result := 'XFHL'
    else if aDocumentTypeCode = '740' then
      result := 'XFWB'
    else if aDocumentTypeCode = '741' then
      result := 'XFWB'
    else if aDocumentTypeCode = '703' then
      result := 'XFZB';

  end
  else
    result := aMQQueueIdent;

end;

end.
