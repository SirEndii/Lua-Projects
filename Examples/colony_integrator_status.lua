---
--- Made for the Advanced Peripherals documentation
--- Created by Srendi - Created by Srendi - https://github.com/SirEndii
--- DateTime: 25.04.2021 20:44
--- Link: https://docs.srendi.de/peripherals/colony_integrator/
---

local colony = peripheral.wrap("back")
 
print("Building Sites: ".. colony.amountOfConstructionSites())
print("Citizens: ".. colony.amountOfCitizens())
local underAttack = "No"
if colony.isUnderAttack() then
    underAttack = "Yes"
end
print("Is under attack? ".. underAttack)
print("Overall happiness: ".. math.floor(colony.getHappiness()))
print("Amount of graves: ".. colony.amountOfGraves())
