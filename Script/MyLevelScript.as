class AMyLevelScript : ALevelScriptActor
{
    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        System::ExecuteConsoleCommand("r.setRes 800x600w");
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        // auto GameMode = Gameplay::GetGameMode();
        // if (IsValid(GameMode))
        // {
        //     Print("获取GameMode成功 !!!");
        // }
        // else
        // {
        //     Print("获取GameMode失败!!!");
        // }
    }
};