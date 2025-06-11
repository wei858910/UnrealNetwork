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

    UPROPERTY(BindWidget)
    UScrollBox ScrollBox_Chat;

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
        AMyCharacter MyCharacter = Cast<AMyCharacter>(Gameplay::GetPlayerCharacter(0));
        if (!IsValid(MyCharacter))
            return;
        MyCharacter.SetPlayerNameAndGroup(ETB_NickName.GetText().ToString(), ETB_Clan.GetText().ToString());
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

    void PushChatMessage(EChatChannel Channel, FString Message)
    {
        if (!IsValid(ScrollBox_Chat))
            return;

        auto PC = Cast<AMyPlayerController>(Gameplay::GetPlayerController(0));
        if (!IsValid(PC))
            return;

        FLinearColor Color = PC.GetColorByChatChannel(Channel);
        FName        ChannelName = PC.GetNameByChatChannel(Channel);

        UTextBlock TextBlock = Cast<UTextBlock>(NewObject(ScrollBox_Chat, UTextBlock));
        if (!IsValid(TextBlock))
            return;

        switch (Channel)
        {

            case EChatChannel::ECC_World:
            case EChatChannel::ECC_Group:
            {
                TextBlock.SetColorAndOpacity(Color);
                FText Text = FText::FromString(FString::Format("[{0}]: {1}", ChannelName.ToString(), Message));
                TextBlock.SetText(Text);
                ScrollBox_Chat.AddChild(TextBlock);
            }
            break;
            case EChatChannel::ECC_Private:
            {
            }
            break;
        }
    }
};