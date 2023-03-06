unit uTeste;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, Vcl.Controls,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl, IWCompEdit,
  IWCompButton, IWVCLComponent, IWBaseLayoutComponent, IWBaseContainerLayout,
  IWContainerLayout, IWTemplateProcessorHTML;

type
  TF_Teste = class(TIWAppForm)
    IWEditTeste: TIWEdit;
    IWBUTTONTESTE: TIWButton;
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    IWBUTTONACAO: TIWButton;
    procedure IWBUTTONACAOAsyncClick(Sender: TObject; EventParams: TStringList);
  public
  end;

implementation

{$R *.dfm}


procedure TF_Teste.IWBUTTONACAOAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  IWEditTeste.Enabled := true;
  IWEditTeste.SetFocus;
end;

end.
