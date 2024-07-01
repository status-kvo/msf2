unit msfDbRawExportJson;

interface

uses
  Types, SysUtils, Classes, DateUtils,
  msfIOUtils,
  msfWriters, msfWritersJson,
  msfDbRawExport;

type
  cEventExportJson = class sealed(cEventExport)
   private
    var fPath: String;
   private
    var fTableName: String;
   private
    var fBlockIndex: UInt32;
   private
    var fCreateFileComplite: Boolean;
   public
    function WriterNew: cWriter; override;
   public
    procedure OnEvent(const aExportObject: Pointer); override;
   public
    constructor Create(const aPath, aTableName: string; const aCreateFileComplite: Boolean);
    destructor Destroy; override;
  end;

implementation

type
  cWriterJsonExport = class sealed(cWriterJson)
   private
    var fIdent: String;
   private
    var fCreateFileComplite: Boolean;
   public
    constructor Create(aSource: TStream; const aIsOwner: Boolean; const aIdent: String; aCreateFileComplite: Boolean);
    destructor Destroy; override;
  end;

{ cEventExportJson }

constructor cEventExportJson.Create(const aPath, aTableName: string; const aCreateFileComplite: Boolean);
begin
  inherited Create;
  fPath := aPath;
  fTableName := aTableName;
  fBlockIndex := 0;
  fCreateFileComplite := aCreateFileComplite
end;

destructor cEventExportJson.Destroy;
begin
  fPath := '';
  fTableName := '';
  inherited
end;

procedure cEventExportJson.OnEvent(const aExportObject: Pointer);
 var
  LJson: cWriterJsonExport absolute aExportObject;
begin
  LJson.CloseToRoot;
  LJson.WritePairString('message_id', LJson.fIdent);
end;

function cEventExportJson.WriterNew: cWriter;
 var
  LStream: TStream;
  LIdent: String;
begin
  LIdent := IntToStr(DateTimeToUnix(Now, False));
  LIdent := LIdent.PadLeft(20, '0');

  LIdent := Format('%s_%s_%d', [LIdent, fTableName, {$IFDEF FPC}InterlockedIncrement{$ELSE}AtomicIncrement{$ENDIF}(fBlockIndex)]);

  LStream := rFile.OpenWrite(fPath + LIdent + '.json', False);
  LStream.Size := 0;
  Result := cWriterJsonExport.Create(LStream, True, LIdent, fCreateFileComplite);
end;

{ cWriterJsonExport }

constructor cWriterJsonExport.Create(aSource: TStream; const aIsOwner: Boolean; const aIdent: String; aCreateFileComplite: Boolean);
begin
  inherited Create(aSource, aIsOwner);
  fIdent := aIdent;
  fCreateFileComplite := True
end;

destructor cWriterJsonExport.Destroy;
 var
  LFile: TFileStream;
  LPath: String;
begin
  LPath := '';
  if fCreateFileComplite then
    if (fSource is TFileStream) then
      LPath := TFileStream(fSource).FileName + '.completed';

  inherited;

  if (LPath = '') then
    Exit;

  LFile := nil;
  try
    LFile := TFileStream.Create(LPath, fmCreate);
  finally
    LFile.Free
  end;
end;

end.
