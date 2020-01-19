{*******************************************************}
{                                                       }
{       软件名 Windows下 FMX HOOK窗口过程               }
{       by: ying32                                      }
{       版权所有 (C) 2020 公司名                        }
{                                                       }
{*******************************************************}

unit FMX.WndProcHook;

{$IFNDEF MSWINDOWS}
  {$MESSAGE ERROR '只能应用于Windows下'}
{$ENDIF}

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Classes,
  System.SysUtils,
  FMX.Types,
  FMX.Forms;

type

  // 这个类主要是给不想继承窗口使用的

  TWndProcHook = class(TComponent)
  private
    FForm: TCustomForm;
    FWndHandle: HWND;
    FObjectInstance: Pointer;
    FDefWindowProc: Pointer;
    FWndProc: TWndMethod;
    procedure MainWndProc(var Message: TMessage);
  public
    procedure HookWndProc;
    procedure UnHookWndProc;
    function Perform(Msg: Cardinal; WParam: WPARAM; LParam: LPARAM): LRESULT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property WndProc: TWndMethod read FWndProc write FWndProc;
  end;

  {
    用法：
      继承自此类

      然后像VCL那样定义就行
      procedure WMMove(var msg: TWMMove); message WM_MOVE;

      procedure TForm23.WMMove(var msg: TWMMove);
      begin
        msg.Result := 1;
        Log.d('收到移动的消息');
      end;
  }

  TWndProcForm = class(TForm)
  private
    FWndProcHook: TWndProcHook;
  protected
    /// <summary>
    ///   窗口消息过程
    /// </summary>
    procedure WndProc(var Message: TMessage); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoShow; override;
    function Perform(Msg: Cardinal; WParam: WPARAM; LParam: LPARAM): LRESULT;
  end;

implementation

uses
  FMX.Platform.Win;

{ TWndProcForm }

constructor TWndProcForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWndProcHook := TWndProcHook.Create(Self);
  FWndProcHook.WndProc := WndProc;
end;

destructor TWndProcForm.Destroy;
begin
  FWndProcHook.Free;
  inherited;
end;

procedure TWndProcForm.DoShow;
begin
  if not(csDesigning in ComponentState) then
    FWndProcHook.HookWndProc;
  inherited;
end;

function TWndProcForm.Perform(Msg: Cardinal; WParam: WPARAM;
  LParam: LPARAM): LRESULT;
begin
  Result := FWndProcHook.Perform(Msg, WParam, LParam);
end;

procedure TWndProcForm.WndProc(var Message: TMessage);
begin
  // virtual method
end;

{ TWndProcHook }

constructor TWndProcHook.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if AOwner = nil then
    raise Exception.Create('AOwner不能为nil。');

  if not (AOwner is TCustomForm) then
    raise Exception.Create('AOwner必须为继承自TCustomForm的。');

  FForm := AOwner as TCustomForm;
end;

destructor TWndProcHook.Destroy;
begin
  UnHookWndProc;
  FForm := nil;
  inherited;
end;

procedure TWndProcHook.HookWndProc;
begin
  // 设计状态，不HOOK
  if csDesigning in ComponentState then
    Exit;
  // 已HOOK
  if FObjectInstance <> nil then
    Exit;

  if FWndHandle = 0  then
    FWndHandle := FmxHandleToHWND(FForm.Handle);

  if FWndHandle > 0 then
  begin
    if FObjectInstance = nil then
    begin
      FObjectInstance := MakeObjectInstance(MainWndProc);
      if FObjectInstance <> nil then
      begin
        FDefWindowProc := Pointer(GetWindowLong(FWndHandle, GWL_WNDPROC));
        SetWindowLong(FWndHandle, GWL_WNDPROC, IntPtr(FObjectInstance));
      end;
    end;
  end;
end;

procedure TWndProcHook.MainWndProc(var Message: TMessage);
begin
  try
    if Assigned(FWndProc) then
    begin
      // 消息传递过程。
      FWndProc(Message);
      // 消息派遣，如果WndProc返回0没处理的就派遣消息，反之不再向下派遣消息
      // procedure WMMove(var Msg: TWMMove); message WM_MOVE;
      if Message.Result = 0 then
        FForm.Dispatch(Message);
    end;
  except
    Application.HandleException(Self);
  end;
  with Message do
  begin
    if Result = 0 then
      Result := CallWindowProc(FDefWindowProc, FWndHandle, Msg, WParam, LParam);
  end;
end;

function TWndProcHook.Perform(Msg: Cardinal; WParam: WPARAM;
  LParam: LPARAM): LRESULT;
//var
//  LMsg: TMessage;
begin
  Result := 0;
  if FForm <> nil then
    Result := LRESULT(PostMessage(FWndHandle, Msg, WParam, LParam));

//  LMsg.Msg := Msg;
//  LMsg.WParam := WParam;
//  LMsg.LParam := LParam;
//  LMsg.Result := 0;
//  //if FForm <> nil then
//    MainWndProc(LMsg);
//  Result := LMsg.Result;
end;

procedure TWndProcHook.UnHookWndProc;
begin
  if FDefWindowProc <> nil then
  begin
    SetWindowLong(FWndHandle, GWL_WNDPROC, IntPtr(FDefWindowProc));
    FDefWindowProc := nil;
  end;
  if FObjectInstance <> nil then
  begin
    FreeObjectInstance(FObjectInstance);
    FObjectInstance := nil;
  end;
end;

end.
