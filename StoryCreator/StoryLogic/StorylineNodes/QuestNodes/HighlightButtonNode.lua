





local HighlightButtonNode = Class('StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode')




function HighlightButtonNode:Init()

	self.ShowEnable = false
    self.SkillType = ""

end

function HighlightButtonNode:Start(Context)
	self.Context = Context
	self:ShowMessage(self.Context)
end

function HighlightButtonNode:ShowMessage(Context)
    DebugPrint("------------ HighlightButtonNode ------------------")
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
        self:Finish()
        return
    end
    local BattleMain = UIManager:GetUIObj("BattleMain")
    local Platform = CommonUtils:GetDeviceTypeByPlatformName(BattleMain)
    if self.ShowEnable then
        if Platform == "PC" then
            BattleMain.Pos_Instruction:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            local Instruction = BattleMain.Pos_Instruction:GetChildAt(0)
            if Instruction == nil then
                Instruction = BattleMain:GetOrAddWidget("InstructionPC", BattleMain.Pos_Instruction)
                if Instruction then 
                    Instruction:Init(self.SkillType, true)
                    Instruction:HideAllText()
                end
            end
            if Instruction then
                Instruction:Init(self.SkillType, true) 
                DebugPrint(self.SkillType, "===HighlightButton=Show=PC===========================",Instruction.Key.Main:GetRenderOpacity())
                if Instruction.Key.Main:GetRenderOpacity() ~= 1 then
                    self.RealStart = true
                end
                -- Instruction.Key.Main:SetRenderOpacity(0)
                Instruction.Key:UnbindAllFromAnimationFinished(Instruction.Key.In)
                local LoopAnim = function() Instruction.Key:PlayAnimation(Instruction.Key.Loop, 0, 0) end
                if self.SkillType == "MoveCamera" then
                    LoopAnim = function() 
                        -- Instruction.Key:PlayAnimation(Instruction.Key.ArrowUp, 0, 0)
                        EMUIAnimationSubsystem:EMPlayAnimation(Instruction.Key,Instruction.Key.ArrowUp,0,true)
                    end
                end
                Instruction.Key:BindToAnimationFinished(Instruction.Key.In, {Instruction.Key, LoopAnim})
                Instruction.Key:StopAnimation(Instruction.Key.Out)
                if self.SkillType == "Skill1" then
                    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
                    if Player then
                        local CanUseSkill1 = Player:CheckCanUseSkillWithoutToast(UE.ESkillType.Skill1)
                        if CanUseSkill1 then
                            Instruction.Key:StopAllAnimations()
                            Instruction.Key:PlayAnimation(Instruction.Key.In)
                        else
                            Instruction.Key:StopAllAnimations()
                            Instruction.Key:UnbindAllFromAnimationFinished(Instruction.Key.In)
                            local CloseLoopAnim = function() Instruction.Key:PlayAnimation(Instruction.Key.CloseLoop, 0, 0) end
                            --Instruction.Key:BindToAnimationFinished(Instruction.Key.In, {Instruction.Key, CloseLoopAnim})
                            Instruction.Key:PlayAnimation(Instruction.Key.In)
                        end
                        Instruction.CanUseSkill1 = CanUseSkill1
                    end
                else
                    Instruction.Key:PlayAnimation(Instruction.Key.In)
                end
                
                if self.SkillType == "Attack" or self.SkillType == "MoveCamera" then
                    --Instruction.Key.Switch_Type:SetActiveWidgetIndex(1)
                    -- if self.SkillType == "Attack" then
                    --     Instruction.Key.Key_Img:_SetImage(nil, "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Instruction/T_Key_LeftMouseButton_L.T_Key_LeftMouseButton_L'")
                    -- else
                    --     Instruction.Key.Key_Img:_SetImage(nil, "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Instruction/T_Key_Mouse_L.T_Key_Mouse_L'")
                    -- end
                else
                    -- local TextKey = CommonUtils:GetKeyText(CommonUtils:GetActionMappingKeyName(self.SkillType))
                    -- Instruction.Key.Switch_Type:SetActiveWidgetIndex(0)
                    -- Instruction.Key.Key_Text.Text_Key:SetText(TextKey)
                    Instruction.Key.VX_guide_Sq1:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                    Instruction.Key.VX_guide_Sq2:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                    --Instruction.Key:PlayAnimation(Instruction.Key.Loop, 0, 0)
                end
                if self.SkillType == "Attack" then
                    Instruction.Key.Text_Describe:SetText(GText("Guide_HighlightButton_Attack"))
                elseif self.SkillType == "MoveCamera" then
                    Instruction.Key.Text_Describe:SetText(GText("Guide_HighlightButton_MoveCamera"))
                elseif self.SkillType == "Skill1" then
                    Instruction.Key.Text_Describe:SetText(GText("Guide_HighlightButton_Skill1"))
                    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
                    if Player then
                        --Instruction.CanUseSkill1 = true
                        Instruction:AddTimer(0.1,function()
                            local CanUseSkill1 = Player:CheckCanUseSkillWithoutToast(UE.ESkillType.Skill1)
                            -- DebugPrint("===============================CheckCanUseSkill===================",CanUseSkill1,Instruction.CanUseSkill1)
                            if CanUseSkill1 and Instruction.CanUseSkill1 == false then
                                if Instruction.UsingGamepad then
                                    Instruction.key.VX_guide_Cirle1:SetVisibility(ESlateVisibility.Visible)
                                    Instruction.key.VX_guide_Cirle2:SetVisibility(ESlateVisibility.Visible)
                                else
                                    Instruction.Key.VX_guide_Sq1:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                                    Instruction.Key.VX_guide_Sq2:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                                end
                                Instruction.Key:StopAllAnimations()
                                Instruction.Key:PlayAnimation(Instruction.Key.Loop, 0, 0)
                                -- Instruction.Key:UnbindAllFromAnimationFinished(Instruction.Key.In)
                                -- local LoopAnim1 = function() Instruction.Key:PlayAnimation(Instruction.Key.Loop, 0, 0) end
                                -- Instruction.Key:BindToAnimationFinished(Instruction.Key.In, {Instruction.Key, LoopAnim1})
                                -- Instruction.Key:PlayAnimation(Instruction.Key.In)
                                DebugPrint("========================HighlightButton=======CheckCanUseSkill=========PlayAnimation==========")
                            elseif CanUseSkill1 == false and Instruction.CanUseSkill1 then
                                Instruction.Key:StopAnimation(Instruction.Key.Loop)
                                Instruction.Key:PlayAnimation(Instruction.Key.CloseLoop)
                                DebugPrint("========================HighlightButton=======CheckCanUseSkill=========StopAnimation==========")
                            end
                            Instruction.CanUseSkill1 = CanUseSkill1
                        end, true, 0, "InstructionKeyAnim", true)
                    end
                elseif self.SkillType == "Skill2" then
                    Instruction.Key.Text_Describe:SetText(GText("Guide_HighlightButton_Skill2"))
                elseif self.SkillType == "Skill3" then
                    Instruction.Key.Text_Describe:SetText(GText("Guide_HighlightButton_Skill3"))
                elseif self.SkillType == "Interactive" then
                    Instruction.Key.Text_Describe:SetText(GText("MESSAGE_TITLE_LOADING_21_PC"))
                elseif self.SkillType == "Slide" then
                    Instruction.Key.Text_Describe:SetText(GText("Guide_HighlightButton_Crouch"))
                end
            end
        else
            DebugPrint(self.SkillType, "===HighlightButton=Show=Mobile===========================")
            if self.SkillType == "Attack" then
                BattleMain.Char_Skill.AtkMelee:PlayAnimation(BattleMain.Char_Skill.AtkMelee.Loop, 0, 0)
            elseif self.SkillType == "Skill1" then
                BattleMain.Char_Skill.Skill:PlayAnimation(BattleMain.Char_Skill.Skill.Skill_1_Loop, 0, 0)
            elseif self.SkillType == "Skill2" then
                BattleMain.Char_Skill.Skill:PlayAnimation(BattleMain.Char_Skill.Skill.Skill_2_Loop, 0, 0)
            elseif self.SkillType == "Skill3" then
                --BattleMain.Char_Skill.SupportSkill:PlayAnimation(BattleMain.Char_Skill.Skill.Skill_2_Loop, 0, 0)    
            elseif self.SkillType == "MoveCamera" then
                UE4.UUIStateAsyncActionBase.ShowGuideToastFingerNode(GameInstance, 200012, -1,
                self.SkillType, "Up", FVector2D(0,0))
            end
        end
    else
        if Platform == "PC" then
            local Instruction = BattleMain.Pos_Instruction:GetChildAt(0)
            if Instruction == nil then
                self:Finish()
                return
            end
            DebugPrint(self.SkillType, "===HighlightButton=Hide=PC===========================",Instruction.Key.Main:GetRenderOpacity())
            if Instruction.Key.Main:GetRenderOpacity() ~= 0 then
                self.RealStart = true
            end
            if self.SkillType == "MoveCamera" then
                -- Instruction.Key:StopAnimation(Instruction.Key.ArrowUp)
                EMUIAnimationSubsystem:EMPlayAnimation(Instruction.Key,Instruction.Key.ArrowUp)
            else
                Instruction.Key:StopAnimation(Instruction.Key.Loop)
                if self.SkillType == "Skill1" then
                    Instruction:RemoveTimer("InstructionKeyAnim")
                end
            end
            Instruction.Key:PlayAnimation(Instruction.Key.Out)
        else
            DebugPrint(self.SkillType, "===HighlightButton=Hide=Mobile===========================")
            if self.SkillType == "Attack" then
                BattleMain.Char_Skill.AtkMelee:StopAnimation(BattleMain.Char_Skill.AtkMelee.Loop)
                BattleMain.Char_Skill.AtkMelee:PlayAnimation(BattleMain.Char_Skill.AtkMelee.LoopEnd)
            elseif self.SkillType == "Skill1" then
                BattleMain.Char_Skill.Skill:StopAnimation(BattleMain.Char_Skill.Skill.Skill_1_Loop)
                BattleMain.Char_Skill.Skill:PlayAnimation(BattleMain.Char_Skill.Skill.Skill_1_LoopEnd)
            elseif self.SkillType == "Skill2" then
                BattleMain.Char_Skill.Skill:StopAnimation(BattleMain.Char_Skill.Skill.Skill_2_Loop)
                BattleMain.Char_Skill.Skill:PlayAnimation(BattleMain.Char_Skill.Skill.Skill_2_LoopEnd)
            elseif self.SkillType == "MoveCamera" then
                local GuideGesture = UIManager:GetUIObj("GuideGesture")
                if GuideGesture then
                    GuideGesture:PlayOutAnimation()
                end
            end
        end
    end

    self:Finish()
end

function HighlightButtonNode:OnQuestlineFail()
    DebugPrint("HighlightButtonNode: OnQuestlineFail", self.ShowEnable, self.SkillType, self.RealStart)
    if self.RealStart ~= true then
        return
    end
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
        -- self:Finish()
        return
    end
    local BattleMain = UIManager:GetUIObj("BattleMain")
    local Platform = CommonUtils:GetDeviceTypeByPlatformName(BattleMain)
    if self.ShowEnable == false then
        if Platform == "PC" then
            local Instruction = BattleMain.Pos_Instruction:GetChildAt(0)
            if Instruction == nil then
                -- Instruction = BattleMain:GetOrAddWidget("InstructionPC", BattleMain.Pos_Instruction)
                -- if Instruction then 
                --     Instruction:HideAllText()
                -- end
                return
            end
            if Instruction then 
                DebugPrint(self.SkillType, "===HighlightButton=Show=PC===========================")
                -- Instruction.Key:SetVisibility(UE4.ESlateVisibility.Visible)
                Instruction.Key.Main:SetRenderOpacity(1)
                Instruction.Key:PlayAnimation(Instruction.Key.Loop, 0, 0)
                -- if self.SkillType == "Attack" or self.SkillType == "MoveCamera" then
                --     Instruction.Key.Switch_Type:SetActiveWidgetIndex(1)
                --     if self.SkillType == "Attack" then
                --         Instruction.Key.Key_Img:_SetImage(nil, "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Instruction/T_Key_LeftMouseButton_L.T_Key_LeftMouseButton_L'")
                --     else
                --         Instruction.Key.Key_Img:_SetImage(nil, "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Instruction/T_Key_Mouse_L.T_Key_Mouse_L'")
                --     end
                -- else
                --     local TextKey = CommonUtils:GetKeyText(CommonUtils:GetActionMappingKeyName(self.SkillType))
                --     Instruction.Key.Switch_Type:SetActiveWidgetIndex(0)
                --     Instruction.Key.Key_Text.Text_Key:SetText(TextKey)
                -- end
                if self.SkillType == "Attack" then
                    Instruction.Key.Text_Describe:SetText(GText("Guide_HighlightButton_Attack"))
                elseif self.SkillType == "Skill1" then
                    Instruction.Key.Text_Describe:SetText(GText("Guide_HighlightButton_Skill1"))
                elseif self.SkillType == "Skill2" then
                    Instruction.Key.Text_Describe:SetText(GText("Guide_HighlightButton_Skill2"))
                elseif self.SkillType == "Skill3" then
                    Instruction.Key.Text_Describe:SetText(GText("Guide_HighlightButton_Skill3"))
                elseif self.SkillType == "Interactive" then
                    Instruction.Key.Text_Describe:SetText(GText("MESSAGE_TITLE_LOADING_21_PC"))
                elseif self.SkillType == "Slide" then
                    Instruction.Key.Text_Describe:SetText(GText("Guide_HighlightButton_Crouch"))
                end
            end
        else
            DebugPrint(self.SkillType, "===HighlightButton=Show=Mobile===========================")
            if self.SkillType == "Attack" then
                BattleMain.Char_Skill.AtkMelee:PlayAnimation(BattleMain.Char_Skill.AtkMelee.Loop, 0, 0)
            elseif self.SkillType == "Skill1" then
                BattleMain.Char_Skill.Skill:PlayAnimation(BattleMain.Char_Skill.Skill.Skill_1_Loop, 0, 0)
            elseif self.SkillType == "Skill2" then
                BattleMain.Char_Skill.Skill:PlayAnimation(BattleMain.Char_Skill.Skill.Skill_2_Loop, 0, 0)
            elseif self.SkillType == "Skill3" then
            end
        end
    else
        if Platform == "PC" then
            local Instruction = BattleMain.Pos_Instruction:GetChildAt(0)
            if Instruction == nil then
                -- self:Finish()
                return
            end
            DebugPrint(self.SkillType, "===HighlightButton=Hide=PC===========================")
            Instruction.Key:StopAnimation(Instruction.Key.Loop)
            Instruction.Key:PlayAnimation(Instruction.Key.Out)
        else
            DebugPrint(self.SkillType, "===HighlightButton=Hide=Mobile===========================")
            if self.SkillType == "Attack" then
                BattleMain.Char_Skill.AtkMelee:StopAnimation(BattleMain.Char_Skill.AtkMelee.Loop)
                BattleMain.Char_Skill.AtkMelee:PlayAnimation(BattleMain.Char_Skill.AtkMelee.LoopEnd)
            elseif self.SkillType == "Skill1" then
                BattleMain.Char_Skill.Skill:StopAnimation(BattleMain.Char_Skill.Skill.Skill_1_Loop)
                BattleMain.Char_Skill.Skill:PlayAnimation(BattleMain.Char_Skill.Skill.Skill_1_LoopEnd)
            elseif self.SkillType == "Skill2" then
                BattleMain.Char_Skill.Skill:StopAnimation(BattleMain.Char_Skill.Skill.Skill_2_Loop)
                BattleMain.Char_Skill.Skill:PlayAnimation(BattleMain.Char_Skill.Skill.Skill_2_LoopEnd)
            end
        end
    end
end

-- Texture2D'/Game/UI/Texture/Dynamic/Atlas/Instruction/T_Key_LeftMouseButton_L.T_Key_LeftMouseButton_L'
-- Texture2D'/Game/UI/Texture/Dynamic/Atlas/Instruction/T_Key_Mouse_Button_L.T_Key_Mouse_Button_L'
-- Texture2D'/Game/UI/Texture/Dynamic/Atlas/Instruction/T_Key_Mouse_L.T_Key_Mouse_L'
-- Texture2D'/Game/UI/Texture/Dynamic/Atlas/Instruction/T_Key_RightMouseButton_L.T_Key_RightMouseButton_L'


return HighlightButtonNode