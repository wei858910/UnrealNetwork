class AMyGameMode : AGameMode
{
    default DefaultPawnClass = AMyCharacter;
    default GameSessionClass = AMyGameSession;
    default GameStateClass = AMyGameState;
    default PlayerControllerClass = AMyPlayerController;
    default PlayerStateClass = AMyPlayerState;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
    }
};