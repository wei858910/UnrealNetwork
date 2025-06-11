class AMyHUD : AHUD
{
    UUMGChat ChatUI;

    bool bToggleChatUI = true;

    UUMGChat GetChatUI()
    {
        if (!IsValid(ChatUI))
        {
            APlayerController PlayerController = Cast<APlayerController>(GetOwningPlayerController());
            UClass            UmgChatClass = Cast<UClass>(LoadObject(nullptr, "/Game/HUD/BP_UMGChat.BP_UMGChat_C"));
            if (!IsValid(UmgChatClass))
                return nullptr;
            ChatUI = Cast<UUMGChat>(WidgetBlueprint::CreateWidget(UmgChatClass, PlayerController));
        }

        return ChatUI;
    }

    void ToggleChatUI()
    {
        GetChatUI();
        APlayerController PlayerController = Cast<APlayerController>(GetOwningPlayerController());
        if (!IsValid(PlayerController))
            return;

        if (bToggleChatUI)
        {
            bToggleChatUI = false;
            if (IsValid(ChatUI))
            {
                ChatUI.AddToViewport();
                PlayerController.bShowMouseCursor = true;
            }
        }
        else
        {
            bToggleChatUI = true;
            if (IsValid(ChatUI))
            {
                ChatUI.RemoveFromParent();
                PlayerController.bShowMouseCursor = false;
            }
        }
    }

    void PushMessage(EChatChannel Channel, FString Message)
    {
        if (!IsValid(ChatUI))
            return;
        ChatUI.PushChatMessage(Channel, Message);
    }
};