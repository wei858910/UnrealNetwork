class UUMGChat : UUserWidget
{
    UPROPERTY(BindWidget)
    UEditableTextBox ETB_NickName;

    UPROPERTY(BindWidget)
    UEditableTextBox ETB_Clan;

    UPROPERTY(BindWidget)
    UButton Btn_Submit;

    UFUNCTION(BlueprintOverride)
    void Construct()
    {
        Btn_Submit.OnClicked.AddUFunction(this, n"OnBtnSubmitClicked");
    }

    UFUNCTION()
    private void OnBtnSubmitClicked()
    {
    }
};