unit msfTransportChannel;

{$INCLUDE msfBase.inc}

{$IFDEF SUPPORTS-SECTION-INTERFACE}
interface
{$ENDIF}

uses
  msfSimple, msfParams,
  msfCallbackMessage, msfTransport;

type
  cTransportChannel = class abstract(cTransport)
   public type
    cChannel = class abstract(cSimple)
     private
      var fTransport: cTransportChannel;
     public
      property Transport: cTransportChannel read fTransport;
     public
      destructor Destroy; override;
    end;
   private
    procedure innerChannelDestroy(aChannel: cChannel);
   public
  end;

type
  cChannel = class abstract(cSimple)
   private
    var fTransport: cTransportChannel;
   public
    property Transport: cTransportChannel read fTransport;
   public
    procedure ConsumeCallback(aCallback: cCallbackMessage; aParams: cParams);
   public
    constructor Create(aTransport: cTransportChannel; aParams: cParams); reintroduce; virtual;
  end;

implementation

{ cChannel }

procedure cChannel.ConsumeCallback(aCallback: cCallbackMessage; aParams: cParams);
begin

end;

constructor cChannel.Create(aTransport: cTransportChannel; aParams: cParams);
begin
  inherited Create;
end;

{ cTransportChannel.cChannel }

destructor cTransportChannel.cChannel.Destroy;
begin
  fTransport.innerChannelDestroy(Self);
  inherited;
end;

{ cTransportChannel }

procedure cTransportChannel.innerChannelDestroy(aChannel: cChannel);
begin
  fChannel.Lock;
  try

  finally
    fChannel.Unlock;
  end;
end;

end.
