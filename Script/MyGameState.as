class AMyGameState : AGameState
{
    
    UFUNCTION(NetMulticast)
    void MultiSendMessage(EChatChannel Channel, FString Message)
    {
        switch (Channel)
        {
            case EChatChannel::ECC_World:
                Print(f"{Channel}: {Message}");
                break;
            case EChatChannel::ECC_Group:
                break;
            case EChatChannel::ECC_Private:
                break;
        }
    }
};