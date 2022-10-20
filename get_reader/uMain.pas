unit uMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, BCPort, ActnList, RzButton, Buttons, RzEdit, RzBckgnd,
  uRidThread, RzPrgres, ComCtrls, uDM, XPMan, Grids, DBGrids, ExtCtrls,
  RzPanel, RzGroupBar, RzStatus, RzTabs, RzRadChk, RzCommon, DB,
  DBAccess, Ora, RzCmboBx, RzLabel, MemDS;

type
  TFMain = class(TForm)
    BCP: TBComPort;
	 AL: TActionList;
	 AVer: TAction;
    AConnect: TAction;
    ADisconnect: TAction;
    AExit: TAction;
    AGetDate: TAction;
    ASetDate: TAction;
    AGetPokaz: TAction;
    XPManifest1: TXPManifest;
    RzCBFlush: TRzCheckBox;
    RzMTest: TRzMemo;
    RzPB: TRzProgressBar;
	 RzIni: TRzRegIniFile;
	 AFlushFlag: TAction;
    RzBitBtn1: TRzBitBtn;
    AStart: TAction;
    AOraConnect: TAction;
    AOraDisconnect: TAction;
    AFlushBase: TAction;
    RzButton1: TRzButton;
    cb: TRzComboBox;
    RzLabel1: TRzLabel;
    Timer: TTimer;
    procedure AConnectExecute(Sender: TObject);
    procedure ADisconnectExecute(Sender: TObject);
    procedure AExitExecute(Sender: TObject);
    procedure AVerExecute(Sender: TObject);
    procedure AGetDateExecute(Sender: TObject);
    procedure ASetDateExecute(Sender: TObject);
    procedure AGetPokazExecute(Sender: TObject);
    procedure AFlushFlagExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AStartExecute(Sender: TObject);
    procedure AOraConnectExecute(Sender: TObject);
    procedure AOraDisconnectExecute(Sender: TObject);
    procedure AFlushBaseExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
	 { Private declarations }
    RidThread: TRidThread;
	 bAuto: Boolean;
    Procedure RidThreadStart;
    Function HexToStr(B: Byte): String;
    Function StrToHex(S: String): Byte;
    Procedure AddOraRow(roll: Integer;
                        askue_src: Integer;
                        inter_type: Integer;
								ser_num: String;
                        val_date: TDate;
                        sch_val1: Real;
                        sch_val2: Real;
                        sch_val3: Real;
								sch_stat_ext: Byte;
								val_num: Byte);
    Function RidToDate(b0: Byte; b1: Byte; b2: Byte): TDate;
    Function RidToTime(b0: Byte; b1: Byte; b2: Byte): TTime;
  public
    { Public declarations }
    Procedure ResParse;
  end;

var
  FMain: TFMain;
  MessLine: string;

  OutBuf: array[0..127] of byte;
  InBuf: array[0..127] of byte;
  ErrCode: Integer;

  BaseCur: Byte;
  BaseCnt: Byte;
  RecCur: Word;
  RecCnt: Word;

implementation

{$R *.dfm}

procedure TFMain.AConnectExecute(Sender: TObject);
begin
  BCP.Port := RzIni.ReadString('Hard', 'Port', cb.text);
  BCP.Open;
  BCP.ClearBuffer(true, true);  

  MessLine := '���� ' + BCP.Port + ' ������.';
  RzMTest.Lines.Add(MessLine);
  if bAuto then FMain.AVer.Execute; 
  //sleep(1001);
  //if bAuto then FMain.AVer.Execute;
end;

procedure TFMain.ADisconnectExecute(Sender: TObject);
begin
  RzMTest.Lines.SaveToFile(ParamStr(6));
  BCP.Close;
  MessLine := '���� ' + RzIni.ReadString('Hard', 'Port', cb.text) + ' ������.';
  RzMTest.Lines.Add(MessLine);
  if bAuto then FMain.AExit.Execute; // ���� ���� - �����
end;

procedure TFMain.AExitExecute(Sender: TObject);
begin
 //ErrCode := 1;
  RzMTest.Lines.SaveToFile(ParamStr(6));
  Application.Terminate;
end;

// ========== �������������� �������-����������� ����� � ������ ==========
Function TFMain.HexToStr(B: Byte): String;
Begin
  HexToStr := IntToStr(B div 16) + IntToStr(B mod 16);
End;

// ========== �������������� ������ � �������-���������� ���� ==========
Function TFMain.StrToHex(S: String): Byte;
Begin
  StrToHex := ((StrToInt(Copy(S, 1, 1))) shl 4) or
				  (StrToInt(Copy(S, 2, 1)));
End;

// ============= ��������� Date �� ������������ ������� ===========
Function TFMain.RidToDate(b0: Byte; b1: Byte; b2: Byte): TDate;
Var
  S: String;
  PrevFmt: String;
Begin
//b0:=$10; b1:=$19; b2:=$02;
  PrevFmt := ShortDateFormat;
  ShortDateFormat := 'dd.mm.yyyy';
  S := HexToStr(b0 and $3F) + '.' +
		 HexToStr(b1 and $1F) + '.' +
		 IntToStr(2000 + b2 * 4 + ((b0 and $C0) shr 6));
  try
	RidToDate := StrToDate(S);
  except
	RzMTest.Lines.Add('������ ����: ���� ��������� � ������ ' + S);
	RidToDate := StrToDate('01.01.2000');//���-������ ���������� ����� �������
	ShortDateFormat := PrevFmt;
	Exit;
  end;

  ShortDateFormat := PrevFmt;
End;

// ============ �������� ������ ����� ������ ============
function bm(CurrDate: TDate): TDate;
var
  PrevFmt: String;
  ResDate: TDate;
begin
  PrevFmt := ShortDateFormat;
  ShortDateFormat := 'dd.mm.yyyy';
  ResDate := StrToDate('01' + Copy(DateToStr(CurrDate), 3, 8));
  ShortDateFormat := PrevFmt;
  bm := ResDate;
end;

// ============= ��������� Time �� ������������ ������� ===========
Function TFMain.RidToTime(b0: Byte; b1: Byte; b2: Byte): TTime;
Var
  S: String;
  PrevFmt: String;
Begin
  PrevFmt := ShortTimeFormat;
  ShortTimeFormat := 'hh:nn:ss';
  S := HexToStr(b2) + ':' +
       HexToStr(b1) + ':' +
       HexToStr(b0);
  RidToTime := StrToTime(S);
  ShortTimeFormat := PrevFmt;
End;

// ============= ������ �������� ���������� ==============
procedure TFMain.ResParse;
begin
ErrCode:= 0;
  If ErrCode = 0 Then 
  Begin
	 If InBuf[0] = $00 Then 
	 Begin  // ������ ��
		MessLine := '������ ��: ' + IntToStr(InBuf[2]) + '.' + FormatFloat('00', InBuf[3]);
		RzMTest.Lines.Add(MessLine);
		if bAuto then FMain.AGetDate.Execute; // ���� ���� - �����
	 End 
	  Else 
	 If InBuf[0] = $01 Then 
		Begin
		 MessLine := '����/����� ������: ' +
						DateToStr(RidToDate(InBuf[5], InBuf[6], InBuf[7])) + ' ' +
						TimeToStr(RidToTime(InBuf[2], InBuf[3], InBuf[4]));
		 RzMTest.Lines.Add(MessLine);
		 if bAuto then FMain.ASetDate.Execute; // ���� ���� - �����
		End 
		 Else If InBuf[0] = $02 Then 
		  Begin
			MessLine := '����/����� �����������.';
			RzMTest.Lines.Add(MessLine);
			if bAuto then FMain.AOraConnect.Execute; // ���� ���� - �����
		  End 
			Else 
			 If InBuf[0] = $03 Then 
			  Begin  // ��������� ���������� � ������� ����
				RecCnt := InBuf[3] + InBuf[4] * 256;
				MessLine := '������� � ���� �: ' + IntToStr(InBuf[2]) + ' - ' +
						IntToStr(RecCnt) + '.';
				RzMTest.Lines.Add(MessLine);
// ============= ��������� ������� ���� ==============
		If RecCnt > 0 then
      begin
        OutBuf[0] := $04;
        OutBuf[1] := $03;
		  OutBuf[2] := BaseCur;
		  RidThreadStart;
      end else begin  // ���� ����� - ���� ������
        BaseCur := BaseCur + 1; // ��������� ����
        if BaseCur < BaseCnt then begin
          RecCur := 0;
			 OutBuf[0] := $03;
			 OutBuf[1] := $03;
			 OutBuf[2] := BaseCur;
			 RidThreadStart;
        end else begin  // ��� ���� ���������
          if bAuto then FMain.AOraDisconnect.Execute; // ���� ���� - �����
        end;
      end;
	 End Else If (InBuf[0] = $04) or (InBuf[0] = $06) Then Begin // ������ ��� ��������� ������ �� ����
// ����� �������� ������
      if (InBuf[2] = 0) or       
         (InBuf[2] = 1) or
         (InBuf[2] = 3) or
			(InBuf[2] = 4) then begin  // ��� ���� ��������� ������ ���������� ������
// ��������� �� ������ ������
		  AddOraRow(StrToInt(ParamStr(4)),
						StrToInt(ParamStr(5)),
						InBuf[2],
						HexToStr(InBuf[3]) + HexToStr(InBuf[4]) + HexToStr(InBuf[5]),
						bm(RidToDate(InBuf[8], InBuf[9], $05)),
						InBuf[20] + InBuf[21] * $100 + InBuf[22] * $10000,
						InBuf[23] + InBuf[24] * $100 + InBuf[25] * $10000,
						InBuf[26] + InBuf[27] * $100 + InBuf[28] * $10000,
						InBuf[10], 0);
// ������� ���������
		  AddOraRow(StrToInt(ParamStr(4)),
						StrToInt(ParamStr(5)),
						InBuf[2],
						HexToStr(InBuf[3]) + HexToStr(InBuf[4]) + HexToStr(InBuf[5]),
						RidToDate(InBuf[8], InBuf[9], $05),
						InBuf[11] + InBuf[12] * $100 + InBuf[13] * $10000,
                  InBuf[14] + InBuf[15] * $100 + InBuf[16] * $10000,
                  InBuf[17] + InBuf[18] * $100 + InBuf[19] * $10000,
                  InBuf[10], 1);
      end else if (InBuf[2] = 2) then begin   // ���� ��� - ����������
        AddOraRow(StrToInt(ParamStr(4)),
                  StrToInt(ParamStr(5)),
                  InBuf[2],
                  HexToStr(InBuf[3]) + HexToStr(InBuf[4]) + HexToStr(InBuf[5]),
						RidToDate(InBuf[8], InBuf[9], $05),
                  (InBuf[10] + InBuf[11] * $100 + InBuf[12] * $10000 + InBuf[13] * $1000000) / 4000,
                  0,
                  0,
                  0, 0);
      end;
		RzPB.Percent := RecCur * 100 div (RecCnt);
      RecCur := RecCur + 1;
      if RecCur < RecCnt then
      begin
        OutBuf[0] := $06; // ��������� ������ ����
		  OutBuf[1] := $03;
		  OutBuf[2] := BaseCur;
		  RidThreadStart;
      end else begin // ��������� ����
        BaseCur := BaseCur + 1; // ��������� ����
        if BaseCur < BaseCnt then begin
          RecCur := 0;
          OutBuf[0] := $03;
          OutBuf[1] := $03;
          OutBuf[2] := BaseCur;
          RidThreadStart;
        end else begin  // ��� ���� ���������
          if bAuto then FMain.AOraDisconnect.Execute; // ���� ���� - �����
        end;
      end;
	 End Else If InBuf[0] = $09 Then Begin
      MessLine := '������� ���� �: ' + IntToStr(InBuf[2]) + '.';
      RzMTest.Lines.Add(MessLine);
      BaseCur := BaseCur + 1; // ��������� ����
      if BaseCur < BaseCnt then begin
        OutBuf[0] := $09;
		  OutBuf[1] := $03;
		  OutBuf[2] := BaseCur;
		  RidThreadStart;
      end else begin  // ��� ���� ���������
        if bAuto then FMain.ADisconnect.Execute; // ���� ���� - �����
      end;
    End;
  End Else If ErrCode = 1 Then Begin    // �� ��������� (������ ��������)
	 //MessLine := '������ ��������.';
	 BCP.Close;
	 RzMTest.Lines.Add('������ ��������.');
	 RzButton1.Enabled := true; 
  End;
end;

procedure TFMain.RidThreadStart;
begin
  RidThread := TRidThread.Create(True);
  RidThread.FreeOnTerminate := True;
  RidThread.Priority := tpLower;
  RidThread.Resume;
end;

procedure TFMain.AVerExecute(Sender: TObject);
begin
// ============ ������ ������ �� =============
  OutBuf[0] := $00;
  OutBuf[1] := $02;
  RidThreadStart;
end;

procedure TFMain.AGetDateExecute(Sender: TObject);
begin
// ============ ������ ���� =============
  OutBuf[0] := $01;
  OutBuf[1] := $02;
  RidThreadStart;
end;

procedure TFMain.ASetDateExecute(Sender: TObject);
Var
  PrevDFmt: String;
  PrevTFmt: String;
  SDate: String;
  STime: String;
  PrevDayNames: array[1..7] of string;
  It: Integer;
begin
// ============ ������ ���� =============
  PrevDFmt := ShortDateFormat;
  PrevTFmt := ShortTimeFormat;
  For It := 1 To 7 Do
  Begin
    PrevDayNames[It] := ShortDayNames[It];
    ShortDayNames[It] := FormatFloat('00', It - 1);
  End;
  ShortDateFormat := 'ddd.dd.mm.yy';
  ShortTimeFormat := 'hh:nn:ss';
  SDate := DateToStr(Date());
  STime := TimeToStr(Time());
  If Length(STime) = 7 Then STime := '0' + STime;  // ���������� WinXP 'hh' ��� ��� 'h'
  ShortDateFormat := PrevDFmt;
  ShortTimeFormat := PrevTFmt;
  For It := 1 To 7 Do
  Begin
    ShortDayNames[It] := PrevDayNames[It];
  End;

  OutBuf[0] := $02;
  OutBuf[1] := $08;
  OutBuf[2] := StrToHex(Copy(STime, 7, 2));
  OutBuf[3] := StrToHex(Copy(STime, 4, 2));
  OutBuf[4] := StrToHex(Copy(STime, 1, 2));
  OutBuf[5] := StrToHex(Copy(SDate, 4, 2)) or
               ((StrToInt(Copy(SDate, 10, 2)) mod 4) shl 6);
  OutBuf[6] := StrToHex(Copy(SDate, 7, 2)) or
					(StrToInt(Copy(SDate, 1, 2)) shl 5);
  OutBuf[7] := StrToInt(Copy(SDate, 10, 2)) mod 100 div 4;
  RidThreadStart;
end;

procedure TFMain.AGetPokazExecute(Sender: TObject);
begin
  BaseCnt := 5; // ����� ������ ��������� ���������
  BaseCur := 0;
  RecCur := 0;
  OutBuf[0] := $03;
  OutBuf[1] := $03;
  OutBuf[2] := BaseCur;
  RidThreadStart;
end;

procedure TFMain.AFlushFlagExecute(Sender: TObject);
begin
  RzIni.WriteBool('Interface', 'FlushFlag', RzCBFlush.Checked);
end;

procedure TFMain.FormCreate(Sender: TObject);
var
a:integer;
begin
 Randomize;
 EnumComPorts(cb.items);
 RzCBFlush.Checked := RzIni.ReadBool('Interface', 'FlushFlag', RzCBFlush.Checked);
 bAuto := false;
 FMain.Top := Random(500); 
 FMain.Left := Random(600);
 //showmessage(ParamStr(6));
//ShowMessagePos('�������� COM-���� � �������� ���������� ����� � ������� �����',FMain.Top,FMain.Left);
end;

procedure TFMain.AStartExecute(Sender: TObject);
begin
  RzBitBtn1.Enabled := false;
  RzButton1.Enabled := false;
  bAuto := true;
  FMain.AConnect.Execute;
end;

procedure TFMain.AOraConnectExecute(Sender: TObject);
begin
  DM.OS.Server := ParamStr(1);
  DM.OS.Schema := ParamStr(2);
  DM.OS.Username := ParamStr(2);
  DM.OS.Password := ParamStr(3);
  DM.OS.Open;
  MessLine := '���������� � �� �����������.';
  RzMTest.Lines.Add(MessLine);
  if bAuto then FMain.AGetPokaz.Execute; // ���� ���� - �����
end;

procedure TFMain.AOraDisconnectExecute(Sender: TObject);
begin
  DM.OS.Commit;
  DM.OS.Close;
  MessLine := '���������� � �� ���������.';
  RzMTest.Lines.Add(MessLine);
  if bAuto then begin
    if RzCBFlush.Checked then begin
      FMain.AFlushBase.Execute; // ���� ���� - �����
    end else begin
		FMain.ADisconnect.Execute; // ���� ���� - �����
    end;
  end;
end;

Procedure TFMain.AddOraRow(roll: Integer;
									askue_src: Integer;
									inter_type: Integer;
									ser_num: String;
									val_date: TDate;
									sch_val1: Real;
									sch_val2: Real;
									sch_val3: Real;
									sch_stat_ext: Byte;
									val_num: Byte);
Begin
// ============== ����-�� ��� ����� ������? ===============
 try
  DM.OQ.SQL.Clear;
  DM.OQ.SQL.Add('SELECT count(id) c_id FROM ' +
	 DM.OS.Schema + '.sch_val WHERE askue_src = :askue_src AND ' +
	 'inter_type = :inter_type AND ser_num = :ser_num AND ' +
	 'val_date = :val_date AND val_num = :val_num');
  DM.OQ.ParamByName('askue_src').AsInteger := askue_src;
  DM.OQ.ParamByName('inter_type').AsInteger := inter_type;
  DM.OQ.ParamByName('ser_num').AsString := Trim(IntToStr(StrToInt(ser_num)));
  DM.OQ.ParamByName('val_date').AsDate := val_date;
  DM.OQ.ParamByName('val_num').AsWord := val_num; 
  DM.OQ.Open;
 except
  begin
    DM.OQ.Close;
	 Exit;
  end;
 end;

  if DM.OQ.FieldByName('c_id').AsInteger = 0 then 
	begin
	 try
		DM.OSQL.SQL.Clear;
		DM.OSQL.SQL.Add('INSERT INTO ' +
		DM.OS.Schema + '.sch_val(roll, askue_src, inter_type, ser_num, val_date, sch_val1, sch_val2, sch_val3, sch_stat_ext, val_num) ' +
		'VALUES(:roll, :askue_src, :inter_type, :ser_num, :val_date, :sch_val1, :sch_val2, :sch_val3, :sch_stat_ext, :val_num)');
		DM.OSQL.ParamByName('roll').AsInteger := roll;
		DM.OSQL.ParamByName('askue_src').AsInteger := askue_src;
		DM.OSQL.ParamByName('inter_type').AsInteger := inter_type;
		DM.OSQL.ParamByName('ser_num').AsString := Trim(IntToStr(StrToInt(ser_num)));
		DM.OSQL.ParamByName('val_date').AsDate := val_date;
		DM.OSQL.ParamByName('sch_val1').AsFloat := sch_val1;
		DM.OSQL.ParamByName('sch_val2').AsFloat := sch_val2;
		DM.OSQL.ParamByName('sch_val3').AsFloat := sch_val3;
		DM.OSQL.ParamByName('sch_stat_ext').AsWord := sch_stat_ext;
		DM.OSQL.ParamByName('val_num').AsWord := val_num;
		DM.OSQL.Execute;
	 except
	  begin
		 DM.OQ.Close;
		 Exit;
		 //RzMTest.Lines.Add('������ � ������. �������� �����: ' + Trim(IntToStr(StrToInt(ser_num))));
	  end;//except
	 end;//try
  end;
  DM.OQ.Close;
End;

// ������� ������ ������
procedure TFMain.AFlushBaseExecute(Sender: TObject);
begin
  BaseCnt := 5; // ����� ������ ��������� ���������
  BaseCur := 0;
  OutBuf[0] := $09;
  OutBuf[1] := $03;
  OutBuf[2] := BaseCur;
  RidThreadStart;
end;

procedure TFMain.FormActivate(Sender: TObject);
begin
  ShowMessagePos('�������� COM-���� � �������� ���������� ����� � ������� �����',FMain.Left - 20,FMain.Top + 100);
end;

procedure TFMain.TimerTimer(Sender: TObject);
begin
 Timer.Enabled := false;
end;

end.
