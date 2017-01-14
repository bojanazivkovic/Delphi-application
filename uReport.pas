unit uReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frxClass, frxDBSet,DB, frxDesgn, frxExportPDF, frxExportImage,
  frxExportXLS, frxExportXML, frxExportHTML, frxExportTXT;

type
  TReport = class(TForm)
    T1: TfrxDBDataset;
    T2: TfrxDBDataset;
    frxDesigner1: TfrxDesigner;
    T3: TfrxDBDataset;
    Engine: TfrxReport;
    frxTXTExport1: TfrxTXTExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxXMLExport1: TfrxXMLExport;
    frxXLSExport1: TfrxXLSExport;
    frxBMPExport1: TfrxBMPExport;
    frxJPEGExport1: TfrxJPEGExport;
    frxTIFFExport1: TfrxTIFFExport;
    frxPDFExport1: TfrxPDFExport;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report: TReport;

function Print(name:String;t1:TDataSet;t2:TDataSet=nil;t3:TDataSet=nil):boolean;
function Design(name:String;t1:TDataSet;t2:TDataSet=nil;t3:TDataSet=nil):boolean;

implementation

{$R *.dfm}
uses util;
var
   b1,b2,b3:TBookmark;

function SetDefaults:boolean;
var
   expPath:String;
begin
    expPath:=addBackSlash(getAppDir)+'exports';
    report.frxTXTExport1.DefaultPath:=expPath;
    report.frxHTMLExport1.DefaultPath:=expPath;
    report.frxXLSExport1.DefaultPath:=expPath;
    report.frxXLSExport1.OpenExcelAfterExport:=true;
    report.frxXLSExport1.MergeCells:=false;
    report.frxXMLExport1.DefaultPath:=expPath;
    report.frxBMPExport1.DefaultPath:=expPath;
    report.frxJPEGExport1.DefaultPath:=expPath;
    report.frxTIFFExport1.DefaultPath:=expPath;
    report.frxPDFExport1.DefaultPath:=expPath;
    Result:=true;
end;



function ConnectData(t1:TDataSet;t2:TDataSet=nil;t3:TDataSet=nil):boolean;
begin
   report.Engine.DataSets.Clear;

   report.T1.Enabled:=assigned(t1);
   if assigned(t1)
      then begin
         report.t1.DataSet:=t1;
         b1:=t1.GetBookmark;
         report.t1.UserName:=t1.Name;
         report.Engine.DataSets.add(report.T1);
      end;
   report.T2.Enabled:=assigned(t2);
   if assigned(t2)
      then begin
         report.t2.DataSet:=t2;
         b2:=t2.GetBookmark;
         report.t2.UserName:=t2.Name;
         report.Engine.DataSets.add(report.T2);
      end;
   report.T3.Enabled:=assigned(t3);
   if assigned(t3)
      then begin
         report.t3.DataSet:=t3;
         b3:=t3.GetBookmark;
         report.t3.UserName:=t3.Name;
         report.Engine.DataSets.add(report.T3);
      end;
      Result:=true;
end;
function LoadReport(name:String):boolean;
var
   reportFileName:String;
begin
   SetDefaults;
   reportFileName:=addBackslash(util.getAppDir)+'reports\'+name+'.fr3';
   Result:=report.Engine.LoadFromFile(reportFileName);
   
   report.Engine.ReportOptions.Name:=name;
   report.Engine.FileName:=reportFileName;

end;

function Print(name:String;t1:TDataSet;t2:TDataSet=nil;t3:TDataSet=nil):boolean;
begin
   ConnectData(t1,t2,t3);
   if LoadReport(name)
      then report.Engine.ShowReport()
      else report.Engine.DesignReport;

   if assigned(t1) then t1.GotoBookmark(b1);
   if assigned(t2) then t2.GotoBookmark(b2);
   if assigned(t3) then t3.GotoBookmark(b3);

   Result:=true;
end;

function Design(name:String;t1:TDataSet;t2:TDataSet=nil;t3:TDataSet=nil):boolean;
begin
   ConnectData(t1,t2,t3);
   LoadReport(name);
   report.Engine.DesignReport;
   if assigned(t1) then t1.GotoBookmark(b1);
   if assigned(t2) then t2.GotoBookmark(b2);
   if assigned(t3) then t3.GotoBookmark(b3);
   Result:=True;
end;
end.
