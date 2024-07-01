unit msfTypes;

{$INCLUDE msfBase.inc}

{$IFDEF SUPPORTS_SECTION_INTERFACE}
interface
{$ENDIF}

type
  UIntPtr = NativeUInt;

type
  rVersion = record
    major:   UInt32;
    minor:   UInt32;
    version: UInt32;
    build:   UInt32;
  end;

implementation

end.
