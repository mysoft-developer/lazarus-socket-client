unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  SfmlNetwork, SfmlSystem;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    ServerRecord: TsfmlIpAddress;
    Socket: TsfmlTcpSocket;
    MsgFromServer, MsgToServer: array[0..99] of char;
    PMsg: pointer;
    MsgLength: longword;
    procedure Log(texto: string);
    procedure Connect(MyPort: integer);
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

const
  PORT = 1717;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  Connect(PORT);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  status: TSfmlSocketStatus;

begin
  Timer1.Enabled := False;

  while True do
  begin
    Application.ProcessMessages;
    Sleep(100);

    PMsg := @MsgFromServer;
    status := socket.receive(PMsg, 100, MsgLength);
    if status = sfSocketDone then
    begin
      Log('Message received from the server: ' + MsgFromServer);

      PMsg := @MsgToServer;
      MsgToServer := 'OK';
      status := socket.send(PMsg, 18);
      if status = sfSocketDisconnected then
        Connect(PORT);
    end
    else if status = sfSocketDisconnected then
    begin
      Connect(PORT);
    end;
  end;
end;

procedure TForm1.Log(texto: string);
begin
  Memo1.Lines.Add(FormatDateTime('dd/mm/yyyy hh:nn:ss', now()) + ' - ' + texto);
end;

procedure TForm1.Connect(MyPort: integer);
begin
  Timer1.Enabled := False;
  Socket := TsfmlTcpSocket.Create;
  ServerRecord.Address := Edit1.Text;

  while SfmlTcpSocketConnect(Socket.Handle, ServerRecord, MyPort, SfmlSeconds(2)) <> sfSocketDone do
  begin
    Log('Connecting...');
    Application.ProcessMessages;
  end;

  Log('Connected to server');
  Timer1.Enabled := True;
end;

end.

