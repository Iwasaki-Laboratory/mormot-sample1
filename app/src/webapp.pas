unit WebApp;

interface

uses
  Classes,
  SysUtils,
  mormot.core.base,
  mormot.core.os,
  mormot.net.http,
  mormot.net.async;

type
  TWebApp = class
  private
    fHttpServer: THttpAsyncServer;
  protected
    function DoGetIndex(Ctxt: THttpServerRequestAbstract): cardinal;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

const
  PORT = '8080';

const INDEX_HTML: RawUtf8 = 
  '<!DOCTYPE html>' +
  '<html lang="ja">' +
  '<meta charset="UTF-8">' +
  '<title>' +
  'Web Application Sample' +
  '</title>' +
  '<body style="font-size:24px;">' +
  '<p>' +
  'Free Pascal + mORMot2' +
  '</p>' +
  '<p>' +
  'Simple Web Application by mORMot2' +
  '</p>' +
  '</body>' +
  '</html>';

function TWebApp.DoGetIndex(Ctxt: THttpServerRequestAbstract): cardinal;
begin
  Result := 200;
  Ctxt.OutContent := INDEX_HTML;
  Ctxt.OutContenttype := 'text/html; charset=utf-8';
end;

constructor TWebApp.Create;
begin
  inherited Create;
  fHttpServer := THttpAsyncServer.Create(
    '0.0.0.0:' + PORT, nil, nil, '', SystemInfo.dwNumberOfProcessors + 1, 30000, []);

  with fHttpServer do
  begin
    // ルーティング
    Route.Get('/', @DoGetIndex);

    WaitStarted;
  end;
end;

destructor TWebApp.Destroy;
begin
  fHttpServer.Free;
  inherited Destroy;
end;

end.