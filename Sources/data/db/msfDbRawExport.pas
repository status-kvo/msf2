unit msfDbRawExport;

interface

uses
  msfWriters;

type
  cEventExport = class abstract
   public
    function WriterNew: cWriter; virtual; abstract;
   public
    procedure OnEvent(const aExportObject: Pointer); virtual; abstract;
  end;

implementation

end.
