unit msfTransport;

{$INCLUDE msfBase.inc}

{$IFDEF SUPPORTS-SECTION-INTERFACE}
interface
{$ENDIF}

uses
  msfConnection;

type
  cTransport = class abstract(cConnection)

  end;

implementation

end.
