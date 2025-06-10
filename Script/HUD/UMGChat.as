class UUMGChat : UUserWidget
{
    UPROPERTY(BindWidget)
    UEditableTextBox ETB_NickName;

    UPROPERTY(BindWidget)
    UEditableTextBox ETB_Clan;

    UPROPERTY(BindWidget)
    UButton Btn_Submit;

    UPROPERTY(BindWidget)
    UEditableText ET_Chat;

    UPROPERTY(BindWidget)
    UComboBoxString CBS_Channel;

    UFUNCTION(BlueprintOverride)
    void Construct()
    {
        Btn_Submit.OnClicked.AddUFunction(this, n"OnBtnSubmitClicked");
        ET_Chat.OnTextCommitted.AddUFunction(this, n"OnTextCommitted");

        CBS_Channel.AddOption("世界");
        CBS_Channel.AddOption("队伍");
        CBS_Channel.AddOption("私聊");
        CBS_Channel.SelectedIndex = 0;
    }

    UFUNCTION()
    private void OnBtnSubmitClicked()
    {
    }

    UFUNCTION()
    private void OnTextCommitted(const FText&in Text, ETextCommit CommitMethod)
    {
        AMyPlayerController MyPlayerController = Cast<AMyPlayerController>(Gameplay::GetPlayerController(0));
        if (CommitMethod == ETextCommit::OnEnter)
        {
            Print(f"Text: {Text}");
            if (IsValid(MyPlayerController))
            {
                MyPlayerController.SendMessage(MyPlayerController.GetChatChanellByString(CBS_Channel.GetSelectedOption()), Text.ToString());
            }
        }
    }
};