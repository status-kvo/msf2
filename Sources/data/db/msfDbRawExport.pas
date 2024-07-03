unit msfDbRawExport;

interface

uses
  SysUtils, DateUtils,
  msfWriters;

type
  cEventExport = class abstract
   public
    function WriterNew: cWriter; virtual; abstract;
   public
    procedure OnEvent(const aExportObject: Pointer); virtual; abstract;
   public
    class function DateTimeToUnix(const aValue: TDateTime): Int64;
   public
    class function PathTmp(const aPath: string): string;
   public
    class function GenerateFileName(const aPath, aTableName: String; const aBlockIndex: UInt32): String;
  end;

implementation

{ cEventExport }

class function cEventExport.DateTimeToUnix(const aValue: TDateTime): Int64;
begin
  Result := MilliSecondsBetween(UnixDateDelta, aValue);
  if (aValue < UnixDateDelta) then
     Result := -Result;
end;

class function cEventExport.GenerateFileName(const aPath, aTableName: String; const aBlockIndex: UInt32): String;
begin
  Result := IntToStr(DateTimeToUnix(Now));
//  Result := Result.PadLeft(20, '0');
  Result := aPath + Format('%s_%s_%d', [Result, aTableName, aBlockIndex]) + '.json';
end;

class function cEventExport.PathTmp(const aPath: string): string;
begin
  Result := IncludeTrailingPathDelimiter(aPath + 'tmp')
end;

end.
