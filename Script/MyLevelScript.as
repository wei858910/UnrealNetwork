class AMyLevelScript : ALevelScriptActor
{
    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        System::ExecuteConsoleCommand("r.setRes 800x600w"); 
    }
};