![Codine Development Fuel Script Banner](https://i.imgur.com/qVOMMvW.png)

# _CDN-Fuel (2.1.9)_ 

A highly in-depth fuel system for **FiveM** with support for the **QBCore Framework & QBox Remastered**.

# _Lastest Patch Information_

*Fixes:*
- Jerry Cans not refuelling at pump.
- Removed spamming debug print. 
- Changed the way Air Fuel Zones spawn PolyZones and Props.
- Player Job Error on load.
- Syphoning Issue with QB-Inventory.


<br>
<br>

![Codine Development Fuel Script Features Banner](https://i.imgur.com/ISHQJUL.png)

#### Why should you pick **cdn-fuel**?

- Show all gas station blips via Config Options.
- Vehicle blowing up chance percent via Config Options.
- Pump Explosion Chance when running away with Nozzles via Config Options.
- Global Tax and Fuel Prices via Config Options.
- Target eye for all base fuel actions, not including Jerry Can & Syphoning.
- Fuel and Charging Nozzle with realistic animations.
- Custom sounds for every action, like refueling & charging.
- Select amount of fuel you want to put in your vehicle.
- On cancel, the amount you put in will be filled.
- Option to pay cash or with your bank.
- Toggleable Jerry Cans via Config Options.
- [CDN-Syphoning](https://github.com/CodineDev/cdn-syphoning) built-in via Config Options.
- Electric Charging with a [Custom Model](https://i.imgur.com/WDxGoT6.png) & pre-configured locations.
- [Player Owned Gas Stations](https://www.youtube.com/watch?v=3glln0S2QXo) that can be maintained by the Owner.
- [Highly User Friendly Menus](https://i.imgur.com/f64IxpA.png) for Gas Station Owners.
- Reserve Levels which are maintained by the Owner of the Gas Station or Unlimited based on Config Options.
- Renamable Gas Stations on Map with Blacklisted words.
- Helicopter and Boat Refueling.
- Configurable discounts for Emergency Services.
- Configurable Hose for the Fuel Nozzle.
- Official Support for the [OX Library](https://github.com/overextended/ox_lib). (Inventory/Menus/Target)


![Codine Development Fuel Script Install Banner](https://i.imgur.com/bEiV8G0.png)

### Before your installation:
Make sure you have the following dependencies, otherwise, issues most likely will arise:

### Dependencies:

- [qb-target](https://github.com/BerkieBb/qb-target)
- [qb-menu](https://github.com/qbcore-framework/qb-menu) **&** [qb-input](https://github.com/qbcore-framework/qb-input) **OR** [ox_lib](https://github.com/overextended/ox_lib)
- [interact-sound](https://github.com/plunkettscott/interact-sound)
- [PolyZone](https://github.com/qbcore-framework/PolyZone)
- _Other dependencies are included in the resource._


### Begin your installation

Here, we shall provide a step-by-step guide on installing cdn-fuel to your server and making it work with other scripts you may already have installed.

### Step 1:

First, we will start by renaming the resource "cdn-fuel-main" to just "cdn-fuel". <br> <br> Next, we will drag the "cdn-fuel" resource into your desired folder in your servers resources directory.

![Step 1](https://i.imgur.com/8kg0LWe.gif)

### Step 2:

Next, we're going to drag the sounds from the *cdn-fuel/assets/sounds* folder in cdn-fuel, into your interact-sounds folder located at *resources/[standalone]/interact-sound/client/html/sounds*

![explorer_8jBjdkgaeQ](https://user-images.githubusercontent.com/95599217/209605265-c8f67612-b8df-4c38-bf23-0c355cfa6c8e.gif)

### Step 3:

Next, we're going to open our entire resources folder in whichever IDE you use, (we will be using Visual Studio Code for this example) and replace all of your current exports titled "LegacyFuel", "ps-fuel" or "lj-fuel", with "cdn-fuel". Then you want to ensure cdn-fuel in your server's config file. 
<br> <br>
![step 3](https://i.imgur.com/VZnQpcS.gif)

<br>

### Step 4:

Next, we're going to run our SQL file, which is needed if we want to use the Player Owned Gas Stations, otherwise you do not have to run it.

<br> 

The file you need to run is located @ _cdn-fuel/assets/sql/cdn-fuel.sql_

<br> 

Here is a GIF to run you through the process of running an SQL file:

![Step4-Gif](https://user-images.githubusercontent.com/95599217/209601625-af7ee908-c367-48b1-8487-b52359148224.gif)

### Step 5:

It is highly recommended, if you plan on restarting the script at all, that you move the _stream_ folder & _data_file_ paramaters found in the _fxmanifest.lua_ to another resource for the time being. If you do not do this, you & anyone in the server's game will most likely crash when restarting _cdn-fuel_. The process is very simple & it is outlined in the GIF & Instructions below.

<br>

**Firstly**, we will move our _stream_ folder to our new resource, or existing resource. <br> <br> In this example, I have a dummy resource named _cdn-fool_.
![explorer_4tflJ0RowY](https://user-images.githubusercontent.com/95599217/209604683-79e18fa7-96ad-456d-b0c4-20632fb4d04c.gif)


Next, we will move our _fxmanifest.lua's_ entries for _data_file_ into our new resource, and **REMOVE IT** from _cdn-fuel_.

![jRtUg319mL](https://user-images.githubusercontent.com/95599217/209604640-54e0a450-6a54-4afa-9fab-cda4f02e7091.gif)


```Lua
data_file 'DLC_ITYP_REQUEST' 'stream/[electric_nozzle]/electric_nozzle_typ.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/[electric_charger]/electric_charger_typ.ytyp'
```

Make sure to **ensure** this new resource as well as _cdn-fuel_ in your _server.cfg_!


**If you do not want the Jerry Can or Syphoning Kit items, you are now finished with installation.**

<br>
*Otherwise, navigate to Step 6 & Step 7 below, and finish installation.*

### Step 6:
***If you are using OX_Inventory, this step can be ignored.***
<br><br>
We will now be installing the Jerry Can & Syphoning Kit items into your server. You don't have to install either, but they are recommended additions. You can install them & disable them in the config, until you want to use them later on! 
<br> <br>
If you plan to not use them, you can skip this Step and Step 7!
<br> <br>
The first step of installing our items is to navigate to your *qb-core/shared/items.lua*.
<br> <br>
Once there, we will paste the following items at the bottom of our items table.
```Lua
	["syphoningkit"]				 = {["name"] = "syphoningkit", 					["label"] = "Syphoning Kit", 			["weight"] = 5000, 		["type"] = "item", 		["image"] = "syphoningkit.png", 		["unique"] = true, 		["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "A kit made to siphon gasoline from vehicles."},
	["jerrycan"]				 	 = {["name"] = "jerrycan", 						["label"] = "Jerry Can", 				["weight"] = 15000, 	["type"] = "item", 		["image"] = "jerrycan.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "A Jerry Can made to hold gasoline."},
```
**For people using inventories with built-in decay, you must add those onto the item, as it doesn't come with it!**
<br> <br>
You can follow this GIF to better understand how to install the items:
<br>
![Step4GIF](https://i.imgur.com/Oiy7X5W.gif)
<br>
Now, we need to format item data in our inventory. Firstly, find the *app.js* located at *inventoryname/html/js/app.js*.
<br> <br>
Now we will CTRL+F the following line:
<br> 
```js
} else if (itemData.name == "harness") {
```
Once you have found this line, copy the following one line above it:
<br> 
```js
        } else if (itemData.name == "syphoningkit") { // Syphoning Kit (CDN-Fuel or CDN-Syphoning!)
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p>" + "A kit used to syphon gasoline from vehicles! <br><br>" + itemData.info.gasamount + " Liters Inside.</p>" +
                "</span></p><p style=\"padding-top: .8vh;font-size:11px\"><b>Weight: </b>" + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + " | <b>Amount: </b> " + itemData.amount
            );
        } else if (itemData.name == "jerrycan") { // Jerry Can (CDN-Fuel!)
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p>" + "A Jerry Can, designed to hold fuel! <br><br>" + itemData.info.gasamount + " Liters Inside.</p>" +
                "</span></p><p style=\"padding-top: .8vh;font-size:11px\"><b>Weight: </b>" + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + " | <b>Amount: </b> " + itemData.amount
            );
```
**Again, if you have decay, you must add in the options yourself!**
<br> <br>
*Here is a GIF to better understand how to install the "jerrycan" and "syphoningkit" in the app.js*
<br>
![Step4JSGIF](https://i.imgur.com/lKq9WDR.gif)
<br> <br>
Next, we'll add the item's images into our Inventory resource. This is a simple process.
<br> <br> 
Navigate to the cdn-fuel resource and follow this path: *cdn-fuel/assets/images*
<br> <br> 
Once there, select both images and either drag or *CTRL + X and CTRL + V* them into your inventory's image folder, usually the path is: *inventoryname/html/images/*
<br> <br> 
You can follow this GIF to get a better understanding:
<br>
![Step4ImagesGIF](https://i.imgur.com/C0uwjfX.gif)
<br>

### Step 6:
This step is only necessary for you to be able to do the */giveitem* command or to put items in the qb-shops.

Navigate to inventoryname/server/server.lua, and CTRL + F the following line:
```Lua
				elseif itemData["name"] == "harness" then
					info.uses = 20
```
<br>
Now we will add the following above the line below:

```Lua
				elseif itemData["name"] == "syphoningkit" then
					info.gasamount = 0
				elseif itemData["name"] == "jerrycan" then
					info.gasamount = 0
```

Alternatively, watch this GIF to better understand the process:
<br>
![Step6 GIF](https://i.imgur.com/yrkR7cJ.gif)

<br> 

##### QB-Shop Setup

Here are some preconfigured shop items if you wish to put them in the shop. (The Jerry Can is buyable via the Gas Pump!)

```Lua
        [10] = {
            name = "syphoningkit",
            price = 5000,
            amount = 5,
            info = { gasamount = 0 }, -- This must be included or, your item will not store fuel properly!
            type = "item",
            slot = 10,
        }, -- CDN-Fuel / CDN-Syphoning
        [11] = {
            name = "jerrycan",
            price = 750,
            amount = 5,
            info = { gasamount = 0 }, -- This must be included or, your item will not store fuel properly!
            type = "item",
            slot = 11,
        }, -- CDN-Fuel
```
<br>
You will most likely have to change the slot it is in for it to work properly!
<br><br>

### QB-Target Issue Fix 

There is a **possible** issue with *qb-target* if you are using the *Config.GlobalVehicleOptions* or *Config.TargetBones* options. 
<br>
### **If you are NOT having this issue occur, do not follow the instructions below, as it could mess up other things.**
<br>

*Here is a simple fix for that issue:*

<br> 

Firstly, this option will have to be added to your *Config.TargetBones* under the bones you are having trouble with:
```Lua
            {
				type = "client",
				event = "cdn-fuel:client:SendMenuToServer",
				icon = "fas fa-gas-pump",
				label = "Insert Nozzle",
				canInteract = function() return Allowrefuel end
            },
	    {
				type = "client",
				action = function()
					TriggerEvent('cdn-fuel:client:electric:RefuelMenu')
				end,
				icon = "fas fa-bolt",
				label = "Insert Electric Nozzle",
				canInteract = function() return AllowElectricRefuel end
            },
```

*Here is an example of how to add this option:*

![Step5part33 QB-Target](https://i.imgur.com/UOgPJRi.png)
<br> 
*This is **specifically** for the "**boot**" bone, but, add it on which bone you are having trouble with.*

<br>
<br>

*Next, we'll add this simple Function & Export into our QB-Target in the Functions() area:*

```Lua
local function AllowRefuel(state, electric) 
    if state then
		if electric then
			AllowElectricRefuel = true
		else
        	Allowrefuel = true
		end
    else
		if electric then
			AllowElectricRefuel = false
		else
			Allowrefuel = false
		end
    end
end exports('AllowRefuel', AllowRefuel)
```

<br> 


**Example Image:**

![Step5 Part 421421412](https://i.imgur.com/pwpa5Tk.png)

<br> 

Lastly, add the following to the top of your _init.lua_ in QB-Target:
```
local Allowrefuel = false
local AllowElectricRefuel = false
```
**Example Image:**

![Example Image](https://user-images.githubusercontent.com/95599217/209600631-31c6f6f0-67e2-46da-bf52-f35114cfb1e9.png)



Now, set the *Config.FuelTargetExport* in *cdn-fuel/shared/config.lua* to **true**.

<br> 

![Step5 Part 1421942151251](https://i.imgur.com/InBl500.png)

## ___Recommended Snippets:___

We highly recommend you add the following snippet to your engine toggle command. It will make it to where players cannot turn their vehicle on if they have no fuel! Seems pretty important to us!

##### ***Engine Toggle Snippet***
```Lua
-- FOR QB-VEHICLEKEYS, FUNCTION ToggleEngine();
local NotifyCooldown = false
function ToggleEngine(veh)
    if veh then
        local EngineOn = GetIsVehicleEngineRunning(veh)
        if not isBlacklistedVehicle(veh) then
            if HasKeys(QBCore.Functions.GetPlate(veh)) or AreKeysJobShared(veh) then
                if EngineOn then
                    SetVehicleEngineOn(veh, false, false, true)
                else
                    if exports['cdn-fuel']:GetFuel(veh) ~= 0 then
                        SetVehicleEngineOn(veh, true, false, true)
                    else
                        if not NotifyCooldown then
                            RequestAmbientAudioBank("DLC_PILOT_ENGINE_FAILURE_SOUNDS", 0)
                            PlaySoundFromEntity(l_2613, "Landing_Tone", PlayerPedId(), "DLC_PILOT_ENGINE_FAILURE_SOUNDS", 0, 0)
                            NotifyCooldown = true
                            QBCore.Functions.Notify('No fuel..', 'error')
                            Wait(1500)
                            StopSound(l_2613)
                            Wait(3500)
                            NotifyCooldown = false
                        end
                    end                
                end
            end
        end
    end
end
```

<br> 

### You are now officially done installing!

<br> 

Enjoy using **cdn-fuel**, if you have an issues, [create an issue](https://github.com/CodineDev/cdn-fuel/issues/new/choose) on the repository, and we will fix it **ASAP**!

<br>
<br>

![Codine Development Fuel Script Showcase Banner](https://i.imgur.com/HQOH3AX.png)

### Demonstration of the script

Here's a couple of videos showcasing the script in action!

- [Main Fueling & Charging!](https://www.youtube.com/watch?v=_h-66IDs8Kw)
- [Player Owned Gas Stations!](https://www.youtube.com/watch?v=3glln0S2QXo)
- [Jerry Cans!](https://www.youtube.com/watch?v=M14nZTzltB0)
- [Siphoning!](https://youtu.be/2CJjM_9hmNA)

<br>
<br>

![Codine Development Fuel Script Future Plans Banner](https://i.imgur.com/1RoBsmo.png)

### Future Plans

- Oil Rig Integration.
- Send more suggestions in our discord server!

<br>
<br>

![Codine Development Links Banner](https://i.imgur.com/SAqArzg.png)

### Codine Links

- [Discord](https://discord.gg/Ta6QNnuxM2)
- [Tebex](https://codine.tebex.io/)
- [Youtube](https://www.youtube.com/channel/UC3Nr0qtyQP9cGRK1m25pOqg)

### Credits:

- **OX Conversion:**
<br><br><img src="https://avatars.githubusercontent.com/u/6962192?v=4" width="25" height="25">
**[NoobySloth](https://github.com/noobysloth)**
for making the initial **OX** portion of the script. 
<br><br><img src="https://avatars.githubusercontent.com/u/82969741?v=4" width="25" height="25">
**[xViperAG](https://www.github.com/xViperAG)**
for adding more OX functionality & support for QBox Remastered.
