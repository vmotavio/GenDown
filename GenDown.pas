unit GenDown;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.DBCtrls, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, Unit2,
  IdAuthentication;

type
  TForm1 = class(TForm)
    IdHTTP1: TIdHTTP;
    Edit1: TEdit;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Label2: TLabel;
    SaveDialog1: TSaveDialog;
    DataSource1: TDataSource;
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    Button4: TButton;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure Button2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button4Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

  DownloadThread = class (TThread)
  private
  URL, fileName : String;
  public constructor Create(URL, fileName : String);
    procedure Execute; override;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  SaveDialog1.Execute();
  DownloadThread.Create(Edit1.Text, SaveDialog1.FileName);
end;
procedure TForm1.Button2Click(Sender: TObject);
begin
  idHTTP1.Disconnect;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  form2.Show;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Label2.Show;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Label2.Hide;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if idHTTP1.Connected then
  begin
    if MessageDlg('Existe um Download em andamento.  Deseja sair?',
      mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then
      begin
        idHTTP1.Disconnect;
        Close;
      end;
  end;
  end;

procedure TForm1.IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
  var x : Double;
begin
  ProgressBar1.Position := AWorkCount;
  x:=AWorkCount*100/ProgressBar1.Max;
  Label2.Caption:=FloatToStrF(x,ffNumber,3,0)+' %';
end;

procedure TForm1.IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  ProgressBar1.Position := 0;
  ProgressBar1.Max := AWorkCountMax;
  Label1.caption := 'Download em andamento...';
  FDConnection1.ExecSQL('INSERT INTO LOGDOWNLOAD (URL,DATAINICIO) VALUES ("'+Edit1.Text+'",datetime("now"));');
end;

procedure TForm1.IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  ProgressBar1.Position := ProgressBar1.Max;
  Label1.Caption := 'Download Concluído!';
end;

{ DownloadThread }

constructor DownloadThread.Create (URL, fileName : string);
begin
  inherited Create(false);
  self.URL := URL;
  self.fileName := fileName;
end;

procedure DownloadThread.Execute;
var
  downFile: TFileStream;

begin
  try
    downFile := TFileStream.Create(self.fileName, fmCreate);
  finally

  end;
  try
    Form1.IdHTTP1.Get(self.URL, downFile);
  finally
    downFile.Free;
  end;
end;

end.
