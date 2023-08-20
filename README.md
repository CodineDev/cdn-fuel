[![Download Latest](https://img.shields.io/badge/version-2.2.0_Beta-green)](https://github.com/CodineDev/cdn-fuel/archive/refs/heads/beta.zip)
![GitHub Stars](https://img.shields.io/github/stars/CodineDev/cdn-fuel?style=social)
![GitHub Forks](https://img.shields.io/github/forks/CodineDev/cdn-fuel?style=social)

# CDN-Fuel (ESX BETA)
A comprehensive fuel script specifically designed to enhance emmersion add give a greater experience to your players. 

Designed to support QBCore/QBox & Now ESX (On the Beta Branch)

## What makes CDN-Fuel unique?
Well, we have gone through and created a unique take on a basic server system. We have many unique features including but, not limited to the following:
- **Custom** and Original Immersive Sounds Throughout
- Immersive Props and Animations
- [Electric Charging](https://www.youtube.com/watch?v=_h-66IDs8Kw) with a custom model
- Useable Jerry Cans
- [Highly Customizable and Simple Menus](https://i.imgur.com/f64IxpA.png)
- Land, Air, and Sea Fueling
- Player Owned Gas Stations, which players can [completely control](https://i.imgur.com/f64IxpA.png)
- Support for QBCore/QBox/ESX Frameworks
- Highly Configurable Options for Developers

<br>

![Codine Development Fuel Script Showcase Banner](https://i.imgur.com/rLK1nLL.png)
### Demonstration of the script

Here's a couple of videos showcasing the script in action!

- [Main Fueling & Charging!](https://www.youtube.com/watch?v=_h-66IDs8Kw)
- [Player Owned Gas Stations!](https://www.youtube.com/watch?v=3glln0S2QXo)
- [Jerry Cans!](https://www.youtube.com/watch?v=M14nZTzltB0)
- [Syphoning!](https://youtu.be/2CJjM_9hmNA)


### Now that your going to download it, let us tell you how to install it.
Firstly, depending on what framework you are using, you will have to have some dependencies.

### ESX Dependencies:
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ox_target](https://github.com/overextended/ox_target)
- [interact-sound](https://github.com/plunkettscott/interact-sound)

### QBCore Dependencies:
- [ox_lib](https://github.com/overextended/ox_lib) **or** ( [qb-menu](https://github.com/qbcore-framework/qb-menu) **&** [qb-input](https://github.com/qbcore-framework/qb-input) )
- [ox_target](https://github.com/overextended/ox_target) **or** [qb-target](https://github.com/qbcore-framework/qb-target)
- [PolyZone](https://github.com/qbcore-framework/PolyZone)
- [interact-sound](https://github.com/plunkettscott/interact-sound)


### Installing CDN-Fuel

### 1. Download the resource
Simply download the latest/desired release  or the zip from the desired branch, **[main](https://github.com/CodineDev/cdn-fuel/tree/main)** or **[beta](https://github.com/CodineDev/cdn-fuel/tree/beta)**.

### 2. Installing Sounds
Move our sounds from the [cdn-fuel/assets/sounds folder](https://github.com/CodineDev/cdn-fuel/tree/main/assets/sounds), into our [interact-sound/client/html/sounds](https://github.com/plunkettscott/interact-sound/tree/master/client/html/sounds) folder.

![Installing Sounds GIF](https://user-images.githubusercontent.com/95599217/209605265-c8f67612-b8df-4c38-bf23-0c355cfa6c8e.gif)

### 3. Renaming Exports
We are going to get it out of the way now and re-name all exports for our previous fuel script. We will open our resources folder in our IDE, we use VSCode, and we will rename our previous script *(LegacyFuel in this example)* to **cdn-fuel**.

![Renaming Exports GIF](https://camo.githubusercontent.com/1a54d1fea994d98f2d5dc94aa50a1049f8c2ad0da4b47375f224d427fd1fc02b/68747470733a2f2f692e696d6775722e636f6d2f565a6e517063532e676966)

### 4. SQL Setup
If using the Player Owned Gas Stations, you will have to install the SQL. The file you want to install with be located at: [cdn-fuel/assets/sql/cdn-fuel.sql](https://github.com/CodineDev/cdn-fuel/tree/main/assets/sql). When using HeidiSQL, you want to find the database for your server, click it, and then go to File > Run SQL and open the previously mentioned SQL file.

![SQL Setup GIF](https://user-images.githubusercontent.com/95599217/209601625-af7ee908-c367-48b1-8487-b52359148224.gif)

## The rest of these steps are optional, but some of them are may be required for Config options.

### 5. Installing Items
If you don't plan on using the Syphoning Kit or Jerry Can items, this can be skipped, but if you do:

We have two different code snippets for items depending on if you are using ox_inventory or not:

**OX_Inventory Items:**
```Lua
	["jerrycan"] = {
		label = "Jerry Can",
		weight = 15000,
		stack = false,
		close = true,
		description = "A Jerry Can made to hold gasoline.",
		client = {
			export = "cdn-fuel.jerrycan:use"
		}
	},

	["syphoningkit"] = {
		label = "Syphoning Kit",
		weight = 15000,
		stack = false,
		close = true,
		description = "A kit used to syphon gasoline from vehicles.",
		client = {
			export = "cdn-fuel.syphoningkit:use"
		}
	},
```

**QB-Core Items:**
```Lua
	["syphoningkit"]				 = {["name"] = "syphoningkit", 					["label"] = "Syphoning Kit", 			["weight"] = 5000, 		["type"] = "item", 		["image"] = "syphoningkit.png", 		["unique"] = true, 		["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "A kit made to siphon gasoline from vehicles."},
	["jerrycan"]				 	 = {["name"] = "jerrycan", 						["label"] = "Jerry Can", 				["weight"] = 15000, 	["type"] = "item", 		["image"] = "jerrycan.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "A Jerry Can made to hold gasoline."},
```

**For QB-Inventory, you will have to edit the app.js file.**
Firstly, find the *app.js* located at *inventoryname/html/js/app.js*.
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
<br> <br>
*Here is a GIF to better understand how to install the "jerrycan" and "syphoningkit" in the app.js*
<br>
![Step4JSGIF](https://i.imgur.com/lKq9WDR.gif)

### 6. Streaming the Electric Charger Models Seperately
This step is completely option, but highly recommended if the script will ever restart. Reason being, restarting the script that has the model inside may cause crashes/instability. 

**Firstly**, we will create a new folder to put the model inside of, or if you have a folder with some streamed assets, you can put it there as well. In this example, I have a dummy resource named _cdn-fool_.
![Streaming the Electric Charger Models GIF](https://user-images.githubusercontent.com/95599217/209604683-79e18fa7-96ad-456d-b0c4-20632fb4d04c.gif) 


**Next**, we will move our _fxmanifest.lua's_ entries for _data_file_ into our new resource, and **REMOVE IT** from _cdn-fuel_.
```Lua
data_file 'DLC_ITYP_REQUEST' 'stream/[electric_nozzle]/electric_nozzle_typ.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/[electric_charger]/electric_charger_typ.ytyp'
```
![YTYP Moving GIF](https://user-images.githubusercontent.com/95599217/209604640-54e0a450-6a54-4afa-9fab-cda4f02e7091.gif)

### 7. QB-Target Global Vehicle Fix
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

![QB-Target Addition Example](https://i.imgur.com/UOgPJRi.png)
<br> 
*This is **specifically** for the "**boot**" bone, but, add it on which bone you are having trouble with.*

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

Lastly, add the following to the top of your _init.lua_ in QB-Target:
```Lua
local Allowrefuel = false
local AllowElectricRefuel = false
```

Now, set the *Config.FuelTargetExport* in *cdn-fuel/shared/config.lua* to **true**.
<br>

![Step 7 | Config Option Toggled Image](https://i.imgur.com/InBl500.png)


### 8. Starting CDN-Fuel
Make sure to **ensure** this new resource as well as _cdn-fuel_ in your _server.cfg_!


## You are now officially done installing!
Enjoy using **cdn-fuel**, if you have an issues, [create an issue](https://github.com/CodineDev/cdn-fuel/issues/new/choose) on the repository, and we will fix it **ASAP!**
<br>

### Codine Links

- [Discord](https://discord.gg/Ta6QNnuxM2)
- [Youtube](https://www.youtube.com/channel/UC3Nr0qtyQP9cGRK1m25pOqg)

### Credits:

- **OX Conversion:**
<br><img src="https://avatars.githubusercontent.com/u/6962192?v=4" width="25" height="25">
**[NoobySloth](https://github.com/noobysloth)**
for making the initial **OX** portion of the script. 
<br>
<img src="https://avatars.githubusercontent.com/u/82969741?v=4" width="25" height="25">
**[xViperAG](https://www.github.com/xViperAG)** for adding more OX functionality & support for QBox Remastered.

- **Initial Fuel System**
<br>
<img src="https://avatars.githubusercontent.com/u/22295402?v=4" width="25" height="25">
[InZidiuZ](https://github.com/InZidiuZ) for making [LegacyFuel](https://github.com/InZidiuZ/LegacyFuel) alongside all [contributors](https://github.com/InZidiuZ/LegacyFuel/graphs/contributors)!