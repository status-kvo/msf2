unit msfApplicationTransport;

{$INCLUDE msfBase.inc}

{$IFDEF SUPPORTS-SECTION-INTERFACE}
interface
{$ENDIF}

uses
  msfApplication,
  msfTransport;

type
  cApplicationTransport = class abstract(cApplication)
   private
    const cSourceShort = 's';
   private
    const cSourceFull = 'source';
   private
    var fTransport: cTransport;
   protected
    function innerInit: Boolean; override;
    function innerStart: Boolean; override;
    function innerRun: Boolean; override;
    procedure innerStop; override;
   public
    property Transport: cTransport read fTransport;
  end;

implementation

{ cApplicationTransport }

function cApplicationTransport.innerInit: Boolean;
begin
  Result := False;
  fTransport := nil;
  if (OptionHas(cSourceShort, cSourceFull) = False) then
    Exit;
  Result := True
end;

function cApplicationTransport.innerRun: Boolean;
begin
//  fTransport.Run;
  Result := False;
end;

function cApplicationTransport.innerStart: Boolean;
begin
  Result := False;
//  fTransport := cDbConvert.Create(OptionValueGet(cSourceShort, cSourceFull, True), OptionValueGet(cDbToShort, cDbToFull, True));
//  Result := fTransport.IsCheck
end;

procedure cApplicationTransport.innerStop;
begin
//  fTransport.Free;
//  fTransport := nil;

  inherited;
end;

end.
