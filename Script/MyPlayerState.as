class AMyPlayerState : APlayerState
{
    FString PlayersName;
    FString PlayerGroup;

    void SetPlayerNameAndGroup(FString NameOfPlayer, FString Group)
    {
        PlayersName = NameOfPlayer;
        PlayerGroup = Group;
    }
};