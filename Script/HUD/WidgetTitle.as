class UWidgetTitle : UUserWidget
{
	UPROPERTY(BindWidget)
	UTextBlock BH;

	UPROPERTY(BindWidget)
	UTextBlock NC;
    
	UFUNCTION(BlueprintOverride)
	void Construct()
	{
	}
};