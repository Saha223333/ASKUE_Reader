program askue;

uses
  Forms,
  u_main in 'u_main.pas' {FMain},
  u_data in '..\askue_kem\u_data.pas' {DM: TDataModule},
  u_tu_find in 'u_tu_find.pas' {FTUFind},
  u_sch_edit in 'u_sch_edit.pas' {FSchEdit},
  u_chng_num in 'u_chng_num.pas' {FChngNum},
  u_no_check_print in 'u_no_check_print.pas' {FNoCheckPrint},
  u_stat_ray_print in 'u_stat_ray_print.pas' {FStatRayPrint},
  u_rep_stat_uch in 'u_rep_stat_uch.pas' {FRepStatUch},
  u_start in 'u_start.pas' {StartForm},
  u_progress in 'u_progress.pas' {LoadForm},
  UImport in 'UImport.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TStartForm, StartForm);
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFTUFind, FTUFind);
  Application.CreateForm(TFSchEdit, FSchEdit);
  Application.CreateForm(TFChngNum, FChngNum);
  Application.CreateForm(TFNoCheckPrint, FNoCheckPrint);
  Application.CreateForm(TFStatRayPrint, FStatRayPrint);
  Application.CreateForm(TFRepStatUch, FRepStatUch);
  Application.CreateForm(TLoadForm, LoadForm);
  Application.Run;
end.
