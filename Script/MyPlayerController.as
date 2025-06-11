class AMyPlayerController : APlayerController
{
    void SendMessage(EChatChannel Channel, FString Message)
    {
        ServerSendMessage(Channel, Message);
    }

    UFUNCTION(Server)
    void ServerSendMessage(EChatChannel Channel, FString Message)
    {
        AMyGameState MyGameState = Cast<AMyGameState>(Gameplay::GetGameState());
        if (IsValid(MyGameState))
        {
            switch (Channel)
            {
                case EChatChannel::ECC_World:
                    MyGameState.MultiSendMessage(Channel, Message);
                    break;
                case EChatChannel::ECC_Group:
                    break;
                case EChatChannel::ECC_Private:
                    break;
            }
        }
    }

    EChatChannel GetChatChanellByString(FString Channel)
    {
        if (Channel == "世界")
            return EChatChannel::ECC_World;
        if (Channel == "队伍")
            return EChatChannel::ECC_Group;
        if (Channel == "私聊")
            return EChatChannel::ECC_Private;
        return EChatChannel::ECC_World;
    }
};