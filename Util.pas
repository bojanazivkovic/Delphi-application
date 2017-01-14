unit Util;

interface
uses contnrs,Dialogs,ExtCtrls;

type

TAST=array of String;
TAOB=array of TObject;
TEffectDirection=(edNormal,edReversed);
TeType=(etNormal,etZigZag,etRepeat);

    TIntfList=class(TInterfacedObject)
    protected
        list:TObjectList;
    private
        function GetItems(Index: Integer): TObject;
        procedure SetItems(Index: Integer; const Value: TObject);
    public
        constructor Create; overload;
        constructor Create(OwnsObjects:boolean); overload;
        destructor Destroy; override;
        function Add(AObject: TObject): Integer; virtual;
        function Remove(AObject: TObject): Integer;
        function Count:integer;
        property Items[Index: Integer]: TObject read GetItems write SetItems; default;
    end;




TSize = packed record
   width:integer;
   height:integer;
   valid:boolean;
end;

TPosition = packed record
   top:integer;
   left:integer;
   valid:boolean;
end;

function position(Left,Top:integer):TPosition;
function size(width,height:integer):TSize;
function min(val1,val2:integer):integer;
function max(val1,val2:integer):integer; overload;
function max(val1,val2,val3:integer):integer; overload;
function BoundValue(val,min,max:integer):integer;
function sgn(val:integer):integer;
procedure XChange(var val1,val2:integer); overload;
procedure XChange(cond:boolean;var val1,val2:integer); overload;
function PosExR(Substr,Str:String;offset:integer):integer;
function XPos(Substr,Str:String;offset:integer=1):integer;
function XPosR(Substr,Str:String;offset:integer=-1):integer;
function XDateToStr(datum:tdatetime;format:string='DMG'):String;
//function unpackKeyVal(st:String):IXTable;
//function packKeyVal(tbl:IXTable):String;
function replace(var where:String; const what,new:String;sensitive:boolean=false):String;
function to2dec(val:integer):String;
function split(var st:string;del:string=','):TAST;
function webPack(const st:UTF8String):UTF8String;
function webUnpack(const st:UTF8String):UTF8String;
function IsoDateTime(t:tdatetime):String; overload;
function IsoDateTime(st:string):tdatetime; overload;
function numberAlign(num:int64;decimals:word=10):string;
function addBackslash(folder:string):string;
function substring(st:string;leftborder,rightborder:string):string;
function getComputerName: String;
function getDouble(st:String):Double;
function getAppDir:String;
procedure printImage(Image:TImage);

const
    NL=#13#10;
    MAXINT=2147483647;

implementation

uses StrUtils, DateUtils, SysUtils,windows, Classes,Forms,Printers,Controls;


procedure printImage(Image:TImage);
var
  ScaleX, ScaleY: Integer;
  RR: TRect;
  Form:TForm;
  WC:TWinControl;
begin
  WC:=Image.Parent;
  if WC=nil then exit;
  while WC.Parent<>nil do WC:=WC.Parent;
  form:=TForm(WC);

  with Printer,Form do
  begin
    BeginDoc;
    try
      ScaleX := GetDeviceCaps(Handle, logPixelsX) div PixelsPerInch;
      ScaleY := GetDeviceCaps(Handle, logPixelsY) div PixelsPerInch;
      RR := Rect(0, 0, Image.picture.Width * scaleX, Image.Picture.Height * ScaleY);
      Canvas.StretchDraw(RR, Image.Picture.Graphic);
    finally
      EndDoc;
    end;
  end;

end;



function getAppDir:String;
begin
   result:=addBackslash(ExtractFilePath(application.ExeName));
end;


function getDouble(st:String):Double;
var
   ch:char;
   left,right:string;
   p1,p2,p:integer;
begin
   ch:=DecimalSeparator;
   p1:=XPosR(',',st);
   p2:=XPosR('.',st);
   p:=max(p1,p2);
   if p=0 then begin
      result:=StrToFloatDef('0'+st,0);
      exit;
   end;
   left:=copy(st,1,p-1);
   right:=copy(st,p,length(st)-p+1);
   left:=StringReplace(left,',','',[rfReplaceAll]);
   left:=StringReplace(left,'.','',[rfReplaceAll]);
   right:=StringReplace(right,',','',[rfReplaceAll]);
   right:=StringReplace(right,'.','',[rfReplaceAll]);
   result:=StrToFloatDef(left+ch+right,0);
end;


function getComputerName: String;
var
   st:string;
   size:cardinal;
begin
  size:=30;
  st:=StringOfChar(' ',size);
  windows.GetComputerName(PAnsiChar(st),size);
  result:=copy(st,1,size);
end;


function substring(st:string;leftborder,rightborder:string):string;
var
   p,e,lp:integer;
begin
   lp:=length(leftborder);
   p:=Pos(leftborder,st);
   e:=posEx(rightBorder,st,p+lp);
   if e=0 then e:=length(st)+1;
   if (p>0) and (e>0)
     then result:=copy(st,p+lp,e-p-lp)
     else result:='';

end;


function addBackslash(folder:string):string;
begin
   if (length(folder)=0) then begin
      result:='\';
      exit;
   end;

   if copy(folder,length(folder),1)<>'\'
      then result:=folder+'\'
      else result:=folder;
end;


function numberAlign(num:int64;decimals:word=10):string;
var
   st:string;
begin
   st:=inttostr(num);
   result:=StringOfChar('0',10-length(st))+st;
end;

function IsoDateTime(t:tdatetime):String;
begin
   Result:=inttostr(yearOf(t))+'-'+to2dec(monthOf(t))+'-'+to2dec(dayOf(t))+'T'+
           to2dec(HourOf(t))+':'+to2dec(MinuteOf(t))+':'+to2dec(SecondOf(t));
end;

function IsoDateTime(st:string):tdatetime;
begin
//   Result:=StrToDateTime(st);
   result:=EncodeDateTime(
      strtoint(copy(st,1,4)),
      strtoint(copy(st,6,2)),
      strtoint(copy(st,9,2)),
      strtoint(copy(st,12,2)),
      strtoint(copy(st,15,2)),
      strtoint(copy(st,18,2)),
      0
   )

end;



function webPack(const st:UTF8String):UTF8String;
begin
   result:=st;
   result:=stringReplace(result,'%','%25',[rfReplaceAll]); //this must be the first
   result:=stringReplace(result,' ','%20',[rfReplaceAll]);
end;

function webUnpack(const st:UTF8String):UTF8String;
begin
   result:=st;
   result:=stringReplace(result,'%20',' ',[rfReplaceAll]);
   result:=stringReplace(result,'%25','%',[rfReplaceAll]); //this must be the last
end;




function split(var st:string;del:string=','):TAST;
var
   p,e,cnt:integer;
begin
   p:=0;
   cnt:=0;
   repeat
      e:=posex(del,st,p+1);
      if e=0 then e:=length(st)+1;
      if e>0 then begin
         if cnt>=length(result) then setLength(result,cnt+10);
         result[cnt]:=copy(st,p+1,e-p-1);
         p:=e;
         inc(cnt);
      end;
   until p=length(st)+1;
   setlength(result,cnt);
end;


function to2dec(val:integer):String;
begin
   result:=inttostr(val);
   if val<10 then result:='0'+result;
end;

function replace(var where:String; const what,new:String;sensitive:boolean=false):String;
var
   rf:TReplaceFlags;
begin
   if sensitive then rf:=[rfReplaceAll] else rf:= [rfReplaceAll, rfIgnoreCase];
   where:=StringReplace(where,what,new,rf);
   result:=where;
end;


{function packKeyVal(tbl:IXTable):String;
var
   i:integer;
begin
   for i:=0 to tbl.RowCount-1 do begin
       Result:=Result+tbl.get(i,0)+'='+tbl.get(i,1)+';'
   end;
end;

function unpackKeyVal(st:String):IXTable;
var
   tbl:IXTable;
   s,m,e,row:integer;
begin
   tbl:=XTable.Create(2);
   s:=1;row:=0;
   repeat
      m:=XPos('=',st,s);
      e:=XPos(';',st,m);
      if e=0 then e:=10000;
      if (m>0) then begin
          tbl.put(row,0,copy(st,s,m-s));
          tbl.put(row,1,copy(st,m+1,e-m-1));
          inc(row);
          //MessageDlg(copy(st,s,m-s)+'#'+copy(st,m+1,e-m-1),mtInformation,[mbOK],0)
      end;
      s:=e+1;
   until (e=10000) or (m=0);
   result:=tbl;
end;}


function XPosR(Substr,Str:String;offset:integer=-1):integer;
var
   p,i,lsbs:integer;
begin
    p:=0; result:=0;
    lsbs:=length(substr);
    if lsbs=0 then exit;
    if (offset<=0) or (offset>length(Str)) then offset:=length(Str);
    for i:=offset downto 1 do begin
        if str[i]=substr[lsbs-p] then inc(p) else p:=0;
        if p=lsbs then begin result:=i; exit; end;
    end;
end;

function PosExR(Substr,Str:String;offset:integer):integer;
begin
    Result:=XPosR(Substr,Str,offset);
end;

function XPos(Substr,Str:String;offset:integer=1):integer;
var
   p,i,lsbs:integer;
begin
    p:=0; result:=0;
    lsbs:=length(substr);
    if (lsbs=0) or (offset>length(Str)) then exit;
    if (offset<=0) then offset:=1;
    for i:=offset to length(str) do begin
        if str[i]=substr[p+1] then inc(p) else p:=0;
        if p=lsbs then begin result:=i-lsbs+1; exit; end;
    end;
end;


procedure XChange(var val1,val2:integer);
var
   r:integer;
begin
   r:=val1; val1:=val2; val2:=r;
end;

procedure XChange(cond:boolean;var val1,val2:integer);
begin
    if cond then XChange(val1,val2);
end;

function size(width,height:integer):TSize;
begin
   Result.width:=width;
   Result.height:=height;
   Result.valid:=true;
end;

function position(Left,Top:integer):TPosition;
begin
   Result.left:=left;
   Result.top:=top;
   Result.valid:=true;
end;


function min(val1,val2:integer):integer;
begin
    if val1<val2 then result:=val1 else result:=val2;
end;

function max(val1,val2:integer):integer;
begin
    if val1>val2 then result:=val1 else result:=val2;
end;

function max(val1,val2,val3:integer):integer;
begin
    result:=max(val1,max(val2,val3));
end;

function BoundValue(val,min,max:integer):integer;
begin
    if val<min then val:=min;
    if val>max then val:=max;
    result:=val;
end;

function sgn(val:integer):integer;
begin
   Result:=0;
   if val<0 then result:=-1;
   if val>0 then result:=+1;
end;

{ TIntfList }

function TIntfList.Add(AObject: TObject): Integer;
begin
    result:=list.Add(AObject);
end;

function TIntfList.Count: integer;
begin
    result:=list.Count;
end;

constructor TIntfList.Create;
begin
   list:=TObjectList.Create(false);
end;

constructor TIntfList.Create(OwnsObjects: boolean);
begin
   list:=TObjectList.Create(true);
end;

destructor TIntfList.Destroy;
begin
   list.Free;
end;

function TIntfList.GetItems(Index: Integer): TObject;
begin
    Result:=list[index];
end;

function TIntfList.Remove(AObject: TObject): Integer;
begin
    Result:=list.Remove(AObject);
end;

procedure TIntfList.SetItems(Index: Integer; const Value: TObject);
begin
    list[index]:=value;
end;

function mesec3(mesec:byte):string;
begin
   case mesec of
      1:result:='jan';
      2:result:='feb';
      3:result:='mar';
      4:result:='apr';
      5:result:='maj';
      6:result:='jun';
      7:result:='jul';
      8:result:='avg';
      9:result:='sep';
     10:result:='okt';
     11:result:='nov';
     12:result:='dec';
     else result:='???';
   end;


end;


function XDateToStr(datum:tdatetime;format:string='DMG'):String;
begin
    Result:='Nepoznat format';
    if format='DMG' then
       Result:=inttostr(DayOF(datum))+'.'+mesec3(MonthOF(datum))+' '+inttostr(YearOF(datum))+'.'
    else if format='MG' then
       Result:=mesec3(MonthOF(datum))+' '+inttostr(YearOF(datum))+'.'
    else if format='G' then Result:=inttostr(YearOF(datum))+'.';
end;




end.
