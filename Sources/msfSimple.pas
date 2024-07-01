unit msfSimple;

{$INCLUDE msfBase.inc}

{$IFDEF SUPPORTS_SECTION_INTERFACE}
interface
{$ENDIF}

uses
  SysUtils,
  msfTypes, msfErrors;

type
  cSimple = class abstract(TObject)
   protected
    function innerVersionGet: rVersion; virtual; abstract;
   protected
    function innerClone: cSimple; virtual;
   public
    function Clone(const aIsRaiseNotSupportClone: Boolean = True): cSimple;
   public
    function IsSupportClone: Boolean; virtual;
   public
    property Version: rVersion read innerVersionGet;
  end;

type
  eNotSupportClone = class(Exception);

implementation

{ cSimple }

function cSimple.Clone(const aIsRaiseNotSupportClone: Boolean): cSimple;
begin
  if (IsSupportClone) then
  begin
    Result := innerClone;
    Exit
  end;

  if aIsRaiseNotSupportClone then
    raise eNotSupportClone.CreateFmt(rsNotSupportClone, [Self.ClassName])
  else
    Result := nil
end;

function cSimple.innerClone: cSimple;
begin
  raise eNotSupportClone.CreateFmt(rsNotSupportClone, [Self.ClassName])
end;

function cSimple.IsSupportClone: Boolean;
begin
  Result := True
end;

end.

