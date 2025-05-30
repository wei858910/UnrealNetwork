class ATestCube : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent Root;

    UMaterialInterface CubeMat = Cast<UMaterialInterface>(LoadObject(nullptr, "/Game/Mat/M_Ball.M_Ball"));

    UPROPERTY(DefaultComponent)
    UStaticMeshComponent CubeMesh;
    default CubeMesh.SetStaticMesh(Cast<UStaticMesh>(LoadObject(nullptr, "/Engine/BasicShapes/Cube.Cube")));
    default CubeMesh.SetMaterial(0, CubeMat);

    default bReplicates = true;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
    }

    void NetChangeColor()
    {
        const FVector Color = MakeRandomColor();
        if (HasAuthority())
        {
            MultiChangeColor(Color);
        }
        else
        {
            ServerChangeColor(Color);
        }
    }

    UFUNCTION(Server)
    void ServerChangeColor(FVector Color)
    {
        MultiChangeColor(Color);
    }

    UFUNCTION(NetMulticast)
    void MultiChangeColor(FVector Color)
    {
        CubeMesh.SetVectorParameterValueOnMaterials(n"Color", Color);
    }

    FVector MakeRandomColor()
    {
        int32         Seed = Math::RoundToInt(Gameplay::GetRealTimeSeconds());
        FRandomStream RandomStream(Seed);
        return FVector(RandomStream.RandRange(0.0, 1.0), RandomStream.RandRange(0.0, 1.0), RandomStream.RandRange(0.0, 1.0));
    }
};