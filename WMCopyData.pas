unit WMCopyData;
{$MODE Delphi}          
interface

uses
  {$IFDEF Windows}
    Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type

//  Declared in Windows.pas

//  TCopyDataStruct = packed record
//    dwData: DWORD; //up to 32 bits of data to be passed to the receiving application
//    cbData: DWORD; //the size, in bytes, of the data pointed to by the lpData member
//    lpData: Pointer; //Points to data to be passed to the receiving application. This member can be nil.
//  end;

TCopyDataType = (cdtDWord, cdtBuffer, cdtString);

// Must be present on the destination main form
//  private
//    procedure WMCopyData(var Msg : TWMCopyData); message WM_COPYDATA;


function FindWindowHandle(lpClassName, lpWindowName: PChar): THandle;
function WM_CDSendData(const copyDataStruct: TCopyDataStruct; myHandle, destHandle: THandle): longint;
function WM_CDSendDWORD(aDWord: DWORD; myHandle, destHandle: THandle): longint;
function WM_CDSendBuffer(var buf; Size: Longword; myHandle, destHandle: THandle): longint;
function WM_CDSendString(stringToSend : string; myHandle, destHandle: THandle): longint;

implementation

uses main;

var ReceivedString: string;
 ReceivedDWord: DWord;
 ReceivedCount: integer;

function FindWindowHandle(lpClassName, lpWindowName: PChar): THandle;
begin
  //receiverHandle := FindWindow(PChar('TReceiverMainForm'),PChar('ReceiverMainForm'));
  result := FindWindow(lpClassName, lpWindowName);
  if result = 0 then begin
    raise Exception.Create('Cannot find '+lpClassName+' or '+lpWindowName);
  end;
end;

function WM_CDSendData(const copyDataStruct: TCopyDataStruct; myHandle, destHandle: THandle): longint;
begin
  result := SendMessage(destHandle, WM_COPYDATA, Integer(myHandle), Integer(@copyDataStruct));
end;


function WM_CDSendDWORD(aDWord: DWORD; myHandle, destHandle: THandle): longint;
var copyDataStruct : TCopyDataStruct;
begin
  copyDataStruct.dwData:=ord(cdtDWord);
  copyDataStruct.cbData:=aDWord;
  result := SendMessage(destHandle, WM_COPYDATA, Integer(myHandle), Integer(@copyDataStruct));
end;


function WM_CDSendBuffer(var buf; Size: Longword; myHandle, destHandle: THandle): longint;
var copyDataStruct : TCopyDataStruct;
begin
  copyDataStruct.dwData := ord(cdtBuffer); //use it to identify the message contents
  copyDataStruct.cbData := Size;
  copyDataStruct.lpData := @buf;

  result:=WM_CDSendData(copyDataStruct, myHandle, destHandle);
end;


function WM_CDSendString(stringToSend : string; myHandle, destHandle: THandle): longint;
var copyDataStruct : TCopyDataStruct;
begin
  copyDataStruct.dwData := ord(cdtString); //use it to identify the message contents
  copyDataStruct.cbData := 1 + Length(stringToSend);
  copyDataStruct.lpData := PChar(stringToSend);

  result:=WM_CDSendData(copyDataStruct, myHandle, destHandle);
end;


{FA_TAG:
procedure ProcessWMCopyData(var Msg: TWMCopyData);
var  copyDataType : TCopyDataType;
begin
  copyDataType := TCopyDataType(Msg.CopyDataStruct.dwData);

  case copyDataType of

    cdtDWord:  begin
      ReceivedDWord:= Msg.CopyDataStruct.cbData;
      inc(ReceivedCount);
      msg.Result := ReceivedCount;
    end;

    cdtBuffer: msg.Result := -1;

    cdtString: begin
      ReceivedString := PChar(Msg.copyDataStruct.lpData);
      inc(ReceivedCount);
      msg.Result := length(ReceivedString);
    end;

  end;
end;

}


end.

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure TfrmMain.btnReadClick(Sender: TObject);
var
  Data: array[0..4096] of Boolean;
  iAmount: Integer;
  i: Integer;
  sLine: String;
begin
  iAmount := StrToInt(editAmount.Text);
  if (iAmount > 0) then  begin
    FillChar(Data[0], Length(Data), 0);
    mctPLC.Host := edtIPAddress.Text;
    if mctPLC.ReadInputBits(StrToInt(edtReadReg.Text), iAmount, Data) then
    begin
      sLine := 'Read:'+IntToStr(StrToInt(edtReadReg.Text) ) + ' 0x';
      for i := 0 to (iAmount - 1) do begin
        sLine := sLine + ' ' +
                 //AJS IntToHex(Data[i], 4);
                 IntToHex((byte(Data[i])), 1); // AJS

        if (i mod 8)=3 then sLine:=sLine+'.';
        if (i mod 8)=7 then sLine:=sLine+',';
      end;
      //ShowMessage(sLine);
      Memo1.Lines.Append(sLine);
    end
    else
      ShowMessage('PLC read inputs failed!');
  end;
end; { btnReadClick }




procedure TfrmMain.BWriteCoilsClick(Sender: TObject);
var
  //Data: array[0..4096] of Boolean;
  Data: array of Boolean;
  i, iAmount: Integer;
  sLine: String;
begin
  mctPLC.Host := edtIPAddress.Text;
  iAmount := StrToInt(editAmount.Text);
  if (iAmount > 0) then begin
    SetLength(Data,iAmount);
    FillChar(Data[0], Length(Data), 0);
    for i:=low(data) to min(Min(high(data),iAmount-1), length(edtValue.Text)) do
      if (edtValue.Text[i+1]<>'0') then data[i]:=true;

    if mctPLC.WriteCoils(StrToInt(edtWriteReg.Text), iAmount, Data) then
      Memo1.Lines.Append('PLC WriteCoils successful!')
    else
      Memo1.Lines.Append('PLC WriteCoils failed!');

    //MessageDlg('PLC WriteCoils failed!', mtError, [mbOk], 0);

  end;
end;

