unit msfLog;

interface

uses
  SysUtils;

type
  tEventType = (etCustom = 0, etInfo, etWarning, etError, etDebug);

type
  tEventTypeSet = set of TEventType;

const
  cEventTypeAll = [etCustom..etDebug];

type
  cLog = class abstract
   public type
    tLogClass = class of cLog;
   private
    var fEventsFilter: tEventTypeSet;
   private
    class var fByDefaultInstance: cLog;
   private
    class var fByDefaultClass: tLogClass;
   private
    function innerEventsFilterGet: tEventTypeSet;
   private
    procedure innerEventsFilterSet(const aNew: tEventTypeSet);
   protected
    procedure Lock; virtual; abstract;
   protected
    procedure UnLock; virtual; abstract;
   protected
    procedure innerAdd(const aEventType: TEventType; const aMessage: String); virtual; abstract;
   public
    procedure Add(const aEventType: TEventType; const aMessage: String);
   public
    procedure AddWithFormat(const aEventType: TEventType; const aFormat: String; const aArgs: Array of const);
   public
    procedure AddCustom(const aMessage: String);
   public
    procedure AddCustomWithFormat(const aFormat: String; const aArgs: Array of const);
   public
    procedure AddInfo(const aMessage: String);
   public
    procedure AddInfoWithFormat(const aFormat: String; const aArgs: Array of const);
   public
    procedure AddWarning(const aMessage: String);
   public
    procedure AddWarningWithFormat(const aFormat: String; const aArgs: Array of const);
   public
    procedure AddError(const aMessage: String);
   public
    procedure AddErrorWithFormat(const aFormat: String; const aArgs: Array of const);
   public
    procedure AddDebug(const aMessage: String);
   public
    procedure AddDebugWithFormat(const aFormat: String; const aArgs: Array of const);
   public
    property EventsFilter: tEventTypeSet read innerEventsFilterGet write innerEventsFilterSet;
   public
    class function New: cLog; virtual;
   public
    class property ByDefaultClass: tLogClass read fByDefaultClass write fByDefaultClass;
   public
    constructor Create; virtual;
   public
    class constructor Create;
   public
    class destructor Destroy;
  end;

implementation

{ cLog }

procedure cLog.Add(const aEventType: TEventType; const aMessage: String);
begin
  Lock;
  try
    if ((aEventType in fEventsFilter) = False) then
      Exit;
    innerAdd(aEventType, aMessage)
  finally
    UnLock
  end
end;

procedure cLog.AddCustom(const aMessage: String);
begin
  Add(etCustom, aMessage)
end;

procedure cLog.AddCustomWithFormat(const aFormat: String; const aArgs: Array of const);
begin
  AddWithFormat(etCustom, aFormat, aArgs)
end;

procedure cLog.AddDebug(const aMessage: String);
begin
  Add(etDebug, aMessage)
end;

procedure cLog.AddDebugWithFormat(const aFormat: String; const aArgs: Array of const);
begin
  AddWithFormat(etDebug, aFormat, aArgs)
end;

procedure cLog.AddError(const aMessage: String);
begin
  Add(etError, aMessage)
end;

procedure cLog.AddErrorWithFormat(const aFormat: String; const aArgs: Array of const);
begin
  AddWithFormat(etError, aFormat, aArgs)
end;

procedure cLog.AddInfo(const aMessage: String);
begin
  Add(etInfo, aMessage)
end;

procedure cLog.AddInfoWithFormat(const aFormat: String; const aArgs: Array of const);
begin
  AddWithFormat(etInfo, aFormat, aArgs)
end;

procedure cLog.AddWarning(const aMessage: String);
begin
  Add(etWarning, aMessage)
end;

procedure cLog.AddWarningWithFormat(const aFormat: String; const aArgs: Array of const);
begin
  AddWithFormat(etWarning, aFormat, aArgs)
end;

procedure cLog.AddWithFormat(const aEventType: TEventType; const aFormat: String; const aArgs: Array of const);
begin
  Add(aEventType, Format(aFormat, aArgs))
end;

class constructor cLog.Create;
begin
  fByDefaultClass := nil;
end;

constructor cLog.Create;
begin
  inherited Create;
  fEventsFilter := cEventTypeAll
end;

class destructor cLog.Destroy;
begin
  fByDefaultClass := nil
end;

function cLog.innerEventsFilterGet: tEventTypeSet;
begin
  Lock;
  try
    Result := fEventsFilter
  finally
    UnLock
  end
end;

procedure cLog.innerEventsFilterSet(const aNew: tEventTypeSet);
begin
  Lock;
  try
    fEventsFilter := aNew
  finally
    UnLock
  end
end;

class function cLog.New: cLog;
begin
  Result := ByDefaultClass.Create
end;

end.
