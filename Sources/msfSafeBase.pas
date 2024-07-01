unit msfSafeBase;

{$INCLUDE msfBase.inc}

{$IFDEF SUPPORTS-SECTION-INTERFACE}
interface
{$ENDIF}

uses
  msfAtomicity;

type
  cSafe = class abstract
   private
    var fIsOwner: Boolean;
   private
    var fAtomicity: cAtomicity;
   public
    procedure UnLock; virtual;
   public
    constructor Create(const aIsOwner: Boolean);
   public
    destructor Destroy; override;
  end;

type
  cSafe<kContent> = class abstract(cSafe)
   private
    type kContentP = ^kContent;
   private
    var fContent: kContent;
   public
    function Lock: kContentP;
   public
    constructor Create(const aIsOwner: Boolean; const aContent: kContent);
  end;

type
  cSafeSealed<kContent> = class sealed(cSafe<kContent>);

implementation

{ cSafe }

constructor cSafe.Create(const aIsOwner: Boolean);
begin
  inherited Create;
  fIsOwner := aIsOwner;
  fAtomicity := cAtomicity.ByDefault.Create
end;

destructor cSafe.Destroy;
begin
  fAtomicity.Free;
  fAtomicity := nil;
  inherited;
end;

procedure cSafe.UnLock;
begin
  fAtomicity.Unlock
end;

{ cSafe<kContent> }

constructor cSafe<kContent>.Create(const aIsOwner: Boolean; const aContent: kContent);
begin
  inherited Create(aIsOwner);
  fContent := aContent
end;

function cSafe<kContent>.Lock: kContentP;
begin
  Result := @fContent
end;

end.
