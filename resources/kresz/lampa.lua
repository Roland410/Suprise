function handleTrafficLightsOutOfOrder()
    local lightsOff = getTrafficLightState() == 9
 
    if lightsOff then
        setTrafficLightState(6)
    else
        setTrafficLightState(9)
    end
end
setTimer(handleTrafficLightsOutOfOrder,500,0)