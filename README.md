# FMXWndProcHook
FMX下TForm的WndProc HOOK   

**工程基于Delphi 10.3.2**   

### 用法

```pascal

unit Unit23;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WndProcHook,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm23 = class(TWndProcForm)
    Button1: TButton;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }
    procedure WMMove(var msg: TWMMove); message WM_MOVE;
    procedure WMLButtonDown(var msg: TWMLButtonDown); message WM_LBUTTONDOWN;
  end;

var
  Form23: TForm23;

implementation

{$R *.fmx}

procedure TForm23.Button1Click(Sender: TObject);
begin
  Perform(WM_SYSCOMMAND, SC_MINIMIZE, 0);
end;

procedure TForm23.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  Log.d('mousedown: x=%f, y=%f', [x, y]);
end;

procedure TForm23.WMLButtonDown(var msg: TWMLButtonDown);
begin
  Log.d('鼠标按下: x=%d, y=%d', [Msg.XPos, msg.YPos]);
//  Msg.Result := 1;  // 拦截消息，这样 FormMouseDown 就收不到这个消息了
end;

procedure TForm23.WMMove(var msg: TWMMove);
begin
  msg.Result := 1;
  Log.d('收到移动的消息');
end;

procedure TForm23.WndProc(var Message: TMessage);
begin
  inherited;
  if Message.Msg = WM_LBUTTONDOWN then
  begin
    Log.d('WndProc 鼠标按下: x=%d, y=%d', [TWMLButtonDown(Message).XPos, TWMLButtonDown(Message).YPos]);
    //Message.Result := 1;  // 拦截消息， WMLButtonDown  FormMouseDown 将都收不到消息
  end;
end;

end.
```