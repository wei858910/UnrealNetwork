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
            FString NewMessage = FString::Format("{0}:{1} {2}", PlayerGroup, PlayerName, Message);
            MyGameState.MultiSendMessage(Channel, NewMessage);
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