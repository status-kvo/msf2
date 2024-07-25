unit msfTransportMqWmq;

{$INCLUDE msfBase.inc}

{$IFDEF SUPPORTS-SECTION-INTERFACE}
interface
{$ENDIF}

uses
  msfTypes, msfSimple,
  msfTransportMq;

type
  cTransportMqWmq = class abstract(cTransportMq)
   protected
    function innerVersionGet: rVersion; override;
   protected
    function innerIsConnected: Boolean; override;
   public
    function Connect: Boolean; override;
    procedure Disconnect; override;
  end;

type
  cTransportMqWmqSealed = class sealed(cTransportMqWmq);

implementation

{ cTransportMqWmq }

function cTransportMqWmq.Connect: Boolean;
begin

end;

procedure cTransportMqWmq.Disconnect;
begin
  inherited;

end;

function cTransportMqWmq.innerIsConnected: Boolean;
begin

end;

function cTransportMqWmq.innerVersionGet: rVersion;
begin
  Result.major   := 1;
  Result.minor   := 0;
  Result.version := 0;
  Result.build   := 1;
end;

end.
