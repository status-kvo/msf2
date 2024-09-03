unit msfSingleInstance;

interface

type
  cSingleInstance = class abstract
   protected
    function innerIsCheck: Boolean; virtual; abstract;
   public
    property IsCheck: Boolean read innerIsCheck;
  end;

type
  tSingleInstanceClass = class of cSingleInstance;

var
  GSingleInstanceClass: tSingleInstanceClass = nil;

implementation

end.
