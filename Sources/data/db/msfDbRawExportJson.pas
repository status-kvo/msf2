unit msfDbRawExportJson;

interface

uses
  Types, SysUtils, Classes,
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
   private
    var fIsExportByTemp: Boolean;
   public
    function WriterNew: cWriter; override;
   public
    procedure OnEvent(const aExportObject: Pointer); override;
   public
    constructor Create(const aPath, aTableName: string; const aIsCreateFileComplite, aIsExportByTemp: Boolean);
    destructor Destroy; override;
  end;

implementation

type
  cWriterJsonExport = class sealed(cWriterJson)
   private
    var fIdent: String;
   private
    var fMovePath: String;
   private
    var fCreateFileComplite: Boolean;
   public
    constructor Create(aSource: TStream; const aIsOwner: Boolean; const aIdent, aMovePath: String; aIsCreateFileComplite: Boolean);
    destructor Destroy; override;
  end;

{ cEventExportJson }

constructor cEventExportJson.Create(const aPath, aTableName: string; const aIsCreateFileComplite, aIsExportByTemp: Boolean);
begin
  inherited Create;
  fPath := aPath;
  fTableName := aTableName;
  fBlockIndex := 0;
  fCreateFileComplite := aIsCreateFileComplite;
  fIsExportByTemp := aIsExportByTemp;
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
  LBlockIndex: UInt32;
  LFilePath, LPath: String;
begin
  LBlockIndex := {$IFDEF FPC}InterlockedIncrement{$ELSE}AtomicIncrement{$ENDIF}(fBlockIndex);

  LPath := '';
  if fIsExportByTemp then
  begin
    LFilePath := PathTmp(fPath);
    LPath := fPath
  end
  else
    LFilePath := fPath;

  LFilePath := GenerateFileName(LFilePath, fTableName, LBlockIndex);
  LStream := rFile.OpenWrite(LFilePath, False);
  LStream.Size := 0;

  Result := cWriterJsonExport.Create(LStream, True, LFilePath, LPath, fCreateFileComplite);
end;

{ cWriterJsonExport }

constructor cWriterJsonExport.Create(aSource: TStream; const aIsOwner: Boolean; const aIdent, aMovePath: String; aIsCreateFileComplite: Boolean);
begin
  inherited Create(aSource, aIsOwner);
  fIdent := aIdent;
  fMovePath := aMovePath;
  fCreateFileComplite := aIsCreateFileComplite
end;

destructor cWriterJsonExport.Destroy;
 var
  LFile: TFileStream;
  LPath, LPathTemp: String;
  LIsExportByTemp: Boolean;
begin
  LPath := '';
  LPathTemp := '';

  if fCreateFileComplite then
    if (fSource is TFileStream) then
      LPath := TFileStream(fSource).FileName + '.completed';

  if (fMovePath > '') then
    if (fSource is TFileStream) then
      LPathTemp := TFileStream(fSource).FileName;

  inherited;

  if (fMovePath > '') then
    if (LPathTemp > '') then
      if (rFile.Move(LPathTemp, fMovePath, True) = False) then
        raise Exception.Create('Error file tmp to export path');

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
