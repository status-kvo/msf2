unit msfApplication;

interface

uses
  Types, SysUtils,
  msfLog, msfSingleInstance;

type
 tApplicationKind = (akUnknown=0, akConsole, akService, akGui);

type
  PStringDynArray = ^TStringDynArray;

type
  cApplication = class abstract
   private
    var fIsOptionsCaseSensitive: Boolean;
   private
    var fOptionChar: Char;
   private
    var fSingleInstance: cSingleInstance;
   private
    var fIsOwnerSingleInstance: Boolean;
   protected
    var fKind: tApplicationKind;
   protected
    var fTerminated: Boolean;
   protected
    var fLog: cLog;
   protected
    function innerLogCreate: cLog; virtual;
   private
    function innerOsEnvironmentVariableGet(const aName: String): String;
   private
    function innerBinaryLocationGet: String;
   private
    function innerBinaryNameGet: String;
   private
    function innerBinaryPathGet: String;
   private
    function innerBinaryParamCountGet: NativeInt;
   private
    function innerBinaryParamsGet(const aIndex: NativeInt): String;
   protected
    function innerIsThreadMulti: Boolean;
   protected
    function innerStopOnException(aException: Exception): Boolean; virtual;
   protected
    function innerInit: Boolean; virtual;
   protected
    function innerStart: Boolean; virtual;
   protected
    function innerRun: Boolean; virtual; abstract;
   protected
    procedure innerStop; virtual;
   protected
    procedure innerDeInit; virtual;
   protected
    function innerIsCheckSingleInstance: Boolean;
   public
    property Kind: tApplicationKind read fKind;
    property IsThreadMulti: Boolean read innerIsThreadMulti;
    property IsOptionsCaseSensitive: Boolean read fIsOptionsCaseSensitive write fIsOptionsCaseSensitive;
    property BinaryLocation: String read innerBinaryLocationGet;
    property BinaryName: String read innerBinaryNameGet;
    property BinaryPath: String read innerBinaryPathGet;
    property BinaryParams[const Index: NativeInt] : String read innerBinaryParamsGet;
    property BinaryParamCount: NativeInt read innerBinaryParamCountGet;
   private
    procedure innerOptionFind(const aFind: String; var aCount: NativeInt; const aArray: PStringDynArray);
    function innerOptionFindIndex(aFind: String; var aIsLongOption: Boolean; const aStartAt: NativeInt = -1): NativeInt;
    function innerOptionAtIndex(const aIndex: NativeInt; const aIsLong: Boolean): String;
   public
    function OptionValueByOnlyFullGet(const aNameFull: String; const aIsCheckEnvironmentVariable: Boolean = False): String;
    function OptionValueGet(const aNameShort: Char; const aNameFull: String; const aIsCheckEnvironmentVariable: Boolean = False): String;
    function OptionValuesGet(const aNameShort: Char; const aNameFull: String): TStringDynArray;
   public
    function OptionHasByOnlyFull(const aNameFull: String): Boolean;
    function OptionHas(const aNameShort: Char; const aNameFull: String; const aIsCheckEnvironmentVariable: Boolean = False): Boolean;
   public
    property OsEnvironmentVariable[const Name: String]: String read innerOsEnvironmentVariableGet;
   public
    procedure Log(const aEventType: TEventType; const aMessage: String);
    procedure LogWithFormat(const aEventType: TEventType; const aFormat: String; const aArgs: Array of const);
   public
    procedure LogCustom(const aMessage: String);
    procedure LogCustomWithFormat(const aFormat: String; const aArgs: Array of const);
   public
    procedure LogInfo(const aMessage: String);
    procedure LogInfoWithFormat(const aFormat: String; const aArgs: Array of const);
   public
    procedure LogWarning(const aMessage: String);
    procedure LogWarningWithFormat(const aFormat: String; const aArgs: Array of const);
   public
    procedure LogError(const aMessage: String);
    procedure LogErrorWithFormat(const aFormat: String; const aArgs: Array of const);
   public
    procedure LogDebug(const aMessage: String);
    procedure LogDebugWithFormat(const aFormat: String; const aArgs: Array of const);
   public
    procedure Terminate;
    procedure TerminateByCode(const aExitCode: NativeInt); virtual;
    property Terminated: Boolean read fTerminated;
   public
    property SingleInstance: cSingleInstance read fSingleInstance;
   public
    procedure Run;
   public
    constructor Create(const aSingleInstance: cSingleInstance = nil; const aIsOwnerSingleInstance: Boolean = True); virtual;
    destructor Destroy; override;
   public
    constructor CreateByParams(aSingleInstanceClass: tSingleInstanceClass = nil);
   public
    class procedure ExecuteByParams(const aSingleInstanceClass: tSingleInstanceClass = nil);
  end;

implementation

{ cApplication }

constructor cApplication.Create(const aSingleInstance: cSingleInstance; const aIsOwnerSingleInstance: Boolean);
begin
  fKind := akUnknown;
  fTerminated := False;
  fOptionChar := '-';
  IsOptionsCaseSensitive := True;
  fLog := innerLogCreate;

  if IsConsole then
    fKind := akConsole;

  fSingleInstance := aSingleInstance;
  if (fSingleInstance = nil) then
    fIsOwnerSingleInstance := False
  else
    fIsOwnerSingleInstance := aIsOwnerSingleInstance;

  if (innerIsCheckSingleInstance = False) then
  begin
    fTerminated := True;
    Exit
  end;

  fTerminated := (innerInit = False);
end;

constructor cApplication.CreateByParams(aSingleInstanceClass: tSingleInstanceClass);
 var
  LInstance: cSingleInstance;
  LIsOwner: Boolean;
begin
  if (aSingleInstanceClass = nil) then
  begin
    aSingleInstanceClass := GSingleInstanceClass;
    LIsOwner := False
  end
  else
    LIsOwner := True;

  LInstance := nil;
  try
    if (aSingleInstanceClass <> nil) then
      LInstance := aSingleInstanceClass.Create;
    Self.Create(LInstance, LIsOwner);
    LInstance := nil;
  finally
    LInstance.Free;
  end;
end;

destructor cApplication.Destroy;
begin
  try
    innerDeInit;
  finally
    if fIsOwnerSingleInstance then
      fSingleInstance.Free;
    fSingleInstance := nil;
  end;
  inherited;
end;

class procedure cApplication.ExecuteByParams(const aSingleInstanceClass: tSingleInstanceClass);
 var
  LApplication: cApplication;
begin
  LApplication := nil;
  try
    LApplication := Self.CreateByParams(aSingleInstanceClass);
    LApplication.Run
  finally
    LApplication.Free
  end;
end;

function cApplication.innerBinaryLocationGet: String;
begin
  Result := ExtractFilePath(BinaryPath)
end;

function cApplication.innerBinaryNameGet: String;
begin
  Result := ExtractFilePath(BinaryPath)
end;

function cApplication.innerBinaryParamCountGet: NativeInt;
begin
  Result := ParamCount
end;

function cApplication.innerBinaryParamsGet(const aIndex: NativeInt): String;
begin
  Result := ParamStr(aIndex)
end;

function cApplication.innerBinaryPathGet: String;
begin
  Result := ParamStr(0)
end;

procedure cApplication.innerDeInit;
begin
  // virtual
end;

function cApplication.innerInit: Boolean;
begin
  Result := True
end;

function cApplication.innerIsCheckSingleInstance: Boolean;
begin
  Result := True;
  if (fSingleInstance = nil) then
    Exit;
  Result := fSingleInstance.IsCheck
end;

function cApplication.innerIsThreadMulti: Boolean;
begin
  Result := IsMultiThread
end;

function cApplication.innerLogCreate: cLog;
begin
  if (cLog.ByDefaultClass = nil) then
    Exit;
  Result := cLog.New
end;

function cApplication.innerOsEnvironmentVariableGet(const aName: String): String;
begin
  Result := GetEnvironmentVariable(aName)
end;

function cApplication.innerStart: Boolean;
begin
  Result := True
end;

procedure cApplication.innerStop;
begin
  fTerminated := True
end;

function cApplication.innerStopOnException(aException: Exception): Boolean;
begin
  Result := True;
  ShowException(aException, ExceptAddr);
  LogErrorWithFormat('%s: %s', [aException.ClassName, aException.Message])
end;

procedure cApplication.Log(const aEventType: TEventType; const aMessage: String);
begin
  if (fLog = nil) then
    Exit;
  fLog.Add(aEventType, aMessage)
end;

procedure cApplication.LogWithFormat(const aEventType: TEventType; const aFormat: String; const aArgs: array of const);
begin
  if (fLog = nil) then
    Exit;
  fLog.AddWithFormat(aEventType, aFormat, aArgs)
end;

function cApplication.OptionHas(const aNameShort: Char; const aNameFull: String; const aIsCheckEnvironmentVariable: Boolean): Boolean;
var
  LIsLong: Boolean;
begin
  Result := (innerOptionFindIndex(aNameShort, LIsLong) <> -1) or OptionHasByOnlyFull(aNameFull);
  if (Result = False) then
    if (aIsCheckEnvironmentVariable) then
      Result := (OsEnvironmentVariable[aNameFull] > '')
end;

function cApplication.OptionHasByOnlyFull(const aNameFull: String): Boolean;
var
  LIsLong: Boolean;
begin
  Result:= (innerOptionFindIndex(aNameFull, LIsLong) <> -1);
end;

function cApplication.OptionValueByOnlyFullGet(const aNameFull: String; const aIsCheckEnvironmentVariable: Boolean): String;
begin
  Result := OptionValueGet(#255, aNameFull, aIsCheckEnvironmentVariable)
end;

function cApplication.OptionValueGet(const aNameShort: Char; const aNameFull: String; const aIsCheckEnvironmentVariable: Boolean): String;
 var
  LBool: Boolean;
  LIndex: NativeInt;
begin
  Result := '';
  LIndex := innerOptionFindIndex(aNameShort, LBool);
  if (LIndex = -1) then
    LIndex := innerOptionFindIndex(aNameFull, LBool);
  if (LIndex = -1) then
  begin
    if (aIsCheckEnvironmentVariable) then
      Result := OsEnvironmentVariable[aNameFull];
    Exit;
  end;
  Result := innerOptionAtIndex(LIndex, LBool)
end;

procedure cApplication.innerOptionFind(const aFind: String; var aCount: NativeInt; const aArray: PStringDynArray);
 var
  LIndex: NativeInt;
  LBool: Boolean;
begin
  LIndex := -1;
  repeat
    LIndex := innerOptionFindIndex(aFind, LBool, LIndex);
    if (LIndex = -1) then
      Break;
    if (aArray <> nil) then
      aArray^[aCount] := innerOptionAtIndex(LIndex, False);
    Inc(aCount);
    Dec(LIndex);
  until (LIndex = -1);
end;

function cApplication.innerOptionAtIndex(const aIndex: NativeInt; const aIsLong: Boolean): String;
var
  LPosition: NativeInt;
  LOption: String;
begin
  Result := '';
  if (aIndex = -1) then
    Exit;

  if aIsLong then
  begin
    LOption := BinaryParams[aIndex];
    LPosition := Pos('=', LOption);
    if (LPosition = 0) then
      LPosition := Length(LOption);
    Delete(LOption, 1, LPosition);
    Result := LOption;
    Exit;
  end;

  if (aIndex >= ParamCount) then
    Exit;

  LOption := Copy(BinaryParams[Succ(aIndex)], 1, 1);
  if (LOption <> fOptionChar) then
    Result := BinaryParams[Succ(aIndex)];
end;

function cApplication.innerOptionFindIndex(aFind: String; var aIsLongOption: Boolean; const aStartAt: NativeInt): NativeInt;
 var
  LOption: String;
  LIndex, LPosition: NativeInt;
begin
  if (fIsOptionsCaseSensitive = False) then
    aFind := UpperCase(aFind);

  Result := -1;
  LIndex := aStartAt;
  if (LIndex = -1) then
    LIndex := ParamCount;

  while (LIndex > 0) do
  begin
    LOption := BinaryParams[LIndex];

    try
      if (Length(LOption) < 2) then
        Continue;
      if (LOption[1] <> FOptionChar) then
        Continue;

      Delete(LOption, 1, 1);
      aIsLongOption := (Length(LOption) > 0) and (LOption[1] = FOptionChar);

      if aIsLongOption then
      begin
        Delete(LOption, 1, 1);
        LPosition := Pos('=', LOption);
        if (LPosition <> 0) then
          LOption := Copy(LOption, 1, Pred(LPosition))
      end;

      if (fIsOptionsCaseSensitive = False) then
        LOption := UpperCase(LOption);

      if (LOption = aFind) then
      begin
        Result := LIndex;
        Exit
      end;
    finally
      Dec(LIndex);
    end;
  end;
end;

function cApplication.OptionValuesGet(const aNameShort: Char; const aNameFull: String): TStringDynArray;
 var
  LCount: NativeInt;
begin
  SetLength(Result, ParamCount);
  LCount := 0;
  innerOptionFind(aNameShort, LCount, nil);
  innerOptionFind(aNameFull, LCount, nil);
  SetLength(Result, LCount);
  if (LCount = 0) then
    Exit;
  LCount := 0;
  innerOptionFind(aNameShort, LCount, @Result);
  innerOptionFind(aNameFull, LCount, @Result);
end;

procedure cApplication.LogCustom(const aMessage: String);
begin
  Log(etCustom, aMessage)
end;

procedure cApplication.LogCustomWithFormat(const aFormat: String; const aArgs: array of const);
begin
  LogWithFormat(etCustom, aFormat, aArgs)
end;

procedure cApplication.LogDebug(const aMessage: String);
begin
  Log(etDebug, aMessage)
end;

procedure cApplication.LogDebugWithFormat(const aFormat: String; const aArgs: array of const);
begin
  LogWithFormat(etDebug, aFormat, aArgs)
end;

procedure cApplication.LogError(const aMessage: String);
begin
  Log(etError, aMessage)
end;

procedure cApplication.LogErrorWithFormat(const aFormat: String; const aArgs: array of const);
begin
  LogWithFormat(etError, aFormat, aArgs)
end;

procedure cApplication.LogInfo(const aMessage: String);
begin
  Log(etInfo, aMessage)
end;

procedure cApplication.LogInfoWithFormat(const aFormat: String; const aArgs: array of const);
begin
  LogWithFormat(etInfo, aFormat, aArgs)
end;

procedure cApplication.LogWarning(const aMessage: String);
begin
  Log(etWarning, aMessage)
end;

procedure cApplication.LogWarningWithFormat(const aFormat: String; const aArgs: array of const);
begin
  LogWithFormat(etWarning, aFormat, aArgs)
end;

procedure cApplication.Run;
begin
  if (fTerminated = True) then
    Exit;
  try
    if (innerStart = False) then
      Exit;
    while (fTerminated = False) do
      try
        if (innerRun = False) then
          Terminate;
      except
        on LCurrentException: Exception do
          if innerStopOnException(LCurrentException) then
            Terminate;
      end;
  finally
    innerStop;
  end;
end;

procedure cApplication.Terminate;
begin
  TerminateByCode(ExitCode)
end;

procedure cApplication.TerminateByCode(const aExitCode: NativeInt);
begin
  fTerminated := True;
  ExitCode := aExitCode
end;

end.
