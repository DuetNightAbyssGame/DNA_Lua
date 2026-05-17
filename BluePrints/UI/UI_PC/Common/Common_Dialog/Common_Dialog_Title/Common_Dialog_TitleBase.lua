local Common_Dialog_TitleBase = {}

function Common_Dialog_TitleBase:RegisterCloseButton(Obj, PopupData)
    self.BtnClose = Obj

    self.BtnClose.SoundFunc = function() 
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", nil, nil)
    end

    self.NotShowCloseButton = PopupData.NotShowCloseButton
    if not PopupData.NotShowCloseButton then 
        self.L01:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.L02:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.BtnClose:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        self.L01:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.L02:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.BtnClose:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function Common_Dialog_TitleBase:BindOnCloseButtonClicked(Obj, ClickedFunc)
    self.BtnClose:BindEventOnClicked(Obj, ClickedFunc)
end

return Common_Dialog_TitleBase