unit u_no_check_print;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, ActnList, ImgList, RzForms, RzRadChk, DBCtrls,
  RzDBCmbo, StdCtrls, RzLabel, Mask, RzEdit, ComCtrls, RzBckgnd, frxClass,
  u_data, frxDBSet, frxVariables, frxExportXLS;

type
  TFNoCheckPrint = class(TForm)
    RzFormState1: TRzFormState;
    IL: TImageList;
    AL: TActionList;
    AExit: TAction;
    RzBitBtn1: TRzBitBtn;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzDBLCBAskueSrc: TRzDBLookupComboBox;
    RzDBLCBUchastok: TRzDBLookupComboBox;
    RzLabel3: TRzLabel;
    DateTimePicker1: TDateTimePicker;
    RzSeparator1: TRzSeparator;
    APrint: TAction;
    RzBitBtn2: TRzBitBtn;
    frxDBDataset1: TfrxDBDataset;
    frxRNoCheckPrint: TfrxReport;
    procedure AExitExecute(Sender: TObject);
    procedure APrintExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FNoCheckPrint: TFNoCheckPrint;

implementation

{$R *.dfm}

uses
  u_main;

procedure TFNoCheckPrint.AExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFNoCheckPrint.APrintExecute(Sender: TObject);
begin
  if (RzDBLCBAskueSrc.KeyValue = null) or
     (RzDBLCBUchastok.KeyValue = null) then begin
  ShowMessage('?? ??????? ???????????? ?????????!');
  end else begin

    DM.OQNoCheckPrint.Close;
    DM.OQNoCheckPrint.ParamByName('askue_src').AsInteger := RzDBLCBAskueSrc.KeyValue;
	 DM.OQNoCheckPrint.ParamByName('otd').AsInteger := FMain.RzRegIniFile1.ReadInteger('Sets', 'Otd', 1);;
	 DM.OQNoCheckPrint.ParamByName('uchastok').AsInteger := RzDBLCBUchastok.KeyValue;
    DM.OQNoCheckPrint.ParamByName('dnd').AsDate := DateTimePicker1.Date;
    DM.OQNoCheckPrint.ParamByName('dkd').AsDate := Date;
	 DM.OQNoCheckPrint.Open;

    frxRNoCheckPrint.LoadFromFile(copy(application.ExeName,1,pos('\askue.exe',application.ExeName)-1)+'\rep\no_check_print.fr3',true);
	 frxRNoCheckPrint.Variables['DND'] := '''' +
		DateToStr(DateTimePicker1.Date) + '''';
	 frxRNoCheckPrint.PrepareReport();
    frxRNoCheckPrint.ShowReport;

    DM.OQNoCheckPrint.Close;
  end;
end;

procedure TFNoCheckPrint.FormShow(Sender: TObject);
begin
  DateTimePicker1.Date := Date - 90;
 
		// DM.OTAskueSrc.
//DM.OTAskueSrc.Edit;
//  DM.OTAskueSrc.FieldByName('id').AsInteger:=3;
end;

end.
