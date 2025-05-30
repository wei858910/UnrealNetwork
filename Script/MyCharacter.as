class AMyCharacter : ACharacter
{
    default Mesh.SkeletalMeshAsset = Cast<USkeletalMesh>(LoadObject(nullptr, "/Game/Characters/Mannequins/Meshes/SKM_Quinn_Simple.SKM_Quinn_Simple"));
    default Mesh.SetRelativeLocation(FVector(0.0, 0.0, -89.0));
    default Mesh.SetRelativeRotation(FRotator(0.0, 270.0, 0.0));
    default Mesh.AnimationMode = EAnimationMode::AnimationBlueprint;
    default Mesh.AnimClass = Cast<UClass>(LoadObject(nullptr, "/Game/Characters/Mannequins/Animations/ABP_Quinn.ABP_Quinn_C"));

    UPROPERTY(DefaultComponent, Category = "Camera")
    USpringArmComponent CameraBoom;
    default CameraBoom.TargetArmLength = 400.0;
    default CameraBoom.bUsePawnControlRotation = true;
    default CameraBoom.SetRelativeLocation(FVector(0.0, 0.0, 10.0));

    UPROPERTY(DefaultComponent, Attach = CameraBoom, Category = "Camera")
    UCameraComponent Camera;

    UPROPERTY(DefaultComponent, Category = "Input")
    UEnhancedInputComponent InputComponent;

    UPROPERTY(Category = "Input")
    UInputMappingContext InputMappingContext = Cast<UInputMappingContext>(LoadObject(nullptr, "/Game/ThirdPerson/Input/IMC_Default.IMC_Default"));

    UPROPERTY(Category = "Input")
    UInputAction IA_Move = Cast<UInputAction>(LoadObject(nullptr, "/Game/ThirdPerson/Input/Actions/IA_Move.IA_Move"));

    UPROPERTY(Category = "Input")
    UInputAction IA_Look = Cast<UInputAction>(LoadObject(nullptr, "/Game/ThirdPerson/Input/Actions/IA_Look.IA_Look"));

    UPROPERTY(Category = "Input")
    UInputAction IA_Jump = Cast<UInputAction>(LoadObject(nullptr, "/Game/ThirdPerson/Input/Actions/IA_Jump.IA_Jump"));

    UPROPERTY(Category = "Input")
    UInputAction IA_Test = Cast<UInputAction>(LoadObject(nullptr, "/Game/ThirdPerson/Input/Actions/IA_Test.IA_Test"));

    default bUseControllerRotationYaw = false;

    default CharacterMovement.bOrientRotationToMovement = true;

    UMaterialInterface SphereMaterial = Cast<UMaterialInterface>(LoadObject(nullptr, "/Game/Mat/M_Ball.M_Ball"));

    UPROPERTY(DefaultComponent)
    UStaticMeshComponent Sphere;
    default Sphere.SetCollisionProfileName(n"NoCollision");
    default Sphere.SetCollisionEnabled(ECollisionEnabled::NoCollision);
    default Sphere.SetRelativeLocation(FVector(0.0, 0.0, 110.0));
    default Sphere.StaticMesh = Cast<UStaticMesh>(LoadObject(nullptr, "/Engine/EditorMeshes/EditorSphere.EditorSphere"));
    default Sphere.SetRelativeScale3D(FVector(0.1, 0.1, 0.1));
    default Sphere.SetMaterial(0, SphereMaterial);

    UFUNCTION(BlueprintOverride)
    void ControllerChanged(AController OldController, AController NewController)
    {
        APlayerController PC = Cast<APlayerController>(NewController);
        if (!IsValid(PC))
            return;

        InputComponent = UEnhancedInputComponent::Create(PC);
        PC.PushInputComponent(InputComponent);
        UEnhancedInputLocalPlayerSubsystem Subsystem = UEnhancedInputLocalPlayerSubsystem::Get(PC);
        if (IsValid(Subsystem))
        {
            if (!IsValid(InputMappingContext))
                return;
            Subsystem.AddMappingContext(InputMappingContext, 0, FModifyContextOptions());
            if (IsValid(IA_Move))
            {
                InputComponent.BindAction(IA_Move, ETriggerEvent::Triggered, FEnhancedInputActionHandlerDynamicSignature(this, n"OnMove"));
            }
            if (IsValid(IA_Look))
            {
                InputComponent.BindAction(IA_Look, ETriggerEvent::Triggered, FEnhancedInputActionHandlerDynamicSignature(this, n"OnLook"));
            }
            if (IsValid(IA_Jump))
            {
                InputComponent.BindAction(IA_Jump, ETriggerEvent::Started, FEnhancedInputActionHandlerDynamicSignature(this, n"OnJump"));
                InputComponent.BindAction(IA_Jump, ETriggerEvent::Completed, FEnhancedInputActionHandlerDynamicSignature(this, n"OnStopJump"));
            }
            if (IsValid(IA_Test))
            {
                InputComponent.BindAction(IA_Test, ETriggerEvent::Started, FEnhancedInputActionHandlerDynamicSignature(this, n"OnTest"));
            }
        }
    }

    UFUNCTION()
    private void OnTest(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, const UInputAction SourceAction)
    {

        // ServerChangeSphereColor();

        // ServerChangeOtherCharacterSphereColor();

        // ChangeCubeColor();

        ServerChangeOwnSphereColor();
    }

    UFUNCTION()
    private void OnJump(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, const UInputAction SourceAction)
    {
        Jump();
    }

    UFUNCTION()
    private void OnStopJump(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, const UInputAction SourceAction)
    {
        StopJumping();
    }

    UFUNCTION()
    private void OnLook(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, const UInputAction SourceAction)
    {
        FVector2D Value = ActionValue.GetAxis2D();
        AddControllerYawInput(Value.X);
        AddControllerPitchInput(Value.Y);
    }

    UFUNCTION()
    private void OnMove(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, const UInputAction SourceAction)
    {
        FVector2D MovementVector = ActionValue.GetAxis2D();
        float     X = MovementVector.X;
        float     Y = MovementVector.Y;

        if (!IsValid(Controller))
            return;
        const FRotator YawRotation(0.0, Controller.GetControlRotation().Yaw, 0.0);

        AddMovementInput(YawRotation.RightVector, X);

        AddMovementInput(YawRotation.ForwardVector, Y);
    }

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        APlayerController PlayerController = Cast<APlayerController>(Controller);
        if (IsValid(PlayerController))
        {
            PlayerController.bShowMouseCursor = true;
            Widget::SetInputMode_GameAndUIEx(PlayerController, nullptr, EMouseLockMode::DoNotLock, false);
        }
    }

    FVector MakeRandomColor()
    {
        float R = Math::RandRange(0.0, 1.0);
        float G = Math::RandRange(0.0, 1.0);
        float B = Math::RandRange(0.0, 1.0);

        return FVector(R, G, B);
    }

    UFUNCTION(Server)
    void ServerChangeOwnSphereColor()
    {
        ClientChangeOwnSphereColor(MakeRandomColor());
    }

    UFUNCTION(Client)
    void ClientChangeOwnSphereColor(FVector Color)
    {
        Sphere.SetVectorParameterValueOnMaterials(n"Color", Color);
    }

    UFUNCTION(Server)
    void ServerChangeSphereColor()
    {
        MultiChangeSphereColor(MakeRandomColor());
    }

    UFUNCTION(NetMulticast)
    void MultiChangeSphereColor(FVector Color)
    {
        Sphere.SetVectorParameterValueOnMaterials(n"Color", Color);
    }

    UFUNCTION(Server)
    void ServerChangeOtherCharacterSphereColor()
    {
        FVector            Location = GetActorLocation();
        TArray<FHitResult> HitResults;
        TArray<AActor>     ActorsToIgnore;
        ActorsToIgnore.Add(this);
        System::SphereTraceMulti(Location, Location, 150, ETraceTypeQuery::Camera, false, ActorsToIgnore, EDrawDebugTrace::ForDuration, HitResults, true);
        for (auto Result : HitResults)
        {
            AMyCharacter Char = Cast<AMyCharacter>(Result.Actor);
            if (IsValid(Char))
            {
                Char.MultiChangeSphereColor(MakeRandomColor());
                break;
            }
        }
    }

    void ChangeCubeColor()
    {
        if (!ServerChangeCubeOwner()) // 先改变Cube的Owner，否则Client无法改变Cube的颜色
        {
            FVector            Location = GetActorLocation();
            TArray<FHitResult> HitResults;
            TArray<AActor>     ActorsToIgnore;
            ActorsToIgnore.Add(this);
            System::SphereTraceMulti(Location, Location, 150, ETraceTypeQuery::Camera, false, ActorsToIgnore, EDrawDebugTrace::ForDuration, HitResults, true);
            for (auto Result : HitResults)
            {
                ATestCube Cube = Cast<ATestCube>(Result.Actor);
                if (IsValid(Cube))
                {
                    Cube.NetChangeColor();
                    break;
                }
            }
        }
    }

    UFUNCTION(Server)
    bool ServerChangeCubeOwner()
    {
        FVector            Location = GetActorLocation();
        TArray<FHitResult> HitResults;
        TArray<AActor>     ActorsToIgnore;
        ActorsToIgnore.Add(this);
        System::SphereTraceMulti(Location, Location, 150, ETraceTypeQuery::Camera, false, ActorsToIgnore, EDrawDebugTrace::ForDuration, HitResults, true);
        for (auto Result : HitResults)
        {
            ATestCube Cube = Cast<ATestCube>(Result.Actor);
            if (IsValid(Cube))
            {
                if (Cube.Owner != GetController())
                {
                    Cube.SetOwner(GetController());
                    Cube.NetChangeColor();
                    return true;
                }
            }
        }
        return false;
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        // if (HasAuthority())
        // {
        //     FString HaveController = IsValid(Controller) ? "Server: 有Controller" : "Server: 没有Controller";
        //     System::DrawDebugString(GetActorLocation(), HaveController, nullptr, FLinearColor::Red);
        // }
        // else
        // {
        //     FString HaveController = IsValid(Controller) ? "Client: 有Controller" : "Client: 没有Controller";
        //     System::DrawDebugString(GetActorLocation(), HaveController, nullptr, FLinearColor::Blue);
        // }

        // GetLocalRole()
        // FLinearColor Color = HasAuthority() ? FLinearColor::Red : FLinearColor::Blue;
        // FVector Location = GetActorLocation();
        // Location.Z += 100.0;
        // System::DrawDebugString(Location, FString(f"{GetLocalRole()}"), nullptr, Color);

        // GetRemoteRole()
        // FLinearColor Color = HasAuthority() ? FLinearColor::Red : FLinearColor::Blue;
        // FVector Location = GetActorLocation();
        // Location.Z += 100.0;
        // System::DrawDebugString(Location, FString(f"{GetRemoteRole()}"), nullptr, Color);
    }
};