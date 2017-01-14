unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGrids, ComCtrls, StdCtrls, Mask, DBCtrls, jpeg,
  ExtCtrls, DateUtils, dblookup;

type
  TForm3 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ADOConnection1: TADOConnection;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    FilmoviTbl: TADOTable;
    ClanoviTbl: TADOTable;
    IznajmljivanjaTbl: TADOTable;
    FilmoviDS: TDataSource;
    ClanoviDS: TDataSource;
    IznajmljivanjaDS: TDataSource;
    Label1: TLabel;
    Button1: TButton;
    ZanrTbl: TADOTable;
    ZanrDS: TDataSource;
    VrstaTbl: TADOTable;
    VrstaDS: TDataSource;
    ZaposleniDS: TDataSource;
    ZaposleniTbl: TADOTable;
    Label2: TLabel;
    Label4: TLabel;
    DBEdit2: TDBEdit;
    DBEdit4: TDBEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label5: TLabel;
    Label7: TLabel;
    Button5: TButton;
    Button6: TButton;
    Image1: TImage;
    FilmoviTblFilm_ID: TAutoIncField;
    FilmoviTblFilm_Ime: TWideStringField;
    FilmoviTblZanr_ID: TIntegerField;
    FilmoviTblIznaj_ID: TIntegerField;
    FilmoviTblTrajanje: TIntegerField;
    FilmoviTblClan_ID: TIntegerField;
    FilmoviTblVrsta_ID: TIntegerField;
    FilmoviTblZanr: TStringField;
    FilmoviTblVrsta: TStringField;
    DBEdit1: TDBEdit;
    DBGrid3: TDBGrid;
    IznajmljivanjaTblIznaj_ID: TAutoIncField;
    IznajmljivanjaTblDatum_iznaj: TDateTimeField;
    IznajmljivanjaTblDatum_vracanja: TDateTimeField;
    IznajmljivanjaTblClan_ID: TIntegerField;
    IznajmljivanjaTblClan_Naziv: TWideStringField;
    IznajmljivanjaTblVrsta_ID: TIntegerField;
    IznajmljivanjaTblFilm_ID: TIntegerField;
    IznajmljivanjaTblFilm_Naziv: TWideStringField;
    IznajmljivanjaTblUkupno: TBCDField;
    DBLookupComboBox2: TDBLookupComboBox;
    DBLookupComboBox1: TDBLookupComboBox;
    TabSheet6: TTabSheet;
    IznajmljivanjaTblCena_dan: TIntegerField;
    Label3: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    DBEdit3: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    ZaposleniTblZaposleni_ID: TAutoIncField;
    ZaposleniTblZaposleni_Naziv: TWideStringField;
    ZaposleniTblUsername: TWideStringField;
    ZaposleniTblPassword: TWideStringField;
    Label12: TLabel;
    ulogovani: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure IznajmljivanjaTblCalcFields(DataSet: TDataSet);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);

   private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
  FilmoviTbl.Append;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  ClanoviTbl.Append;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
  ClanoviTbl.Post;
end;

procedure TForm3.Button4Click(Sender: TObject);
begin
  ClanoviTbl.Cancel;
end;

procedure TForm3.Button5Click(Sender: TObject);
begin
  IznajmljivanjaTbl.Append;
  IznajmljivanjaTbl.FieldByName('Datum_iznaj').asDateTime:=date;
end;

procedure TForm3.Button6Click(Sender: TObject);
begin
  IznajmljivanjaTbl.Post;

end;


procedure TForm3.Button7Click(Sender: TObject);
begin
ZaposleniTbl.Append;
end;

procedure TForm3.Button8Click(Sender: TObject);
begin
ZaposleniTbl.Post;
end;

procedure TForm3.Button9Click(Sender: TObject);
begin
ZaposleniTbl.Cancel;

end;

procedure TForm3.FormCreate(Sender: TObject);

begin
  DateSeparator:='.';
  ShortDateFormat:='dd.mm.yyyy';
  LongDateFormat:=ShortDateFormat;
end;


procedure TForm3.IznajmljivanjaTblCalcFields(DataSet: TDataSet);
begin
    IznajmljivanjaTbl.FieldByName('Ukupno').AsCurrency :=
   (IznajmljivanjaTbl.FieldByName('Cena_dan').AsInteger*
   (IznajmljivanjaTbl.FieldByName('Datum_vracanja').AsDateTime -
    IznajmljivanjaTbl.FieldByName('Datum_iznaj').AsDateTime));
end;

end.


