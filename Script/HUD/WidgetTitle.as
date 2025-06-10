class UWidgetTitle : UUserWidget
{
	UPROPERTY(BindWidget)
	UTextBlock Clan;

	UPROPERTY(BindWidget)
	UTextBlock NickName;
    
	UFUNCTION(BlueprintOverride)
	void Construct()
	{
	}
};