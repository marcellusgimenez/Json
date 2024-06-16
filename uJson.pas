unit uJson;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  System.Net.HttpClientComponent,
  System.JSON, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    btnOK: TButton;
    editCNPJ: TEdit;
    Memo1: TMemo;
    pnlTopo: TPanel;
    Label1: TLabel;
    edtRazao: TEdit;
    edtEndereco: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtNumero: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    edtUF: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edtAtividadePrincipal: TEdit;
    Label8: TLabel;
    edtInsc: TEdit;
    Label9: TLabel;
    Button1: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function lerJsonArmazenarString(URL: string):string;
var
  HTTPClient: TNETHTTPClient;
  jasonValue: TJsonValue;
begin
  httpClient := TNETHTTPClient.Create(nil);
  try
    try
      jasonValue  := TJSONObject.ParseJSONValue(HTTPClient.Get(URL).ContentAsString());
      if assigned(jasonValue) then  begin
        result:=jasonValue.ToString;
      end;
    except
      on e: exception do begin
        result := 'Erro ao ler JSON ' + e.Message;
      end;
    end;
  finally
    HTTPClient.Free;
  end;

end;

procedure TForm1.btnOKClick(Sender: TObject);
var
  vJson: string;
  oObejto, oObejtoEstab, oObejtoAtidadePrincipal, oObejtoCidade, oObejtoUF: TJSONObject;
  arraySocio, arrayInscricao: TJSONArray;
  I: Integer;
begin
  Memo1.Lines.Clear;
  //https://publica.cnpj.ws/cnpj/03361252000134;
  //CNPJ: 02033695000133 - Vedapack Embalagens Industriais …

  vJson := lerJsonArmazenarString('https://publica.cnpj.ws/cnpj/'+ editCNPJ.Text);
  // Memo1.Lines.Add(vJson);

  oObejto :=  TJSONObject.ParseJSONValue(vJson) as TJSONObject;
  edtRazao.Text := oObejto.GetValue('razao_social').Value;

  arraySocio := oObejto.GetValue<TJSONArray>('socios');
  //if arraySocio.Size > 0 then begin
    //edtInsc.Text := arraySocio .Get(0).GetValue<string>('nome');
  //end;
  memo1.Lines.Add('Socios: ');
  for I := 0 to arraySocio.Size -1 do begin
    memo1.Lines.Add(arraySocio.Get(i).GetValue<string>('nome'));
  end;

  oObejtoEstab := oObejto.GetValue<TJSONObject>('estabelecimento');
  //Memo1.Lines.Add(JSONObjectEstab.ToString);
  edtEndereco.Text := oObejtoEstab.GetValue('tipo_logradouro').Value+' '+oObejtoEstab.GetValue('logradouro').Value;
  edtNumero.Text :=  oObejtoEstab.GetValue('numero').Value;
  edtBairro.Text :=  oObejtoEstab.GetValue('bairro').Value;

  oObejtoAtidadePrincipal := oObejtoEstab.GetValue<TJSONObject>('atividade_principal');
  edtAtividadePrincipal.Text := oObejtoAtidadePrincipal.GetValue('descricao').Value;

  oObejtoCidade := oObejtoEstab.GetValue<TJSONObject>('cidade');
  edtCidade.Text :=  oObejtoCidade.GetValue('nome').Value;

  oObejtoUF := oObejtoEstab.GetValue<TJSONObject>('estado');
  edtuf.Text :=  oObejtoUF.GetValue('sigla').Value;

  arrayInscricao := oObejtoEstab.GetValue<TJSONArray>('inscricoes_estaduais');
  if arrayInscricao.Size > 0 then begin
    edtInsc.Text := arrayInscricao.Get(0).GetValue<string>('inscricao_estadual');
  end;

  memo1.Lines.Add('Inscrições estaduais: ');
  for I := 0 to arrayInscricao.Size -1 do begin
    memo1.Lines.Add(arrayInscricao.Get(i).GetValue<string>('inscricao_estadual'));
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  vJson: string;
  oObejto: TJSONObject;
  myarr: TJSONArray;
  I: Integer;
begin
  //vJson := lerJsonArmazenarString('https://publica.cnpj.ws/cnpj/'+ editCNPJ.Text);

  //oObejto :=  TJSONObject.ParseJSONValue(vJson) as TJSONObject;
  //myObj := myarr.Items[0] as TJSONObject;
 // memo1.Lines.Add(oObejto.Get(0).JsonValue );


end;

end.
