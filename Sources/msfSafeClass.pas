unit msfSafeClass;

{$INCLUDE msfBase.inc}

{$IFDEF SUPPORTS-SECTION-INTERFACE}
interface
{$ENDIF}

uses
  msfAtomicity, msfSimple, msfSafeBase;

type
  cSafeClass<kContent: cSimple> = class abstract(cSafe<kContent>);

type
  cSafeClassSealed<kContent: cSimple> = class sealed(cSafeClass<kContent>);

implementation

end.
