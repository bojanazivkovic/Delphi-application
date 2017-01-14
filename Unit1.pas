unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Unit2, ADODB, DB, Unit3;

type
  TForm1 = class(TForm)
    user: TEdit;
    pass: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    LoginBtn: TButton;
    CancelBtn: TButton;
    ADOConnection1: TADOConnection;
    ZaposleniDS: TDataSource;
    ZaposleniTbl: TADOTable;
    Q: TADOQuery;


    procedure CancelBtnClick(Sender: TObject);
    procedure LoginBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.CancelBtnClick(Sender: TObject);
begin
Form1.Close;
end;

procedure TForm1.LoginBtnClick(Sender: TObject);

var
  nema: boolean;

begin
  Q.SQL.Text:='select * from Zaposleni';
  Q.Open;
  nema:= false;

  while not Q.Eof do begin
    if (user.Text=Q.FieldByName('Username').AsString) and
       (pass.Text=Q.FieldByName('Password').AsString) then
    begin
      ModalResult := mrOK;
      nema:=false;
 Form2.ulogovani.caption:=Q.FieldByName('Zaposleni_Naziv').AsString;
//Form2.ulogovani.caption:=user.text;
Form1.Visible:=false;
Form2.ShowModal;
      break;
    end
    else
    begin
     nema:= true;
   end;
  Q.Next;
  end;

    
   if (nema=true) and Q.Eof then
   begin
      ShowMessage('Morate uneti validno korisnicko ime i lozinku!');
   end;
  Q.Close;



  // if (user.Text='Admin') and (pass.Text='admin') then
 // begin
  //Form1.Visible:=false;
 // Form3.ShowModal;
 // end;
    

  end;
end.
