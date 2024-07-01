unit msfDbRawFbExportJson;

interface

uses
  Types, SysUtils, Hash, Classes,
  {$IF DEFINED(FPC)}
    base64,
  {$ELSE}
    System.NetEncoding,
  {$ENDIF}
  Neslib.Json, Neslib.Json.IO, System.JSON.Writers,
  msfErrors,
  msfDbRawExport, msfDbRawExportJson,
  msfDbRawFbApi, msfDbRawFbUtils;

function DataSetExportJson(aFirebird: cFirebird; aQuery: ResultSet; aTransaction: Transaction; const aPkIds: TStringDynArray; const aIsHash: Boolean;
 const aBlockSize, aMaxFileSize: NativeUInt; const aCommand: Char; const aIdent: string; aEvent: cEventExport): NativeUInt;

implementation

procedure innerAddPkIds(const aPkIds: TStringDynArray; var aObject: TJsonValue);
 var
  LPkIds: TJsonValue;
  LId: String;
begin
  LPkIds := aObject.AddOrSetArray('pk_ids');

  if (Length(aPkIds) = 0) then
    Exit;

  for LId in aPkIds do
    LPkIds.Add(LId);
end;

procedure innerWriteFieldsDDL(aFirebird: cFirebird; aMeta: MessageMetadata; const aIsHash: Boolean; var aObject: TJsonValue);
 var
  LJsonFields, LJsonField: TJsonValue;
  LIndex, LCount, LTypeI: Cardinal;
  LKind: String;
  LRaw: RawByteString;
  LType: eFbType;
begin
  LJsonFields := aObject.AddOrSetArray('fields');

  LCount := aMeta.getCount(aFirebird.Status);
  FbException.checkException(aFirebird.Status);
  
  for LIndex := 0 to Pred(LCount) do
  begin
    LJsonField := LJsonFields.AddDictionary;
    
    LRaw := RawByteString(aMeta.getAlias(aFirebird.Status, LIndex));
    FbException.checkException(aFirebird.Status);
    LJsonField.AddOrSetValue('ident', String(LRaw));

    LTypeI := aMeta.getType(aFirebird.Status, LIndex);   
    FbException.checkException(aFirebird.Status);
    
    LType := eFbType(LTypeI);
  
    case LType of
      SQL_BOOLEAN:
        LKind := 'boolean';
      SQL_SHORT:
        LKind := 'int16';
      SQL_LONG:
        LKind := 'int32';
      SQL_INT64:
        LKind := 'int64';
      SQL_FLOAT:
        LKind := 'double';
      SQL_DOUBLE, SQL_D_FLOAT:
        LKind := 'double';
      SQL_DATE:
        LKind := 'date';
      SQL_TIME:
        LKind := 'time';
      SQL_TIMESTAMP:
        LKind := 'datetime';
      SQL_TEXT, SQL_VARYING:
        LKind := 'varchar(' + IntToStr(aMeta.getLength(aFirebird.Status, LIndex)) + ')';
      SQL_BLOB, SQL_QUAD:
        case aMeta.getSubType(aFirebird.Status, LIndex) of
          1: LKind := 'text'
        else
          LKind := 'binary'
        end;
      else
        raise Exception.CreateFmt(rsUnknownType, [String(LRaw)]);
    end;
    FbException.checkException(aFirebird.Status);

    LJsonField.AddOrSetValue('kind', LKind);
  end;

  if (aIsHash = False) then
    Exit;

  LJsonField := LJsonFields.AddArray();
  LJsonField.AddOrSetValue('ident', 'source$hash');
  LJsonField.AddOrSetValue('kind', 'varchar(32)');
end;

type
  THashMD5P = ^THashMD5;

function innerBlobToStream(const aQuad: ISC_QUADPtr; aFirebird: cFirebird; aTransaction: Transaction): TMemoryStream;
begin
  Result := nil;
  try
    Result := TMemoryStream.Create;
    
    aFirebird.BlobToStream(aQuad, aTransaction, Result);
    Result.Position := 0;
  except
    Result.Free;
    raise;
  end;
end;

function innerStreamToBase64(aStream: TStream): String;
 var
  LStringStream: TStringStream;
  {$IF NOT DEFINED(FPC)}
    LBase64Encoding: TBase64Encoding;
  {$ENDIF}
begin
  LStringStream := nil;
  try
    LStringStream := TStringStream.Create;

    {$IF DEFINED(FPC)}
      LStringStream.LoadFromStream(aStream);
      Result := EncodeStringBase64(LStringStream.DataString);
    {$ELSE}
      LBase64Encoding := nil;
      try
        LBase64Encoding := TBase64Encoding.Create(0);
        LBase64Encoding.Encode(aStream, LStringStream);
      finally
        LBase64Encoding.Free;
      end;
      Result := LStringStream.DataString;
    {$ENDIF}
  finally
    LStringStream.Free;
  end;
end;

function innerStringToBase64(const aText: string): String;
 var
  LStringStream: TStringStream;
begin
  LStringStream := nil;
  try
    LStringStream := TStringStream.Create(aText);
    Result := innerStreamToBase64(LStringStream)
  finally
    LStringStream.Free
  end;
end;

function innerWriteField(aFirebird: cFirebird; aTransaction: Transaction; aMeta: MessageMetadata; const aData: TBytes; const aIndex: Cardinal;
  var aRecord: TJsonValue; const aHash: THashMD5P): NativeUInt;
 var
  LStr, LFieldName: string;
  LOffset, LSize: Cardinal;
  LType: eFbType;
  LBool: Boolean;
  LInt64: Int64;
  LRaw: RawByteString;
  LExtended: Extended;
  LDateTime: TDateTime;
  LStream: TMemoryStream;
begin
  LStream := nil;

  try
    LOffset := aMeta.getNullOffset(aFirebird.Status, aIndex);
    FbException.checkException(aFirebird.Status);

    LRaw := RawByteString(aMeta.getAlias(aFirebird.Status, aIndex));
    FbException.checkException(aFirebird.Status);
    LFieldName := String(LRaw);
    Result := Length(LFieldName) + 5;

    LBool := Boolean(Bool16Ptr(@aData[LOffset])^);
    if LBool then
    begin
      aRecord.AddOrSetNull(LFieldName);
      Result := Result + 5;
      Exit;
    end;

    LStr := '';
               
    LSize := aMeta.getType(aFirebird.Status, aIndex);
    FbException.checkException(aFirebird.Status);
    LType := eFbType(LSize);

    LOffset := aMeta.getOffset(aFirebird.Status, aIndex);
    FbException.checkException(aFirebird.Status);

    case LType of
      SQL_BOOLEAN:
      begin
        LBool := Boolean(Bool16Ptr(@aData[LOffset])^);
        aRecord.AddOrSetValue(LFieldName, LBool);
        if LBool then
          Result := Result + 5
        else
          Result := Result + 6;
        if (aHash <> nil) then
        begin
          if LBool then
            LStr := 'true'
          else
            LStr := 'false';
            aHash^.Update(LStr);
        end;
      end;

      SQL_SHORT:
      begin
        LInt64 := ISC_SHORTPtr(@aData[LOffset])^;
        aRecord.AddOrSetValue(LFieldName, LInt64);
        Result := Result + 5;
        if (aHash <> nil) then
        begin
          LStr := IntToStr(LInt64);
          aHash^.Update(LStr);      
        end;
      end;
      
      SQL_LONG:  
      begin
        LInt64 := IntegerPtr(@aData[LOffset])^;
        aRecord.AddOrSetValue(LFieldName, LInt64);
        Result := Result + 11;
        if (aHash <> nil) then
        begin
          LStr := IntToStr(LInt64);
          aHash^.Update(LStr);      
        end;
      end;
      
      SQL_INT64:
      begin
        LInt64 := IntegerPtr(@aData[LOffset])^;
        aRecord.AddOrSetValue(LFieldName, LInt64);
        Result := Result + 21;
        if (aHash <> nil) then
        begin
          LStr := IntToStr(LInt64);
          aHash^.Update(LStr);      
        end;
      end;
      
      SQL_FLOAT:
      begin
        LExtended := PSingle(@aData[LOffset])^;
        aRecord.AddOrSetValue(LFieldName, LExtended);
        Result := Result + 46;
        if (aHash <> nil) then
        begin
          LStr := FloatToStr(LExtended);
          aHash^.Update(LStr);      
        end;
      end;
      
      SQL_DOUBLE, SQL_D_FLOAT:
      begin
        LExtended := PDouble(@aData[LOffset])^;
        aRecord.AddOrSetValue(LFieldName, LExtended);
        Result := Result + 46;
        if (aHash <> nil) then
        begin
          LStr := FloatToStr(LExtended);
          aHash^.Update(LStr);      
        end;
      end;
      
      SQL_DATE:
      begin
        LDateTime := aFirebird.IscDateToDate(ISC_DATEPtr(@aData[LOffset])^);
        LStr := DateToStr(LDateTime);
        aRecord.AddOrSetValue(LFieldName, LStr);
        Result := Result + NativeUInt(Length(LStr)) + 1;
        if (aHash <> nil) then
          aHash^.Update(LStr);
      end;
        
      SQL_TIME:
      begin
        LDateTime := aFirebird.IscTimeToTime(ISC_TimePtr(@aData[LOffset])^);
        LStr := TimeToStr(LDateTime);
        aRecord.AddOrSetValue(LFieldName, LStr);
        Result := Result + NativeUInt(Length(LStr)) + 1;
        if (aHash <> nil) then
          aHash^.Update(LStr);
      end;
        
      SQL_TIMESTAMP:
      begin
        LDateTime := aFirebird.IscTimestampToDateTime(ISC_TIMESTAMPPtr(@aData[LOffset])^);
        LStr := DateTimeToStr(LDateTime);
        aRecord.AddOrSetValue(LFieldName, LStr);
        Result := Result + NativeUInt(Length(LStr)) + 1;
        if (aHash <> nil) then
          aHash^.Update(LStr);
      end;
      
      SQL_TEXT:
      begin
        LSize := aMeta.getLength(aFirebird.Status, aIndex);
        FbException.checkException(aFirebird.Status);
        SetLength(LRaw, LSize);
        Move(aData[LOffset], LRaw[1], LSize);
        LStr := TrimRight(String(LRaw));
        aRecord.AddOrSetValue(LFieldName, LStr);
        Result := Result + LSize + 1;
        if (aHash <> nil) then
          aHash^.Update(LStr);      
      end;
      
      SQL_VARYING:
      begin
        with cVarChar.Create(aFirebird.Status, aMeta, aIndex, @aData[0]) do
          try
            LStr := AsString;
          finally
            Free
          end;

        aRecord.AddOrSetValue(LFieldName, LStr);
        Result := Result + NativeUInt(Length(LStr)) + 1;
        if (aHash <> nil) then
          aHash^.Update(LStr);
      end;

      SQL_BLOB, SQL_QUAD:
      begin
        LStream := innerBlobToStream(ISC_QUADPtr(@aData[LOffset]), aFirebird, aTransaction);
        LStr := innerStreamToBase64(LStream);
        aRecord.AddOrSetValue(LFieldName, LStr);
        Result := Result + NativeUInt(Length(LStr)) + 1;
        if (aHash <> nil) then
        begin
          LStream.Position := 0;
          aHash^.Update(LStream.Memory, LStream.Size);
        end;
      end;
      else
        raise Exception.CreateFmt(rsUnknownType, [LFieldName]);
    end;
  finally
    LStream.Free;
  end;
end;

function innerWriteRecord(var aRecords: TJsonValue; aFirebird: cFirebird; aTransaction: Transaction; aMeta: MessageMetadata; const aData: TBytes; const aIsHash: Boolean): NativeUInt;
 var
  LHashP: THashMD5P;
  LIndex, LCount: Cardinal;
  LRecord: TJsonValue;
begin
  Result := 60;

  LRecord := aRecords.AddDictionary;
  LHashP := nil;
  try
    if aIsHash then
    begin
      New(LHashP);
      LHashP^ := THashMD5.Create;
    end;

    LCount := aMeta.getCount(aFirebird.Status);
    FbException.checkException(aFirebird.Status);

    if (LCount > 0) then
      for LIndex := 0 to Pred(LCount) do
        Result := Result + innerWriteField(aFirebird, aTransaction, aMeta, aData, LIndex, LRecord, LHashP);

    LRecord.AddOrSetDictionary('pk_old');

    if aIsHash then
      LRecord.AddOrSetValue('source$hash', LHashP^.HashAsString)
    else
      LRecord.AddOrSetNull('source$hash')
  finally
    if (LHashP <> nil) then
      Dispose(LHashP);
  end;
end;

procedure innerEventBlock(var aBlockObject: IJsonDocument; var aBlockIndex: NativeUInt; aEvent: cEventExport);
 var
  LBlock: PJSONValue;
  LJSONValue: TJSONValue;
begin
  LJSONValue := aBlockObject.Root;
  LBlock := @LJSONValue;
  aEvent.OnEvent(Pointer(LBlock), aBlockIndex);
  aBlockObject := nil;
  Inc(aBlockIndex)
end;

function innerWriteRecords(aFirebird: cFirebird; aQuery: ResultSet; aMeta: MessageMetadata; aTransaction: Transaction; var aBase: TJSONValue;
  const aIsHash: Boolean; aBlockSize: NativeUInt; const aMaxFileSize: NativeUInt; const aEvent: cEventExport): NativeUInt;
 var
  LImport: IJsonDocument;
  LRecords: TJSONValue;
  LBlockIndex, LRecordIndexBlock, LFileSize: NativeUInt;
  LData: TBytes;
  LIsReCreate: Boolean;
begin
  Result := 0;
  LBlockIndex := 1;
  LRecordIndexBlock := 0;
  LImport := nil;

  if (aBlockSize = 0) then
    aBlockSize := aBlockSize.MaxValue;

  SetLength(LData, aMeta.getMessageLength(aFirebird.Status));
  LFileSize := 0;
  while (aQuery.fetchNext(aFirebird.Status, @LData[0]) = Status.RESULT_OK) do
  begin
    Inc(Result);
    Inc(LRecordIndexBlock);

    LIsReCreate := (LRecordIndexBlock > aBlockSize);
    if (LIsReCreate = False) then
      if (aMaxFileSize > 0) then
        LIsReCreate := (LFileSize >= aMaxFileSize);

    if LIsReCreate then
    begin
      innerEventBlock(LImport, LBlockIndex, aEvent);
      LRecordIndexBlock := 1;
      LFileSize := 0;
    end;

    if (LImport = nil) then
    begin
      LImport := TJsonDocument.Parse(aBase.ToJson(False));
      LRecords := LImport.Root.AddOrSetArray('records');
    end;

    LFileSize := LFileSize + innerWriteRecord(LRecords, aFirebird, aTransaction, aMeta, LData, aIsHash);
  end;
  
  if (LImport <> nil) then
    innerEventBlock(LImport, LBlockIndex, aEvent)
end;

function DataSetExportJson(aFirebird: cFirebird; aQuery: ResultSet; aTransaction: Transaction; const aPkIds: TStringDynArray; const aIsHash: Boolean;
  const aBlockSize, aMaxFileSize: NativeUInt; const aCommand: Char; const aIdent: string; aEvent: cEventExport): NativeUInt;
 var
  LImportBase: IJsonDocument;
  LRoot: TJsonValue;
  LMeta: MessageMetadata;
begin
  LImportBase := nil;
  try
    LImportBase := TJsonDocument.CreateDictionary;
    LRoot := LImportBase.Root;

    LRoot.AddOrSetValue('ident', aIdent);
    innerAddPkIds(aPkIds, LRoot);
    LRoot.AddOrSetValue('operation', aCommand);

    LMeta := aQuery.getMetadata(aFirebird.Status);
    FbException.checkException(aFirebird.Status);
    innerWriteFieldsDDL(aFirebird, LMeta, aIsHash, LRoot);

    Result := innerWriteRecords(aFirebird, aQuery, LMeta, aTransaction, LRoot, aIsHash, aBlockSize, aMaxFileSize, aEvent);
  finally
    LImportBase := nil;
    aEvent.Free
  end;
end;


end.
