const Schema = require("./ClassSchema")
const computed = Schema.computed

const TEXT_PROPS = {
    "Font",
    "FontSize",
    "Text",
    "TextColor3",
    "TextScaled",
    "TextStrokeColor3",
    "TextStrokeTransparency",
    "TextWrapped",
    "TextXAlignment",
    "TextYAlignment",
    "TextTransparency",
}

const IMAGE_PROPS = {
    "Image",
    "ImageColor3",
    "ImageRectOffset",
    "ImageRectSize",
    "ImageTransparency",
    "ScaleType",
    "SliceScale",
}

const function join(...: { string }): { string }
    const out = {}
    for _, list in { ... } do
        table.move(list, 1, #list, #out + 1, out)
    end
    return out
end

return Schema.build({
    BasePart = {
        props = {
            "Anchored",
            "Velocity",
            "RotVelocity",
            "TopSurface",
            "BottomSurface",
            "LeftSurface",
            "RightSurface",
            "FrontSurface",
            "BackSurface",
            "BrickColor",
            "CFrame",
            "CanCollide",
            "Color",
            "Transparency",
            "Locked",
            "Material",
            "Size",
            "Reflectance",
        },
    },

    FormFactorPart = {
        extends = "BasePart",
        props = { "FormFactor" },
    },

    CornerWedgePart = {
        id = 2,
        extends = "BasePart",
    },

    TrussPart = {
        id = 3,
        extends = "BasePart",
        props = { "Style" },
    },

    VehicleSeat = {
        id = 4,
        extends = "BasePart",
        props = {
            "Disabled",
            "HeadsUpDisplay",
            "MaxSpeed",
            "Steer",
            "Throttle",
            "Torque",
            "TurnSpeed",
        },
    },

    WedgePart = {
        id = 5,
        extends = "FormFactorPart",
    },

    Part = {
        id = 6,
        extends = "FormFactorPart",
        props = { "Shape" },

        remap = function(part)
            const shape = (part :: Part).Shape.Value
            if shape == 3 then
                return "WedgePart"
            elseif shape == 4 then
                return "CornerWedgePart"
            end
            return nil
        end,
    },

    Seat = {
        id = 7,
        extends = "Part",
        props = { "Disabled" },
    },

    FlagStand = {
        id = 8,
        extends = "Part",
        props = { "TeamColor" },
    },

    SpawnLocation = {
        id = 9,
        extends = "Part",
        props = {
            "AllowTeamChangeOnTouch",
            "Neutral",
            "TeamColor",
            "Duration",
            "Enabled",
        },
    },

    MeshPart = {
        id = 82,
        extends = "BasePart",
        props = {
            "MeshId",
            "TextureID",
        },
    },

    SkateboardPlatform = {
        id = 83,
        extends = "Part",
        props = {
            "Steer",
            "StickyWheels",
            "Throttle",
        },
    },

    DataModelMesh = {
        props = {
            "Offset",
            "Scale",
            "VertexColor",
        },
    },

    FileMesh = {
        extends = "DataModelMesh",
        props = {
            "TextureId",
            "MeshId",
        },
    },

    BlockMesh = {
        id = 10,
        extends = "DataModelMesh",
    },

    CylinderMesh = {
        id = 11,
        extends = "DataModelMesh",
    },

    SpecialMesh = {
        id = 12,
        extends = "FileMesh",
        props = { "MeshType" },
    },

    CharacterMesh = {
        id = 68,
        props = {
            "BaseTextureId",
            "BodyPart",
            "MeshId",
            "OverlayTextureId",
        },
    },

    Decal = {
        id = 13,
        props = {
            "Texture",
            "Transparency",
            "Face",
        },
    },

    Texture = {
        id = 14,
        extends = "Decal",
        props = {
            "StudsPerTileU",
            "StudsPerTileV",
        },
    },

    Shirt = {
        id = 15,
        props = { "ShirtTemplate" },
    },

    Pants = {
        id = 16,
        props = { "PantsTemplate" },
    },

    ShirtGraphic = {
        id = 17,
        props = { "Graphic" },
    },

    BodyColors = {
        id = 69,
        props = {
            "HeadColor",
            "LeftArmColor",
            "LeftLegColor",
            "RightArmColor",
            "RightLegColor",
            "TorsoColor",
        },
    },

    SurfaceSelection = {
        id = 18,
        props = {
            "Color3",
            "Visible",
            "Transparency",
        },
    },

    SelectionBox = {
        id = 19,
        props = {
            "Color3",
            "LineThickness",
            "SurfaceColor3",
            "SurfaceTransparency",
            "Transparency",
            "Adornee",
            "Visible",
        },
    },

    FloorWire = {
        id = 20,
        extends = "SurfaceSelection",
        props = {
            "CycleOffset",
            "StudsBetweenTextures",
            "Velocity",
            "WireRadius",
            "TextureSize",
            "Texture",
            "From",
            "To",
        },
    },

    SelectionSphere = {
        id = 84,
        props = {
            "Color3",
            "SurfaceColor3",
            "SurfaceTransparency",
            "Transparency",
            "Adornee",
            "Visible",
        },
    },

    Handles = {
        id = 121,
        props = {
            "Color3",
            "Transparency",
            "Adornee",
            "Visible",
            "Style",
        },
    },

    ArcHandles = {
        id = 122,
        props = {
            "Color3",
            "Transparency",
            "Adornee",
            "Visible",
        },
    },

    Fire = {
        id = 21,
        props = {
            "Color",
            "Enabled",
            "Heat",
            "SecondaryColor",
            "Size",
        },
    },

    Smoke = {
        id = 22,
        props = {
            "Color",
            "Enabled",
            "Opacity",
            "RiseVelocity",
            "Size",
        },
    },

    Sparkles = {
        id = 62,
        props = {
            "Enabled",
            "SparkleColor",
        },
    },

    ParticleEmitter = {
        id = 36,
        props = {
            "Color",
            "LightEmission",
            "Size",
            "Texture",
            "ZOffset",
            "Acceleration",
            "Drag",
            "LockedToPart",
            "VelocityInheritance",
            "EmissionDirection",
            "Enabled",
            "Lifetime",
            "Rate",
            "Rotation",
            "RotSpeed",
            "Speed",
            "VelocitySpread",
            "Transparency",
        },
    },

    Explosion = {
        id = 97,
        props = {
            "BlastPressure",
            "BlastRadius",
            "DestroyJointRadiusPercent",
            "ExplosionType",
            "Position",
        },
    },

    ForceField = {
        id = 81,
    },

    BloomEffect = {
        id = 117,
        props = {
            "Enabled",
            "Intensity",
            "Size",
            "Threshold",
        },
    },

    BlurEffect = {
        id = 118,
        props = {
            "Enabled",
            "Size",
        },
    },

    ColorCorrectionEffect = {
        id = 119,
        props = {
            "Enabled",
            "Brightness",
            "Contrast",
            "Saturation",
            "TintColor",
        },
    },

    SunRaysEffect = {
        id = 120,
        props = {
            "Enabled",
            "Intensity",
            "Spread",
        },
    },

    Light = {
        props = {
            "Brightness",
            "Color",
            "Enabled",
            "Shadows",
        },
    },

    PointLight = {
        id = 23,
        extends = "Light",
        props = { "Range" },
    },

    SpotLight = {
        id = 24,
        extends = "Light",
        props = {
            "Angle",
            "Face",
            "Range",
        },
    },

    SurfaceLight = {
        id = 25,
        extends = "Light",
        props = {
            "Angle",
            "Face",
            "Range",
        },
    },

    JointInstance = {
        props = {
            "C0",
            "C1",
            "Enabled",
            "Part0",
            "Part1",
        },
    },

    Weld = {
        id = 26,
        extends = "JointInstance",
    },

    ManualWeld = {
        id = 27,
        extends = "JointInstance",
    },

    WeldConstraint = {
        id = 26,
        props = {
            computed("C0", function(inst)
                const weld = inst :: WeldConstraint
                if weld.Part0 and weld.Part1 then
                    return weld.Part0.CFrame:ToObjectSpace(weld.Part1.CFrame)
                end
                return CFrame.identity
            end),
            computed("C1", function()
                return CFrame.identity
            end),
            "Enabled",
            "Part0",
            "Part1",
        },
    },

    Motor = {
        id = 28,
        extends = "JointInstance",
        props = {
            "DesiredAngle",
            "MaxVelocity",
        },
    },

    Motor6D = {
        id = 29,
        extends = "Motor",
    },

    Snap = {
        id = 85,
        extends = "JointInstance",
    },

    Rotate = {
        id = 86,
        extends = "JointInstance",
    },

    DynamicRotate = {
        extends = "JointInstance",
    },

    RotateP = {
        id = 87,
        extends = "DynamicRotate",
    },

    RotateV = {
        id = 88,
        extends = "DynamicRotate",
    },

    Attachment = {
        id = 104,
        props = {
            "Axis",
            "CFrame",
            "Position",
            "Rotation",
            "SecondaryAxis",
            "Visible",
        },
    },

    Constraint = {
        props = {
            "Attachment0",
            "Attachment1",
            "Color",
            "Enabled",
            "Visible",
        },
    },

    BallSocketConstraint = {
        id = 105,
        extends = "Constraint",
        props = {
            "LimitsEnabled",
            "Radius",
            "Restitution",
            "UpperAngle",
        },
    },

    HingeConstraint = {
        id = 106,
        extends = "Constraint",
        props = {
            "ActuatorType",
            "AngularSpeed",
            "AngularVelocity",
            "LimitsEnabled",
            "LowerAngle",
            "MotorMaxAcceleration",
            "MotorMaxTorque",
            "Radius",
            "Restitution",
            "ServoMaxTorque",
            "TargetAngle",
            "UpperAngle",
        },
    },

    RodConstraint = {
        id = 107,
        extends = "Constraint",
        props = {
            "Length",
            "Thickness",
        },
    },

    RopeConstraint = {
        id = 108,
        extends = "Constraint",
        props = {
            "Length",
            "Restitution",
            "Thickness",
        },
    },

    SlidingBallConstraint = {
        extends = "Constraint",
        props = {
            "ActuatorType",
            "LimitsEnabled",
            "LowerLimit",
            "MotorMaxAcceleration",
            "MotorMaxForce",
            "Restitution",
            "ServoMaxForce",
            "Size",
            "Speed",
            "TargetPosition",
            "UpperLimit",
            "Velocity",
        },
    },

    CylindricalConstraint = {
        id = 109,
        extends = "SlidingBallConstraint",
        props = {
            "InclinationAngle",
        },
    },

    PrismaticConstraint = {
        id = 110,
        extends = "SlidingBallConstraint",
    },

    SpringConstraint = {
        id = 111,
        extends = "Constraint",
        props = {
            "Coils",
            "Damping",
            "FreeLength",
            "LimitsEnabled",
            "MaxForce",
            "MaxLength",
            "MinLength",
            "Radius",
            "Stiffness",
            "Thickness",
        },
    },

    BodyForce = {
        id = 39,
        props = { "Force" },
    },

    BodyThrust = {
        id = 40,
        props = {
            "Force",
            "Location",
        },
    },

    BodyVelocity = {
        id = 41,
        props = {
            "MaxForce",
            "P",
            "Velocity",
        },
    },

    BodyAngularVelocity = {
        id = 42,
        props = {
            "AngularVelocity",
            "MaxTorque",
            "P",
        },
    },

    BodyPosition = {
        id = 43,
        props = {
            "D",
            "MaxForce",
            "P",
            "Position",
        },
    },

    BodyGyro = {
        id = 44,
        props = {
            "CFrame",
            "D",
            "MaxTorque",
            "P",
        },
    },

    RocketPropulsion = {
        id = 71,
        props = {
            "CartoonFactor",
            "MaxSpeed",
            "MaxThrust",
            "MaxTorque",
            "Target",
            "TargetOffset",
            "TargetRadius",
            "ThrustD",
            "ThrustP",
            "TurnD",
            "TurnP",
        },
    },

    BaseScript = {
        props = { "Disabled" },
    },

    Script = {
        id = 30,
        extends = "BaseScript",
    },

    LocalScript = {
        id = 31,
        extends = "BaseScript",
    },

    ModuleScript = {
        id = 89,
    },

    ScreenGui = {
        id = 32,
    },

    GuiMain = {
        id = 32,
        extends = "ScreenGui",
    },

    SurfaceGui = {
        id = 33,
        props = {
            "Active",
            "Adornee",
            "CanvasSize",
            "Face",
            "ToolPunchThroughDistance",
            "Enabled",
        },
    },

    BillboardGui = {
        id = 34,
        props = {
            "Active",
            "Adornee",
            "AlwaysOnTop",
            "ExtentsOffset",
            "PlayerToHideFrom",
            "Size",
            "SizeOffset",
            "StudsOffset",
            "Enabled",
        },
    },

    GuiObject = {
        props = {
            "Active",
            "BackgroundColor3",
            "BackgroundTransparency",
            "BorderColor3",
            "BorderSizePixel",
            "ClipsDescendants",
            "Draggable",
            "NextSelectionDown",
            "NextSelectionLeft",
            "NextSelectionRight",
            "NextSelectionUp",
            "Position",
            "Rotation",
            "Selectable",
            "SelectionImageObject",
            "Size",
            "SizeConstraint",
            "Visible",
            "ZIndex",
            "LayoutOrder",
            "AnchorPoint",
        },
    },

    GuiButton = {
        extends = "GuiObject",
        props = {
            "AutoButtonColor",
            "Modal",
            "Selected",
            "Style",
        },
    },

    Frame = {
        id = 45,
        extends = "GuiObject",
        props = { "Style" },
    },

    TextLabel = {
        id = 46,
        extends = "GuiObject",
        props = TEXT_PROPS,
    },

    TextBox = {
        id = 47,
        extends = "GuiObject",
        props = join({ "ClearTextOnFocus", "MultiLine" }, TEXT_PROPS),
    },

    TextButton = {
        id = 48,
        extends = "GuiButton",
        props = TEXT_PROPS,
    },

    ImageLabel = {
        id = 49,
        extends = "GuiObject",
        props = IMAGE_PROPS,
    },

    ImageButton = {
        id = 50,
        extends = "GuiButton",
        props = IMAGE_PROPS,
    },

    ScrollingFrame = {
        id = 90,
        extends = "GuiObject",
        props = {
            "BottomImage",
            "CanvasSize",
            "CanvasPosition",
            "MidImage",
            "ScrollBarThickness",
            "ScrollingEnabled",
            "TopImage",
        },
    },

    UIAspectRatioConstraint = {
        id = 112,
        props = {
            "AspectRatio",
            "AspectType",
            "DominantAxis",
        },
    },

    UISizeConstraint = {
        id = 113,
        props = {
            "MaxSize",
            "MinSize",
        },
    },

    UITextSizeConstraint = {
        id = 114,
        props = {
            "MaxTextSize",
            "MinTextSize",
        },
    },

    UIGridStyleLayout = {
        props = {
            "FillDirection",
            "HorizontalAlignment",
            "SortOrder",
            "VerticalAlignment",
        },
    },

    UIGridLayout = {
        id = 115,
        extends = "UIGridStyleLayout",
        props = {
            "CellPadding",
            "CellSize",
            "FillDirectionMaxCells",
            "StartCorner",
        },
    },

    UIListLayout = {
        id = 116,
        extends = "UIGridStyleLayout",
    },

    BackpackItem = {
        props = { "TextureId" },
    },

    Tool = {
        id = 35,
        extends = "BackpackItem",
        props = {
            "Grip",
            "ToolTip",
            "CanBeDropped",
            "ManualActivationOnly",
            "RequiresHandle",
            "Enabled",
        },
    },

    HopperBin = {
        id = 91,
        extends = "BackpackItem",
        props = {
            "BinType",
            "Active",
        },
    },

    Accoutrement = {
        id = 37,
        props = { "AttachmentPoint" },
    },

    Accessory = {
        id = 37,
        extends = "Accoutrement",
    },

    Hat = {
        id = 38,
        extends = "Accoutrement",
    },

    Humanoid = {
        id = 70,
        props = {
            "CameraOffset",
            "DisplayDistanceType",
            "HealthDisplayDistance",
            "NameDisplayDistance",
            "NameOcclusion",
            "RigType",
            "AutoJumpEnabled",
            "AutoRotate",
            "Health",
            "HipHeight",
            "JumpPower",
            "MaxHealth",
            "MaxSlopeAngle",
            "WalkSpeed",
        },
    },

    Skin = {
        id = 54,
        props = { "SkinColor" },
    },

    Animation = {
        id = 99,
        props = { "AnimationId" },
    },

    AnimationController = {
        id = 100,
    },

    KeyframeSequence = {
        id = 103,
        props = {
            "Loop",
            "Priority",
        },
    },

    Keyframe = {
        id = 102,
        props = { "Time" },
    },

    Pose = {
        id = 101,
        props = {
            "CFrame",
            "EasingDirection",
            "EasingStyle",
            "MaskWeight",
            "Weight",
        },
    },

    BoolValue = {
        id = 59,
        props = { "Value" },
    },

    BrickColorValue = {
        id = 61,
        props = { "Value" },
    },

    CFrameValue = {
        id = 92,
        props = { "Value" },
    },

    Color3Value = {
        id = 93,
        props = { "Value" },
    },

    IntValue = {
        id = 56,
        props = { "Value" },
    },

    NumberValue = {
        id = 55,
        props = { "Value" },
    },

    ObjectValue = {
        id = 58,
        props = { "Value" },
    },

    RayValue = {
        id = 94,
    },

    StringValue = {
        id = 57,
        props = { "Value" },
    },

    Vector3Value = {
        id = 60,
        props = { "Value" },
    },

    DoubleConstrainedValue = {
        id = 95,
        props = {
            "MinValue",
            "MaxValue",
            "Value",
        },
    },

    IntConstrainedValue = {
        id = 96,
        props = {
            "MinValue",
            "MaxValue",
            "Value",
        },
    },

    Model = {
        id = 51,
        props = { "PrimaryPart" },
    },

    Camera = {
        id = 98,
        props = {
            "CFrame",
            "FieldOfView",
            "HeadLocked",
            "HeadScale",
            "Focus",
        },
    },

    Sky = {
        id = 72,
        props = {
            "CelestialBodiesShown",
            "SkyboxBk",
            "SkyboxDn",
            "SkyboxFt",
            "SkyboxLf",
            "SkyboxRt",
            "SkyboxUp",
            "StarCount",
        },
    },

    Sound = {
        id = 67,
        props = {
            "Looped",
            "MaxDistance",
            "MinDistance",
            "Pitch",
            "Playing",
            "SoundId",
            "TimePosition",
            "Volume",
            "PlayOnRemove",
        },
    },

    Team = {
        id = 64,
        props = {
            "AutoAssignable",
            "AutoColorCharacters",
            "TeamColor",
        },
    },

    ClickDetector = {
        id = 63,
        props = { "MaxActivationDistance" },
    },

    Message = {
        id = 53,
        props = { "Text" },
    },

    Hint = {
        id = 52,
        extends = "Message",
    },

    Dialog = {
        id = 65,
        props = {
            "ConversationDistance",
            "GoodbyeDialog",
            "GoodbyeChoiceActive",
            "InitialPrompt",
            "Purpose",
            "Tone",
        },
    },

    DialogChoice = {
        id = 66,
        props = {
            "ResponseDialog",
            "GoodbyeDialog",
            "UserDialog",
        },
    },

    BindableEvent = { id = 73 },
    BindableFunction = { id = 74 },
    RemoteEvent = { id = 75 },
    RemoteFunction = { id = 76 },
    Folder = { id = 77 },
    Configuration = { id = 78 },
    Backpack = { id = 79 },
    StarterGear = { id = 80 },
})
