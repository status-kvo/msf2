unit msfResourcesUtils;

{$IFDEF FPC}
  {$mode ObjFPC}
  {$H+}
{$ENDIF}

interface

uses
  Classes;

type
  rResources = {$IFDEF FPC}class{$ELSE}record{$ENDIF}
   public
    class function ExtractDirectories(const aName: String): String; static;
    class function ExtractSqls(const aName: String): String; static;
    class function ExtractText(const aName, aSection: String): String; static;
  end;

implementation

{ rResources }

class function rResources.ExtractDirectories(const aName: String): String;
begin
  Result := ExtractText(aName, 'Directories')
end;

class function rResources.ExtractSqls(const aName: String): String;
begin
  Result := ExtractText(aName, 'SQLs')
end;

class function rResources.ExtractText(const aName, aSection: String): String;
var
  LResourceStream: TResourceStream;
  LStringStream: TStringStream;
begin
  LResourceStream := nil;
  LStringStream := nil;
  try
    LResourceStream := TResourceStream.Create(HInstance, aName, PChar(String(aSection)));
    LStringStream := TStringStream.Create;
    LStringStream.LoadFromStream(LResourceStream);
    Result := LStringStream.DataString;
  finally
    LStringStream.Free;
    LResourceStream.Free
  end;
end;

end.
