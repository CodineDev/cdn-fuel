![Codine Development Fuel Script Banner](https://i.imgur.com/qVOMMvW.png)

### cdn-fuel

A functionality fuel system based off of [ps-fuel](https://github.com/Project-Sloth/ps-fuel) that uses PolyZones that target fueling pumps and vehicles to allow you to refuel your vehicle, as well as interact-sound to play accurate refueling sounds.

## Major Credits

Major shoutout to the Project Sloth team. We based this script off of their wonderful ps-fuel script. We wanted to change it up a little bit, but ended up doing a lot more than originally planned, so we though we'd release this on it's own rather than PR things. (https://github.com/Project-Sloth/ps-fuel)

### Dependencies:

- [qb-target](https://github.com/BerkieBb/qb-target)
- [qb-menu](https://github.com/qbcore-framework/qb-menu)
- [qb-input](https://github.com/qbcore-framework/qb-input)
- [interact-sound](https://github.com/plunkettscott/interact-sound)
- [polyzone](https://github.com/qbcore-framework/PolyZone)

<br>
<br>

![Codine Development Fuel Script Install Banner](https://i.imgur.com/bEiV8G0.png)

### Begin your installation

Here, we shall provide a step-by-step guide on installing cdn-fuel to your server and making it work with other scripts you may already have installed.

### Step 1:

First, we will start by renaming the resource "cdn-fuel-main" to just "cdn-fuel". <br> <br> Next, we will drag the "cdn-fuel" resource into your desired folder in your servers resources directory.

![Step 1](https://i.imgur.com/8kg0LWe.gif)

### Step 2:

Next, we're going to drag the sounds from the *cdn-fuel/assets/sounds* folder in cdn-fuel, into your interact-sounds folder located at *resources/[standalone]/interact-sound/client/html/sounds*

![Step 2](https://i.imgur.com/4Mox2wP.gif)

### Step 3:

Next, we're going to open our entire resources folder in whichever IDE you use, (we will be using Visual Studio Code for this example) and replace all of your current exports titled "LegacyFuel", "ps-fuel" or "lj-fuel", with "cdn-fuel". Then you want to ensure cdn-fuel in your server's config file. 
<br> <br>
![step 3](https://i.imgur.com/VZnQpcS.gif)

<br>

**If you do not want the Jerry Can or Syphoning Kit items, you are now finished with installation.**

<br>
*Otherwise, navigate to Step 4 & Step 5 below, and finish installation.*

### Step 4:
We will now be installing the Jerry Can & Syphoning Kit items into your server. You don't have to install either, but they are recommended additions. You can install them & disable them in the config, until you want to use them later on! 
<br> <br>
If you plan to not use them, you can skip this Step and Step 5!
<br> <br>
The first step of installing our items is to navigate to your *qb-core/shared/items.lua*.
<br> <br>
Once there, we will paste the following items at the bottom of our items table.
```
	["syphoningkit"]				 = {["name"] = "syphoningkit", 					["label"] = "Syphoning Kit", 			["weight"] = 5000, 		["type"] = "item", 		["image"] = "syphoningkit.png", 		["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "A kit made to siphon gasoline from vehicles."},
	["jerrycan"]				 	 = {["name"] = "jerrycan", 						["label"] = "Jerry Can", 				["weight"] = 15000, 	["type"] = "item", 		["image"] = "jerrycan.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,   ["combinable"] = nil,   ["description"] = "A Jerry Can made to hold gasoline."},
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
```
} else if (itemData.name == "harness") {
```
Once you have found this line, copy the following one line above it:
<br> 
```
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

### Step 5:
This step is only necessary for you to be able to do the */giveitem* command or to put items in the qb-shops.

Navigate to inventoryname/server/server.lua, and CTRL + F the following line:
```
				elseif itemData["name"] == "harness" then
					info.uses = 20
```
<br>
Now we will add the following above the line below:

```
				elseif itemData["name"] == "syphoningkit" then
					info.gasamount = 0
				elseif itemData["name"] == "jerrycan" then
					info.gasamount = 0
```

Alternatively, watch this GIF to better understand the process:
<br>
![Step 5 GIF](https://i.imgur.com/yrkR7cJ.gif)

<br> 

##### QB-Shop Setup

Here are some preconfigured shop items if you wish to put them in the shop. (The Jerry Can is buyable via the Gas Pump!)

```
        [10] = {
            name = "syphoningkit",
            price = 5000,
            amount = 5,
            info = { gasamount = 0 },
            type = "item",
            slot = 10,
        }, -- CDN-Fuel / CDN-Syphoning
        [11] = {
            name = "jerrycan",
            price = 750,
            amount = 5,
            info = { gasamount = 0 },
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
```
            {
				type = "client",
				event = "cdn-fuel:client:SendMenuToServer",
				icon = "fas fa-gas-pump",
				label = "Insert Nozzle",
				canInteract = function() return Allowrefuel end
            },
```

*Here is an example of how to add this option:*

![Step5part33 QB-Target](https://i.imgur.com/UOgPJRi.png)
<br> 
*This is **specifically** for the "**boot**" bone, but, add it on which bone you are having trouble with.*

<br>
<br>

*Next, we'll add this simple Function & Export into our QB-Target in the Functions() area:*

```
local function AllowRefuel(state) 
    if state then
        Allowrefuel = true
    else
        Allowrefuel = false
    end
end exports('AllowRefuel', AllowRefuel)
```

<br> 

**Example Image:**

![Step5 Part 421421412](https://i.imgur.com/pwpa5Tk.png)

Now, set the *Config.FuelTargetExport* in *cdn-fuel/shared/config.lua* to **true**.

<br> 

![Step5 Part 1421942151251](https://i.imgur.com/InBl500.png)

### You are now officially done installing!

<br> 

Enjoy using **cdn-fuel**, if you have an issues, create an issue on the repository, and we will fix it **ASAP**!

<br>
<br>

![Codine Development Fuel Script Features Banner](https://i.imgur.com/ISHQJUL.png)

#### Some features to mention within cdn-fuel:

- Show all gas station blips via Config Options.
- Vehicle blowing up chance percent via Config Options.
- Pump Explosion Chance when running away with Nozzle via Config Options.
- Global tax and fuel prices via Config Options.
- Target eye for all base fuel actions, not including Jerry Can & Syphoning.
- Menu estimating cost for vehicle being refueled. (Tax Included)
- Fuel Nozzle prop and realistic fueling animation.
- Added sounds when taking and replacing fuel nozzle, as well as refueling.
- Select amount of fuel you want to put in your vehicle.
- On cancel, the amount you put in will be filled.
- Option to pay cash or with your bank.
- Toggleable Jerry Cans via Config Options.
- [CDN-Syphoning](https://github.com/CodineDev/cdn-syphoning) built-in via Config Options.

<br>
<br>

![Codine Development Fuel Script Showcase Banner](https://i.imgur.com/HQOH3AX.png)

### Demonstration of the script

Here's a couple of videos showcasing the script in action!

- [Main Fueling!](https://www.youtube.com/watch?v=1TimPMCfHsM) 
- [Jerry Cans!](https://www.youtube.com/watch?v=M14nZTzltB0)
- [Siphoning!](https://youtu.be/2CJjM_9hmNA)

<br>
<br>

![Codine Development Fuel Script Future Plans Banner](https://i.imgur.com/1RoBsmo.png)

### Future Plans

Future Plans are located on the [Wiki Section](https://github.com/CodineDev/cdn-fuel/wiki) of this repository, labeled [CDN-Fuel Roadmap](https://github.com/CodineDev/cdn-fuel/wiki).

<br>
<br>

![Codine Development Links Banner](https://i.imgur.com/SAqArzg.png)

### Codine Links

- [Discord](https://discord.gg/Ta6QNnuxM2)
- [Tebex](https://codine.tebex.io/)
- [Youtube](https://www.youtube.com/channel/UC3Nr0qtyQP9cGRK1m25pOqg)

### Credits:

Massive shoutout once again to the team at [Project Sloth](https://github.com/Project-Sloth)! <br><br> They create super sick scripts that have changed the game when it comes to fivem server development.
This script is based off of their [ps-fuel script](https://github.com/Project-Sloth/ps-fuel).
