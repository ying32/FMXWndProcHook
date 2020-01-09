unit Unit23;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WndProcHook;

type
  TForm23 = class(TWndProcForm)
  private
    { Private declarations }
  protected
//    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }
    procedure WMMove(var msg: TWMMove); message WM_MOVE;
    procedure WMLButtonDown(var msg: TWMLButtonDown); message WM_LBUTTONDOWN;
  end;

var
  Form23: TForm23;

implementation

{$R *.fmx}

procedure TForm23.WMLButtonDown(var msg: TWMLButtonDown);
begin
  Log.d('鼠标按下: x=%d, y=%d', [Msg.XPos, msg.YPos]);
end;

procedure TForm23.WMMove(var msg: TWMMove);
begin
  msg.Result := 1;
  Log.d('收到移动的消息');
end;

end.
