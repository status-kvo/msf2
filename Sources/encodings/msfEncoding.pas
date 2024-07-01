unit msfEncoding;

interface

uses
  SysUtils, Classes;

type
  cEncoding = class abstract
   public
    class function EncodeStreamToString(aStream: TStream): String; virtual; abstract;
    class function EncodeStringToString(const aText: String): String;
    class function EncodeBytesToString(aData: PByte; const aLength: NativeUInt): String;
  end;

type
  cDecoding = class abstract
   public
    //class function EncodeStreamToString(aStream: TStream): String; virtual; abstract;
    class function DecodeStringToString(const aText: String): String; virtual; abstract;
  end;

implementation

{ cEncoding }

class function cEncoding.EncodeBytesToString(aData: PByte; const aLength: NativeUInt): String;
 var
  LStream: TStream;
begin
  LStream := nil;
  try
    LStream := TMemoryStream.Create;
    LStream.WriteBuffer(aData^, aLength);
    LStream.Position := 0;
    Result := EncodeStreamToString(LStream)
  finally
    LStream.Free
  end
end;

class function cEncoding.EncodeStringToString(const aText: String): String;
begin
  Result := EncodeBytesToString(PByte(aText), NativeUInt(Length(aText)))
end;

end.
