program main;

uses
  cthreads,
  SysUtils,
  BaseUnix,
  Unix,
  mormot.core.os,
  WebApp;

var
  wp: TWebApp;
  Terminated: Boolean;

procedure SignalHandler(signal: LongInt; info: psiginfo; context: PSigContext) CDecl;
begin
  case signal of
    SIGTERM: writeln('SIGTERM received. Stopping...');
    SIGINT : writeln('SIGINT received. Stopping...');
  end;
  Terminated := True;
end;

procedure InstallSignalHandlers;
var
  action: SigActionRec;
begin
  FillChar(action, SizeOf(action), 0);
  action.sa_handler := @SignalHandler;
  action.sa_flags := 0;

  // docker stop → SIGTERM
  fpSigAction(SIGTERM, @action, nil);

  // Ctrl+C → SIGINT
  fpSigAction(SIGINT, @action, nil);
end;

begin
  Terminated := False;
  InstallSignalHandlers;
  
  wp := TWebApp.Create;
  try
    writeln('アプリ起動: http://localhost:8080/');

    while not Terminated do
      Sleep(100);

  finally
    wp.Free;
  end;
end.
