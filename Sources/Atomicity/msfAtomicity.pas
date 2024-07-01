unit msfAtomicity;

interface

type
  cAtomicity = class abstract
   public type
    tAtomicityClass = class of cAtomicity;
   private
    class var fByDefault: tAtomicityClass;
   protected
    class procedure innerAssignAsDefault;
   public
    procedure Lock; virtual; abstract;
   public
    procedure UnLock; virtual; abstract;
   public
    class function New: cAtomicity; virtual;
   public
    class property ByDefault: tAtomicityClass read fByDefault;
   public
    constructor Create; virtual;
  end;

implementation

uses
  msfAtomicityCriticalSectionOS;

{ cAtomicity }

constructor cAtomicity.Create;
begin
  inherited Create;
end;

class procedure cAtomicity.innerAssignAsDefault;
begin
  fByDefault := Self
end;

class function cAtomicity.New: cAtomicity;
begin
  Result := fByDefault.Create
end;

initialization
  cAtomicityCriticalSectionOs.innerAssignAsDefault

end.
