unit msfTransportQueue;

{$INCLUDE msfBase.inc}

{$IFDEF SUPPORTS-SECTION-INTERFACE}
interface
{$ENDIF}

uses
  msfSimple, msfParams,
  msfTransportChannel;

type
  cQueue = class abstract(cSimple)
   public
    constructor Create(aChannel: cChannel; aParams: cParams); reintroduce; virtual;
  end;

implementation

end.
