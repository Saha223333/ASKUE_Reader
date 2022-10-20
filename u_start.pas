unit u_start;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, u_main;

type
  TStartForm = class(TForm)
    GetReader: TRzBitBtn;
    GetTerminal: TRzBitBtn;
    RzBitBtn1: TRzBitBtn;
	 procedure GetReaderClick(Sender: TObject);
    procedure GetTerminalClick(Sender: TObject);
    procedure RzBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StartForm: TStartForm;

implementation

uses u_data, u_no_check_print;

{$R *.dfm}

procedure TStartForm.GetReaderClick(Sender: TObject);
begin
 DM.OTAskueSrc.Edit;
 DM.OTAskueSrc.FieldByName('id').AsInteger:=1;
 FMain.RzBitBtn2.Click;
end;

procedure TStartForm.GetTerminalClick(Sender: TObject);
begin
 DM.OTAskueSrc.Edit;
 DM.OTAskueSrc.FieldByName('id').AsInteger:=3;
 FMain.RzBitBtn2.Click;
end;

procedure TStartForm.RzBitBtn1Click(Sender: TObject);
begin
 FNoCheckPrint.ShowModal;
end;

end.

