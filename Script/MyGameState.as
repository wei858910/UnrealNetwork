class AMyGameState : AGameState
{

    UFUNCTION(NetMulticast)
    void MultiSendMessage(EChatChannel Channel, FString Message)
    {
        auto PlayerCotnroller = Cast<APlayerController>(Gameplay::GetPlayerController(0));
        if (!IsValid(PlayerCotnroller))
            return;

        auto MyHUD = Cast<AMyHUD>(PlayerCotnroller.GetHUD());
        if (!IsValid(MyHUD))
            return;
        MyHUD.PushMessage(Channel, Message);
    }
};