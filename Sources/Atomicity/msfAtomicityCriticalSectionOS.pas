unit msfAtomicityCriticalSectionOS;

interface

uses
  SyncObjs,
  msfAtomicityCriticalSection;

type
  cAtomicityCriticalSectionOS = class sealed(cAtomicityCriticalSection)
   protected
    var fCriticalSection: TCriticalSection;
   public
    procedure Lock; override;
   public
    procedure UnLock; override;
   public
    constructor Create; override;
   public
    destructor Destroy; override;
  end;

implementation

{ cAtomicityCriticalSectionOS }

constructor cAtomicityCriticalSectionOS.Create;
begin
  inherited;

  fCriticalSection := TCriticalSection.Create
end;

destructor cAtomicityCriticalSectionOS.Destroy;
begin
  fCriticalSection.Free;
  fCriticalSection := nil;

  inherited
end;

procedure cAtomicityCriticalSectionOS.Lock;
begin
  fCriticalSection.Enter
end;

procedure cAtomicityCriticalSectionOS.UnLock;
begin
  fCriticalSection.Leave
end;

end.
