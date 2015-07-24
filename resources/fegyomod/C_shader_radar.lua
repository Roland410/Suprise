addEventHandler( "onClientResourceStart", resourceRoot,
    function()
        if getVersion ().sortable < "1.1.0" then
            outputChatBox( "resource wont work on this client." )
            return
        end

texShader = dxCreateShader ( "shader/texreplace.fx" )
radardisc = dxCreateTexture("hud/radardisc.png")


dxSetShaderValue(texShader,"gTexture",radardisc)
engineApplyShaderToWorldTexture(texShader,"radardisc")
        end
)