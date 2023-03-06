unit uComum;

interface

uses System.SysUtils;

implementation


function RetornaData(XData: string): tdatetime;
var wret: tdatetime;
    wdia,wmes,wano: word;
begin
  try
    wano := strtoint(copy(XData,1,4));
    wmes := strtoint(copy(XData,6,2));
    wdia := strtoint(copy(XData,8,2));

    wret := EncodeDate(wano,wmes,wdia);

  except
    wret := 0;
  end;
  Result := wret;
end;

end.
