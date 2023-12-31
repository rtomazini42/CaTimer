unit Contador;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Media;

type
  TContagem = class(TForm)
    Background: TRectangle;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    SpeedButton2: TSpeedButton;
    ImgBtn: TImage;
    Image3: TImage;
    Faltando: TRectangle;
    Carregado: TRectangle;
    Label2: TLabel;
    Timer1: TTimer;
    SpeedButton1: TSpeedButton;
    LabelTimerSegundo: TLabel;
    LabelTimerMinuto: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Image1: TImage;
    SpeedButton3: TSpeedButton;
    Image2: TImage;

    procedure SpeedButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure barraTempo();
    procedure FormShow(Sender: TObject);
    procedure PlayMp3();
    procedure FormResize(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);

  private
    { Private declarations }
  public
    var
    TempoInicial: Integer;  // novo campo para armazenar o tempo inicial em segundos
    TempoRestante: Integer; // novo campo para armazenar o tempo restante em segundos
    Progresso: Single;
    Gato : String;
    MP3 : String;
    Tipo : Integer;
    Som : boolean;
    ativado : boolean;
    TempoCiclo: Integer;


  end;

var
  Contagem: TContagem;

implementation

{$R *.fmx}

procedure TContagem.PlayMp3;
var
  MediaPlayer: TMediaPlayer;
begin
  MediaPlayer := TMediaPlayer.Create(nil);

    MediaPlayer.FileName := '..\..\..\Assets\Sounds\' + MP3 + '.mp3';
    MediaPlayer.Play;
    Sleep(3000);

    MediaPlayer.Free;
end;


procedure TContagem.barraTempo;
var
  Progresso: Single;
begin
  Progresso := 1 - (TempoRestante / TempoInicial);
  Carregado.Width := Round(Faltando.Width * Progresso);
end;

procedure TContagem.FormCreate(Sender: TObject);
begin
  TempoRestante := 5000;
end;

procedure TContagem.FormResize(Sender: TObject);
begin
      barraTempo;
end;

procedure TContagem.FormShow(Sender: TObject);
begin
       barraTempo();
       Image3.Bitmap.LoadFromFile('..\..\..\Assets\Bichos\'+ Gato + '.png');
       TempoRestante := TempoRestante - 5000 ;

end;

procedure TContagem.Image1Click(Sender: TObject);
begin
  Self.Destroy;
end;

procedure TContagem.SpeedButton1Click(Sender: TObject);
begin
  if not Timer1.Enabled then
  begin
    if not ativado then
    begin
      TempoInicial := StrToInt(LabelTimerMinuto.Text) * 60 + StrToInt(LabelTimerSegundo.Text); // converte o tempo em minutos e segundos para segundos
      TempoRestante := TempoInicial;
      ImgBtn.Bitmap.LoadFromFile('..\..\..\Assets\Icons\pause.png');

       //PlayMp3;
      if TempoRestante > 0 then
      begin
        Timer1.Enabled := True; // inicia o Timer apenas se o tempo restante for maior que zero

      end;
      //ativado := True; // atualiza o valor da vari�vel ativado para True


    end;

  end
  else
    begin
    //ShowMessage('Desativado');
    Timer1.Enabled := False;
    ImgBtn.Bitmap.LoadFromFile('..\..\..\Assets\Icons\play.png');
     //ativado := False;

  end;
    ativado := not ativado;
end;


procedure TContagem.SpeedButton2Click(Sender: TObject);
begin
    Self.Destroy;
end;

procedure TContagem.SpeedButton3Click(Sender: TObject);
begin
  TempoInicial := TempoCiclo;
  TempoRestante := TempoInicial;
  ImgBtn.Bitmap.LoadFromFile('..\..\..\Assets\Icons\pause.png');
  Timer1.Enabled := True;

end;

procedure TContagem.Timer1Timer(Sender: TObject);

begin
  if TempoRestante > 0 then
  begin
    barraTempo;
    Dec(TempoRestante);

    var CurrentMinutes := TempoRestante div 60;
    var CurrentSeconds := TempoRestante mod 60;

    LabelTimerMinuto.Text := Format('%.2d', [CurrentMinutes]);
    LabelTimerSegundo.Text := Format('%.2d', [CurrentSeconds]);
  end;
  if (TempoRestante = 0) and ativado then
    begin
      //ShowMessage(TempoRestante.ToString);
      Timer1.Enabled := False;
      ImgBtn.Bitmap.LoadFromFile('..\..\..\Assets\Icons\play.png');
      PlayMp3;
      ativado := False;
      TempoRestante := TempoInicial;
      TempoInicial := TempoCiclo * 60;
      ShowMessage('Ciclo completo');
    end;
end;



end.
