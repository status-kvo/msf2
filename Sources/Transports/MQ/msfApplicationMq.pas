unit msfApplicationMq;

{$INCLUDE msfBase.inc}

{$IFDEF SUPPORTS-SECTION-INTERFACE}
interface
{$ENDIF}

uses
  msfApplicationTransport,
  msfTransportMq;

type
  cApplicationTransportMq = class abstract(cApplicationTransport)
   protected
    function innerTransportGet: cTransportMq;
   public
    property Transport: cTransportMq read innerTransportGet;
  end;

implementation

{ cApplicationTransportMq }

function cApplicationTransportMq.innerTransportGet: cTransportMq;
begin
  Result := cTransportMq(inherited Transport)
end;

end.
