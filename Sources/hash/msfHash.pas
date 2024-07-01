unit msfHash;

interface

type
  cHash = class abstract
   public
    procedure Update(const aText: String); virtual; abstract;
    procedure UpdateBuffer(const aData; aLength: NativeUInt); virtual; abstract;
   public
    function AsString: String; virtual; abstract;
  end;

implementation

end.
