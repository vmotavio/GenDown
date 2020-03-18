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
    procedure Button1Click(Sender: TObject);
    procedure IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure Button2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);

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
  if ((Edit1.Text = '') or (Edit1.Text = 'Digite a URL do arquivo')) then
  begin
     ShowMessage('Digite uma URL'); //Mensagem de Erro caso não coloquem uma URL no campo
  end
  else begin
    SaveDialog1.Execute(); // Abre uma tela para o usuário selecionar o local e nome do arquivo para o Download
    DownloadThread.Create(Edit1.Text, SaveDialog1.FileName);  //Cria a Thread Download passando a URL e o Endereço do Arquivo + Nome do Arquivo escolhido pelo usuário
  end;
end;
procedure TForm1.Button2Click(Sender: TObject);
begin
  idHTTP1.Disconnect;  //Para o Download caso o usuário clique no botão de Parar o Download
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  form2.Show; //Exibe o form2 que contém os dados do banco
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Label2.Show; //Apresenta a porcentagem do Download para o usuário
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if idHTTP1.Connected then // Se estiver fazendo o Download e Clicarem no botão de fechar janela.
  begin
    if MessageDlg('Existe um Download em andamento.  Deseja sair?', //Pergunta se deseja sair
      mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then
      begin  // Se o retorno for Yes
        idHTTP1.Disconnect; //Encerra o Download
        Close; //Fecha a aplicação
      end;
  end;
  end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  try
    FDConnection1.Params.Values['Database'] := GetCurrentDir +'\..\..\banco.db'; // Captura a pasta do executável para criar o caminho do banco de dados
    FDConnection1.Connected:=True; //Faz a conexão com o banco
    FDTable1.Active:=True; //Ativa a tabela
  except
    ShowMessage('Erro na comunicação com o banco de dados!'); //Mensagem de Erro de conexão com o banco
  end;
end;

procedure TForm1.IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
  var x : Double;
begin
  ProgressBar1.Position := AWorkCount; // Captura o progresso do Download e repassa para o ProgressBar1
  x:=AWorkCount*100/ProgressBar1.Max; // Calcula a porcentagem do Download
  Label2.Caption:=FloatToStrF(x,ffNumber,3,0)+' %'; //Formata o Double para imprimir apenas casas depois da vírgula
end;

procedure TForm1.IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  ProgressBar1.Position := 0; //Inicializa o ProgressBar1 com 0
  ProgressBar1.Max := AWorkCountMax; //Define o valor máximo de acordo com o tamanho do arquivo
  Label1.caption := 'Download em andamento...'; //Exibe Download em andamento no Label1
  FDConnection1.ExecSQL('INSERT INTO LOGDOWNLOAD (URL,DATAINICIO) VALUES ("'+Edit1.Text+'",datetime("now"));');//Faz a inserção no banco de dados com o início do Download
end;

procedure TForm1.IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  ProgressBar1.Position := ProgressBar1.Max; //Preenche a barra até o final
  Label1.Caption := 'Download Encerrado!'; //Informa que foi encerrado o Download
  try
    FDConnection1.ExecSQL('UPDATE LOGDOWNLOAD SET DATAFIM = datetime("now") WHERE CODIGO = (SELECT MAX(CODIGO) FROM LOGDOWNLOAD)');//Atualiza a última linha da tabela com a data hora fim do Download
  except
    ShowMessage('Erro na inserção de dados no banco!'); //Mensagem de Erro no UPDATE
  end;
end;

{ DownloadThread }

constructor DownloadThread.Create (URL, fileName : string);
begin
  inherited Create(false); //Não herdar a função Create
  self.URL := URL; //Definindo a variável URL da Thread
  self.fileName := fileName; //Definindo a variável fileName da Thread
end;

procedure DownloadThread.Execute;
var
  downFile: TFileStream;

begin
  downFile := TFileStream.Create(self.fileName, fmCreate); //Variável recebe o arquivo criado de acordo como o usuário desejou
  try
    Form1.IdHTTP1.Get(self.URL, downFile); //Faz efetivamente o Download do arquivo
   except
    ShowMessage('Erro no Download do Arquivo!'); //Mensagem de Erro no Download do Arquivo
   end;
   downFile.Free; //Libera a memória da variável
end;

end.
