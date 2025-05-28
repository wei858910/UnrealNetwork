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

    default bUseControllerRotationYaw = false;

    default CharacterMovement.bOrientRotationToMovement = true;

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
        }
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

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (HasAuthority())
        {
            FString HaveController = IsValid(Controller) ? "Server: 有Controller" : "Server: 没有Controller";
            System::DrawDebugString(GetActorLocation(), HaveController, nullptr, FLinearColor::Red);
        }
        else
        {
            FString HaveController = IsValid(Controller) ? "Client: 有Controller" : "Client: 没有Controller";
            System::DrawDebugString(GetActorLocation(), HaveController, nullptr, FLinearColor::Blue);
        }
    }
};