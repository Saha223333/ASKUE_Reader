unit u_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzSplit, RzGroupBar, RzStatus, ExtCtrls, RzPanel, Grids,
  DBGridEh, RzButton, u_data, RzBckgnd, StdCtrls, RzLabel, XPMan, ImgList,
  ActnList, Mask, RzEdit, RzDBEdit, ComCtrls, RzLaunch, DB, DBTables, u_tu_find,
  RzCommon, RzForms, RzRadChk, StrUtils, frxClass, frxDBSet, frxExportXLS,
  RzSpnEdt, u_no_check_print, DBCtrls, RzDBCmbo, u_stat_ray_print, GridsEh,
  frxExportXML, frxExportRTF, RzRadGrp, UImport, Ora;

type
  TFMain = class(TForm)
    RzSB: TRzStatusBar;
    RzClockStatus1: TRzClockStatus;
    RzGB: TRzGroupBar;
    RzPanel1: TRzPanel;
    RzGroup1: TRzGroup;
    RzGroup2: TRzGroup;
    RzGroup3: TRzGroup;
    RzBitBtn1: TRzBitBtn;
    DBGridEhSchVal: TDBGridEh;
    DBGridEhAskueSrc: TDBGridEh;
    RzBitBtn2: TRzBitBtn;
	 DBGridEhRoll: TDBGridEh;
    RzBitBtn5: TRzBitBtn;
    RzLabel1: TRzLabel;
    RzSeparator1: TRzSeparator;
    XPM: TXPManifest;
    AL: TActionList;
    AGetRoll: TAction;
    IL: TImageList;
	 AExit: TAction;
    AAddSchVal: TAction;
    DTPRoll: TDateTimePicker;
    RzL: TRzLauncher;
    ATUFind: TAction;
    ATUFindParam: TAction;
    RzFormState1: TRzFormState;
    RzRegIniFile1: TRzRegIniFile;
    RzLabel2: TRzLabel;
    RzSeparator2: TRzSeparator;
    RzCheckBox1: TRzCheckBox;
    RzCheckBox2: TRzCheckBox;
    RzCheckBox3: TRzCheckBox;
    RzCheckBox4: TRzCheckBox;
    RzCheckBox5: TRzCheckBox;
    RzCheckBox6: TRzCheckBox;
    RzCheckBox7: TRzCheckBox;
    RzCheckBox8: TRzCheckBox;
    RzBitBtn3: TRzBitBtn;
    APrintList: TAction;
    ASetListFilter: TAction;
    frxDBDSList: TfrxDBDataset;
    RzLabel3: TRzLabel;
    RzCheckBox9: TRzCheckBox;
    RNEStat: TRzNumericEdit;
    ANoCheckPrint: TAction;
    RzSPRecCount: TRzStatusPane;
    frxRList: TfrxReport;
    RzDBLCBTypeSch: TRzDBLookupComboBox;
    RzCheckBox10: TRzCheckBox;
    RzLabel4: TRzLabel;
    AStatRayPrint: TAction;
    frxXLSExport1: TfrxXLSExport;
    RzBitBtn4: TRzBitBtn;
    BQRKChoice: TRzRadioGroup;
    SD: TSaveDialog;
    procedure AExitExecute(Sender: TObject);
    procedure DTPRollChange(Sender: TObject);
    procedure AGetRollExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RzLFinished(Sender: TObject);
    procedure AAddSchValExecute(Sender: TObject);
    procedure ATUFindExecute(Sender: TObject);
    procedure ATUFindParamExecute(Sender: TObject);
	 procedure DBGridEhSchValKeyDown(Sender: TObject; var Key: Word;
		Shift: TShiftState);
    procedure APrintListExecute(Sender: TObject);
	 procedure ANoCheckPrintExecute(Sender: TObject);
    procedure RzDBLCBTypeSchCloseUp(Sender: TObject);
	 procedure AStatRayPrintExecute(Sender: TObject);
	 procedure RzBitBtn4Click(Sender: TObject);
	 function ClearRoll(NewRoll:integer):boolean;
	 procedure Raznoska(ImportThread: TImportThread);
	 procedure SetListFilter(Q: TOraQuery);
	 procedure ShowRecordCount(RecCount: integer);

  private
	 { Private declarations }
	 
  public
	 { Public declarations }
	 
  end;
  {
 TImportThread = class(TThread)
  public 
	 FN:string;//имя файла лога
  private            
  protected
	 procedure Execute; override;
	 procedure blabla;
  end;
 }
var
  FMain: TFMain;
  

implementation

uses U_Rep_Stat_Uch, u_progress;

{$R *.dfm}
{
procedure TImportThread.Execute;
var
 inter_type:integer;
 val_date,ser_num:string;
 sch_val1,val_num:integer; 
 NewRoll: Integer;
 MyLaunch: TRzLauncher;
 StringList: TStrings;

begin
  FMain.DTPRoll.Date := Date;
  DM.OQRoll.ParamByName('roll_date').AsDate := FMain.DTPRoll.Date;
  DM.OQRoll.Refresh;
//источник МТерминал

if DM.OTAskueSrc.FieldByName('id').AsInteger=3 then
 begin
	DM.OSPRoll.StoredProcName := 'askue.askue_proc.get_roll_id';
	DM.OSPRoll.Execute;
	NewRoll := DM.OSPRoll.ParamByName('result').AsInteger;

  DM.OSQLRoll.SQL.Clear;
  DM.OSQLRoll.SQL.Add('INSERT INTO askue.roll(id, roll_date, askue_src) VALUES(:id, :roll_date, 3)');
  DM.OSQLRoll.ParamByName('id').AsInteger := NewRoll;
  DM.OSQLRoll.ParamByName('roll_date').AsDate := FMain.DTPRoll.Date;
  DM.OSQLRoll.Execute;
  DM.OQRoll.Refresh;
  DM.OQRoll.Locate('id', NewRoll, [loCaseInsensitive]);

  DM.OS.Commit;	 
  //RzL.FileName :='C:\MTerminal\NetUse.bat';
  //RzL.Launch;

  FMain.RzL.FileName := DM.OTAskueSrc.FieldByName('ext_mod').AsString;
  FMain.RzL.Launch;
	
// ============= Реестр пустой ? =============
  DM.OQ.SQL.Clear;
  DM.OQ.SQL.Add('SELECT count(id) c_id FROM askue.sch_val WHERE roll = :roll');
  DM.OQ.ParamByName('roll').AsInteger := NewRoll;
  DM.OQ.Open;
  if DM.OQ.FieldByName('c_id').AsInteger = 0 then 
	begin
	 DM.OSQL.SQL.Clear;
	 DM.OSQL.SQL.Add('DELETE FROM askue.roll WHERE id = :roll');
	 DM.OSQL.ParamByName('roll').AsInteger := NewRoll;
	 DM.OSQL.Execute;
	 DM.OS.Commit;
	 DM.OQRoll.Refresh;
  end;  
 end;

//источник Ридер
if  DM.OTAskueSrc.FieldByName('id').AsInteger=1 then
 begin
  DM.OSPRoll.StoredProcName := 'askue.askue_proc.get_roll_id';
  DM.OSPRoll.Execute;
  NewRoll := DM.OSPRoll.ParamByName('result').AsInteger;
  DM.OSQLRoll.SQL.Clear;
  DM.OSQLRoll.SQL.Add('INSERT INTO askue.roll(id, roll_date, askue_src) VALUES(:id, :roll_date, :askue_src)');
  DM.OSQLRoll.ParamByName('id').AsInteger := NewRoll;
  DM.OSQLRoll.ParamByName('roll_date').AsDate := FMain.DTPRoll.Date;
  DM.OSQLRoll.ParamByName('askue_src').AsInteger := DM.OTAskueSrc.FieldByName('id').AsInteger;
  DM.OSQLRoll.Execute;
  DM.OQRoll.Refresh;
  DM.OQRoll.Locate('id', NewRoll, [loCaseInsensitive]);

  DM.OS.Commit;
  StringList := TStringList.Create;
  //создаём файл лога с именем по номеру реестра и временем  
  FN :=  'logs\' + IntToStr(NewRoll) + '_'+ DateToStr(FMain.DTPRoll.Date) + '.txt';
  //ImportThread.FNList.Add(FN); 
  StringList.SaveToFile(FN);

  MyLaunch:=TRzLauncher.Create(FMain);
  //MyLaunch.Parameters := FN;
  MyLaunch.WaitType :=  wtFullStop;
  MyLaunch.WaitUntilFinished :=true;
  MyLaunch.FileName := DM.OTAskueSrc.FieldByName('ext_mod').AsString;
  MyLaunch.Parameters := DM.OS.Server + ' "' +
						  DM.OS.Username + '" "' +
						  DM.OS.Password + '" ' +
						  IntToStr(NewRoll) + ' ' +
						  DM.OTAskueSrc.FieldByName('id').AsString + ' ' + ImportThread.FN;
	 MyLaunch.Launch;
	 if FMain.ClearRoll(NewRoll) = true then Exit;
	end;

Synchronize(blabla);//фильтры
//FMain.RzCheckBox7.Checked := false;
//FMain.RzCheckBox1.Checked := true;
//FMain.RzCheckBox8.Checked := true;
//FMain.ASetListFilter.Execute;//применяем фильтры
//FMain.RzBitBtn5.Click;       //разноска

//FMain.RzCheckBox6.Checked := true;
//FMain.RzCheckBox7.Checked := false;
//FMain.RzCheckBox1.Checked := false;
//FMain.RzCheckBox8.Checked := false;
//FMain.ASetListFilter.Execute;
//ShowMessage('Разнесено в биллинг показаний: '+ IntToStr(DM.OQSchVal.RecordCount));
//LoadForm.Close;
end;

procedure TImportThread.blabla;
begin
 DM.OQSchVal.Refresh;
 FMain.RzCheckBox7.Checked := false;
 FMain.RzCheckBox1.Checked := true;
 FMain.RzCheckBox8.Checked := true;
 FMain.ASetListFilter.Execute;//применяем фильтры
 DM.OQSchVal.Refresh;
 FMain.RzBitBtn5.Click;       //разноска
 
 FMain.RzCheckBox6.Checked := true;
 FMain.RzCheckBox7.Checked := false;
 FMain.RzCheckBox1.Checked := false;
 FMain.RzCheckBox8.Checked := false;
 FMain.ASetListFilter.Execute;

ShowMessage('Разнесено в биллинг показаний: '+ IntToStr(DM.OQSchVal.RecordCount));
LoadForm.Close;
end;
 }
function TFMain.ClearRoll(NewRoll:integer):boolean;
begin
result := false;

  // ============= Реестр пустой ? =============
  DM.OQ.SQL.Clear;
  DM.OQ.SQL.Add('SELECT count(id) c_id FROM askue.sch_val WHERE roll = :roll');
  DM.OQ.ParamByName('roll').AsInteger := NewRoll;
  DM.OQ.Open;
  if DM.OQ.FieldByName('c_id').AsInteger = 0 then 
	begin
	 DM.OSQL.SQL.Clear;
	 DM.OSQL.SQL.Add('DELETE FROM askue.roll WHERE id = :roll');
	 DM.OSQL.ParamByName('roll').AsInteger := NewRoll;
	 DM.OSQL.Execute;
	 DM.OS.Commit;
	 DM.OQRoll.Refresh;
	 ShowMessage('Реестр пустой!');
	 
	 result := true;
	end;
end;

procedure TFMain.AExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFMain.DTPRollChange(Sender: TObject);
begin
  DM.OQRoll.ParamByName('roll_date').AsDate := DTPRoll.Date;
  DM.OQRoll.Refresh;
end;

procedure TFMain.AGetRollExecute(Sender: TObject);
var 
 ImportThread: TImportThread;

begin
 ImportThread:=TImportThread.Create(true);
 ImportThread.FreeOnTerminate:=true;
 ImportThread.Priority:=tpNormal;
 ImportThread.Resume;
end;

procedure TFMain.ShowRecordCount(RecCount: integer);
begin
  ShowMessage('Разнесено в биллинг показаний: '+ IntToStr(RecCount));
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  //DTPRoll.Date := Date;
  //DM.OQRoll.ParamByName('roll_date').AsDate := DTPRoll.Date;
  //DM.OQRoll.Refresh;
  
end;

procedure TFMain.RzLFinished(Sender: TObject);
begin
  DM.OQSchVal.Refresh;
end;

procedure TFMain.Raznoska (ImportThread: TImportThread);
var        //создаёт форму и передаёт в поток
  LoadForm: TLoadForm;

begin
 ImportThread.Suspend;//приостанавливаем поток чтобы создать форму прогресса

 LoadForm:= TLoadForm.Create(Application);
 LoadForm.FN:= ImportThread.FN;
 LoadForm.pb.PartsComplete:= 0;
 
 LoadForm.Caption:= 'Разноска показаний ';
 LoadForm.Show;

 ImportThread.LF:=LoadForm;
 //ImportThread.Raznoska;
 ImportThread.Resume;//возобновляем поток для разноски показаний
end;

procedure TFMain.AAddSchValExecute(Sender: TObject);
begin
// Raznoska;
end;

procedure TFMain.ATUFindExecute(Sender: TObject);
begin
  FTUFind.sFind := '';
  FTUFind.Show;
end;

procedure TFMain.ATUFindParamExecute(Sender: TObject);
var
  id: Integer;
begin
  if DM.OQSchVal.FieldByName('sch_ls').AsInteger = -1 then begin
	 FTUFind.sFind := DM.OQSchVal.FieldByName('ser_num').AsString;
	 FTUFind.ShowModal;
	 id := DM.OQSchVal.FieldByName('id').AsInteger;
	 DM.OQSchVal.Refresh;
	 DM.OQSchVal.Locate('id', id, [loCaseInsensitive])
  end;
end;

procedure TFMain.DBGridEhSchValKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = $0D then begin
    ATUFindParam.Execute;
  end;
end;

procedure TFMain.SetListFilter(Q: TOraQuery);
var
  FilterStr: Array[1..8] of String;
  FilterGrp: Array[1..3] of String;
  i: Integer;
  SumFilter: String;

begin
  Q.Filtered:= false;

  if RzCheckBox1.Checked then
	 FilterStr[1] := 'sch_ls <> -1'
  else
	 FilterStr[1] := '';

  if RzCheckBox2.Checked then
    FilterStr[2] := 'sch_ls = -1'
  else
	 FilterStr[2] := '';

  if RzCheckBox3.Checked then
	 FilterStr[3] := 'add_val_step = 0'
  else
    FilterStr[3] := '';

  if RzCheckBox4.Checked then
	 FilterStr[4] := 'add_val_step = 1'
  else
    FilterStr[4] := '';

  if RzCheckBox5.Checked then
	 FilterStr[5] := 'add_val_step = 2'
  else
    FilterStr[5] := '';

  if RzCheckBox6.Checked then
    FilterStr[6] := 'add_val_step = 3'
  else
	 FilterStr[6] := '';

  if RzCheckBox7.Checked then
    FilterStr[7] := 'val_num = 0'
  else
    FilterStr[7] := '';

  if RzCheckBox8.Checked then
	 FilterStr[8] := 'val_num = 1'
  else
    FilterStr[8] := '';

  FilterGrp[1] := '';
  for i := 1 to 2 do begin
	 if FilterStr[i] <> '' then FilterGrp[1] := FilterGrp[1] + FilterStr[i] + ' or ';
  end;
  if FilterGrp[1] <> '' then begin
    FilterGrp[1] := '(' + LeftStr(FilterGrp[1], Length(FilterGrp[1]) - 4) + ')';
  end;

  FilterGrp[2] := '';
  for i := 3 to 6 do begin
    if FilterStr[i] <> '' then FilterGrp[2] := FilterGrp[2] + FilterStr[i] + ' or ';
  end;
  if FilterGrp[2] <> '' then begin
    FilterGrp[2] := '(' + LeftStr(FilterGrp[2], Length(FilterGrp[2]) - 4) + ')';
  end;

  FilterGrp[3] := '';
  for i := 7 to 8 do begin
	 if FilterStr[i] <> '' then FilterGrp[3] := FilterGrp[3] + FilterStr[i] + ' or ';
  end;
  if FilterGrp[3] <> '' then begin
    FilterGrp[3] := '(' + LeftStr(FilterGrp[3], Length(FilterGrp[3]) - 4) + ')';
  end;

  SumFilter := '';
  for i := 1 to 3 do begin
	 if FilterGrp[i] <> '' then SumFilter := SumFilter + FilterGrp[i] + ' and ';
  end;

  if SumFilter <> '' then begin
	 SumFilter := LeftStr(SumFilter, Length(SumFilter) - 5);
  end;

// ========== Для статуса ==========
  if RzCheckBox9.Checked then begin
	 if SumFilter = '' then
		SumFilter := SumFilter + '(sch_stat_ext = ' + RNEStat.Text + ')'
	 else
		SumFilter := SumFilter + ' and (sch_stat_ext = ' + RNEStat.Text + ')';
	 RNEStat.Enabled := false;
  end else
	 RNEStat.Enabled := true;

// ========== Для типа сч-ка ==========
  if RzCheckBox10.Checked then begin
	 if SumFilter = '' then
		SumFilter := SumFilter + '(inter_type = ' + IntToStr(RzDBLCBTypeSch.KeyValue) + ')'
	 else
		SumFilter := SumFilter + ' and (inter_type = ' + IntToStr(RzDBLCBTypeSch.KeyValue) + ')';
	 RzDBLCBTypeSch.Enabled := false;
  end else
	 RzDBLCBTypeSch.Enabled := true;

  Q.Filter:= SumFilter;
  Q.Filtered:= true;
end;

procedure TFMain.APrintListExecute(Sender: TObject);
begin
  frxRList.LoadFromFile(copy(application.ExeName,1,pos('\askue.exe',application.ExeName)-1)+'\rep\list.fr3',true);
  frxRList.ShowReport;
end;

procedure TFMain.ANoCheckPrintExecute(Sender: TObject);
begin
  FNoCheckPrint.ShowModal;
end;

procedure TFMain.RzDBLCBTypeSchCloseUp(Sender: TObject);
begin
  if RzDBLCBTypeSch.KeyValue <> null then
    RzCheckBox10.Enabled := true
  else
    RzCheckBox10.Enabled := false;
end;

procedure TFMain.AStatRayPrintExecute(Sender: TObject);
begin
  FRepStatUch.ShowModal;
end;

procedure TFMain.RzBitBtn4Click(Sender: TObject);
begin
showmessage('Исправлен отчет по неопрошенным учетам. Добавлено получение показаний с мобильного терминала');
end;

end.
