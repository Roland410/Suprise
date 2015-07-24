-- Skybox alternative v0.40 by Ren712
-- Based on GTASA Skybox mod by Shemer
-- knoblauch700@o2.pl

local sphereObjScale=100 -- set object scale
local sphereShadScale={1,1,0.9} -- object scale in VS
local makeAngular=true -- set to true if you have spheric texture

local sphereTexScale={1,1,1} -- scale the texture in PS
-- color variables below
local ColorAdd=-0.15; -- 0 to -0.4 -- standard colors are too bright
local ColorPow=2; -- 1 to 2 -- contrast
local shadCloudsTexDisabled=false
local modelID=15057  -- that's probably the best model to replace ... or not
setWeather(7) -- the chosen weather (you might delete that but choose a proper one)
setCloudsEnabled(false)
local skydome_shader, technique = dxCreateShader ( "shaders/shader_skydome.fx",0,0,true,"object" )
local null_shader = dxCreateShader ( "shaders/shader_null.fx" )
local  getLastTick,getLastTock = 0,0

function startShaderResource()

 if not skydome_shader or not null_shader then 
  outputChatBox('Could not start Skybox alternative !')
  return 
  else
  --outputChatBox('Using technique '..technique)
 end

 setCloudsEnabled(false)
 local skydomeTexture=dxCreateTexture("textures/skydome.jpg")
 dxSetShaderValue ( skydome_shader, "gTEX", skydomeTexture )
 dxSetShaderValue ( skydome_shader, "gAlpha", 1 )
 dxSetShaderValue ( skydome_shader, "makeAngular", makeAngular )
 dxSetShaderValue ( skydome_shader, "gObjScale", sphereShadScale )
 dxSetShaderValue ( skydome_shader, "gTexScale",sphereTexScale )
 dxSetShaderValue ( skydome_shader, "gColorAdd",ColorAdd)
 dxSetShaderValue ( skydome_shader, "gColorPow",ColorPow)

 -- apply to texture
 engineApplyShaderToWorldTexture ( skydome_shader, "skybox_tex" ) 
 if shadCloudsTexDisabled then engineApplyShaderToWorldTexture ( null_shader, "cloudmasked*" ) end
 txd_skybox = engineLoadTXD('models/skybox_model.txd')
 engineImportTXD(txd_skybox, modelID)
 dff_skybox = engineLoadDFF('models/skybox_model.dff', modelID)
 engineReplaceModel(dff_skybox, modelID)  
 
 local cam_x,cam_y,cam_z = getElementPosition(getLocalPlayer())
 skyBoxBoxa = createObject ( modelID, cam_x, cam_y, cam_z, 0, 0, 0, true )
 setObjectScale(skyBoxBoxa,sphereObjScale) 
 setElementAlpha(skyBoxBoxa,1)
 addEventHandler ( "onClientHUDRender", getRootElement (), renderSphere ) -- sky object
 addEventHandler ( "onClientHUDRender", getRootElement (), renderTime ) -- time 
 applyWeatherInfluence()
end

function stopShaderResource()
removeEventHandler ( "onClientHUDRender", getRootElement (), renderSphere ) -- sky object
removeEventHandler ( "onClientHUDRender", getRootElement (), renderTime ) -- time 
destroyElement(skyBoxBoxa)
destroyElement(skydome_shader)
skyBoxBoxa=nil
skydome_shader=nil
end

lastWeather=0
function renderSphere()
 -- Updates the position of the object
 if getTickCount ( ) - getLastTock < 2  then return end
 local cam_x, cam_y, cam_z, lx, ly, lz = getCameraMatrix()
 if cam_z<=200 then setElementPosition ( skyBoxBoxa, cam_x, cam_y, 80,false ) 
 else setElementPosition ( skyBoxBoxa, cam_x, cam_y, 80+cam_z-200,false )  end
 if getWeather()~=lastWeather then applyWeatherInfluence() end
 lastWeather=getWeather()
 getLastTock = getTickCount ()
end

function renderTime()

 local hour, minute = getTime ( )
 if getTickCount ( ) - getLastTick < 100  then return end
 if not skydome_shader then return end
 if hour >= 20 then
  local dusk_aspect = ((hour-20)*60+minute)/240
  dusk_aspect = 1-dusk_aspect
  dxSetShaderValue ( skydome_shader, "gAlpha", dusk_aspect)
 end
	
 if hour <= 2 then
  dxSetShaderValue ( skydome_shader, "gAlpha", 0)
 end
	
 if hour > 2 and hour <= 6 then
  local dawn_aspect = ((hour-3)*60+minute)/180
  dawn_aspect = dawn_aspect
  dxSetShaderValue ( skydome_shader, "gAlpha", dawn_aspect)
 end
	
 if hour > 6 and hour < 20 then
  dxSetShaderValue ( skydome_shader, "gAlpha", 1)
 end

 getLastTick = getTickCount ()
end


function applyWeatherInfluence()
	setSunSize (0)
	setSunColor(0, 0, 0, 0, 0, 0)
end

addEventHandler("onClientResourceStart", getResourceRootElement( getThisResource()), startShaderResource)
addEventHandler("onClientResourceStop", getResourceRootElement( getThisResource()), stopShaderResource)