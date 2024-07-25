unit msfApplicationMqWmq;

{$INCLUDE msfBase.inc}

{$IFDEF SUPPORTS-SECTION-INTERFACE}
interface
{$ENDIF}

uses
  msfApplicationMq,
  msfTransportMqWmq;

type
  cApplicationTransportMqWmq = class abstract(cApplicationTransportMq)
   protected
    function innerTransportGet: cTransportMqWmq;
   public
    property Transport: cTransportMqWmq read innerTransportGet;
  end;

implementation

{ cApplicationTransportMqWmq }

function cApplicationTransportMqWmq.innerTransportGet: cTransportMqWmq;
begin
  Result := (inherited Transport) as cTransportMqWmq
end;

end.
