// CodeGear C++Builder
// Copyright (c) 1995, 2018 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FMX.WndProcHook.pas' rev: 33.00 (Windows)

#ifndef Fmx_WndprochookHPP
#define Fmx_WndprochookHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <FMX.Types.hpp>
#include <FMX.Forms.hpp>

//-- user supplied -----------------------------------------------------------

namespace Fmx
{
namespace Wndprochook
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TWndProcHook;
class DELPHICLASS TWndProcForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TWndProcHook : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	Fmx::Forms::TCustomForm* FForm;
	HWND FWndHandle;
	void *FObjectInstance;
	void *FDefWindowProc;
	System::Classes::TWndMethod FWndProc;
	void __fastcall MainWndProc(Winapi::Messages::TMessage &Message);
	
public:
	void __fastcall HookWndProc();
	void __fastcall UnHookWndProc();
	NativeInt __fastcall Perform(unsigned Msg, NativeUInt WParam, NativeInt LParam);
	__fastcall virtual TWndProcHook(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TWndProcHook();
	__property System::Classes::TWndMethod WndProc = {read=FWndProc, write=FWndProc};
	__property HWND WndHandle = {read=FWndHandle, nodefault};
};


class PASCALIMPLEMENTATION TWndProcForm : public Fmx::Forms::TForm
{
	typedef Fmx::Forms::TForm inherited;
	
private:
	TWndProcHook* FWndProcHook;
	HWND __fastcall GetWndHandle();
	
protected:
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	
public:
	__fastcall virtual TWndProcForm(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TWndProcForm();
	virtual void __fastcall DoShow();
	NativeInt __fastcall Perform(unsigned Msg, NativeUInt WParam, NativeInt LParam);
	__property HWND WndHandle = {read=GetWndHandle, nodefault};
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TWndProcForm(System::Classes::TComponent* AOwner, NativeInt Dummy) : Fmx::Forms::TForm(AOwner, Dummy) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wndprochook */
}	/* namespace Fmx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX_WNDPROCHOOK)
using namespace Fmx::Wndprochook;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX)
using namespace Fmx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fmx_WndprochookHPP
