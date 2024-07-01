unit msfEncodingBase64;

interface

uses
  {$IF DEFINED(FPC)}
    base64,
  {$ELSE}
    System.NetEncoding,
  {$ENDIF}
  SysUtils, Classes,
  msfEncoding;

type
  cEncodingBase64 = class(cEncoding)
   public
    class function EncodeStreamToString(aStream: TStream): String; override;
  end;

type
  cDecodingBase64 = class(cDecoding)
   public
    //class function DecodeStringToStream(aStream: TStream): String; override;
    class function DecodeStringToString(const aText: String): String; override;
  end;

implementation

{ cDecodingBase64 }

class function cDecodingBase64.DecodeStringToString(const aText: String): String;
begin
  {$IFDEF FPC}
    Result := DecodeStringBase64(aText)
  {$ELSE}
    Result := TNetEncoding.Base64.Decode(aText);
  {$ENDIF}
end;

{ cEncodingBase64 }

class function cEncodingBase64.EncodeStreamToString(aStream: TStream): String;
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

end.
