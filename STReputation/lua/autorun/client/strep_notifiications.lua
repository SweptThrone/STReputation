-- STReputation v.GitHub
-- this is pretty self-explanatory

net.Receive("strep_downdate", function()

	notification.AddLegacy( "You've lost reputation!", NOTIFY_ERROR, 5 )
	surface.PlaySound( "buttons/combine_button2.wav" )

end)

net.Receive("strep_update", function()

	notification.AddLegacy( "You've gained reputation!", NOTIFY_GENERIC, 5 )
	surface.PlaySound( "garrysmod/content_downloaded.wav" )

end)

net.Receive("strep_menu", function()

	local ReputationWindow = vgui.Create( "DFrame" )
    ReputationWindow:SetPos( ScrW() * 0.3525, ScrH() * 0.35 )
    ReputationWindow:SetSize( ScrW() * 0.3, ScrH() * 0.3 )
    ReputationWindow:SetTitle( "STReputation Menu" )
    ReputationWindow:SetVisible( true )
    ReputationWindow:SetDraggable( true )
    ReputationWindow:ShowCloseButton( true )
	ReputationWindow.Paint = function( self, w, h ) 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 128, 196 ) )
	end
    ReputationWindow:MakePopup()
	
    local RepList = vgui.Create( "DListView", ReputationWindow )
	RepList:Dock(FILL)
	RepList:AddColumn("Player Name")
	RepList:AddColumn("Reputation")

	for k,v in pairs(player.GetAll()) do
		RepList:AddLine(v:Name(), tostring(v:GetNWInt("st_rep")))
	end
	
	local RepLabel = vgui.Create( "DLabel", ReputationWindow )
	RepLabel:SetPos( ScrW() * 0.2, ScrH() * 0.45)
	RepLabel:SetSize( 200, 20 )
	RepLabel:SetText( "Your Reputation: " .. net.ReadEntity():GetNWInt("st_rep") )
	RepLabel:SetContentAlignment( 6 )
	RepLabel:Dock(BOTTOM)

end)