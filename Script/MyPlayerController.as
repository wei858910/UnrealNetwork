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
            FString PlayerName = GetPlayerName();
            FString PlayerGroup = GetPlayerGroup();
            FString NewMessage = FString::Format("{0}:{1}", PlayerName, Message);

            switch (Channel)
            {
                case EChatChannel::ECC_World:
                    MyGameState.MultiSendMessage(Channel, NewMessage);
                    break;
                case EChatChannel::ECC_Group:
                {
                    for (auto PS : MyGameState.PlayerArray)
                    {
                        AMyPlayerState MyPlayerState = Cast<AMyPlayerState>(PS.Get());
                        if (IsValid(MyPlayerState))
                        {
                            if (MyPlayerState.PlayerGroup == PlayerGroup)
                            {
                                AMyPlayerController MyPlayerController = Cast<AMyPlayerController>(MyPlayerState.Pawn.GetInstigatorController());
                                if (IsValid(MyPlayerController))
                                {
                                    MyPlayerController.ClientSendMessage(Channel, NewMessage);
                                }
                            }
                        }
                    }
                }
                break;
                case EChatChannel::ECC_Private:
                    break;
            }
        }
    }

    UFUNCTION(Client)
    void ClientSendMessage(EChatChannel Channel, FString Message)
    {
        AMyHUD MyHUD = Cast<AMyHUD>(GetHUD());
        if (IsValid(MyHUD))
        {
            MyHUD.PushMessage(Channel, Message);
        }
    }

    FString GetPlayerName()
    {
        AMyPlayerState MyPlayerState = Cast<AMyPlayerState>(PlayerState);
        if (IsValid(MyPlayerState))
            return MyPlayerState.PlayersName;

        return "";
    }

    FString GetPlayerGroup()
    {
        AMyPlayerState MyPlayerState = Cast<AMyPlayerState>(PlayerState);
        if (IsValid(MyPlayerState))
            return MyPlayerState.PlayerGroup;
        return "";
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

    FLinearColor GetColorByChatChannel(EChatChannel Channel)
    {
        switch (Channel)
        {
            case EChatChannel::ECC_World:
                return FLinearColor::Blue;
            case EChatChannel::ECC_Group:
                return FLinearColor::Yellow;
            case EChatChannel::ECC_Private:
                return FLinearColor::Purple;
        }
    }

    FName GetNameByChatChannel(EChatChannel Channel)
    {
        switch (Channel)
        {
            case EChatChannel::ECC_World:
                return n"世界";
            case EChatChannel::ECC_Group:
                return n"队伍";
            case EChatChannel::ECC_Private:
                return n"私聊";
        }
    }
};