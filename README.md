![Codine Development Fuel Script Banner](https://i.imgur.com/qVOMMvW.png)

### cdn-fuel

A NoPixel inspired functionality fuel system based off of ps-Fuel that uses PolyZones that target fueling pumps and vehicles to allow you to refuel your vehicle, as well as interact-sound to play accurate refueling sounds.

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

First, we will start by renaming the resource "cdn-fuel-main" to just "cdn-fuel". Next, we will drag the "cdn-fuel" resource into your desired folder in your servers resources directory.

![step_1](https://i.imgur.com/8kg0LWe.gif)

### Step 2:

Next, we're going to drag the sounds from the "sounds" folder in cdn-fuel, into your interact-sounds folder located at "resources/[standalone]/interact-sound/client/html/sounds"

![step 2](https://i.imgur.com/4Mox2wP.gif)

### Step 3:

Lastly, we're going to open our entire resources folder in whichever IDE you use, (we will be using Visual Studio Code for this example) and replace all of your current exports titled "LegacyFuel", "ps-fuel" or "lj-fuel", with "cdn-fuel". Then you want to ensure cdn-fuel in your servers config file.

![step 3](https://i.imgur.com/VZnQpcS.gif)

<br>
<br>

![Codine Development Fuel Script Features Banner](https://i.imgur.com/ISHQJUL.png)

#### Some features to mention within this cdn-fuel:

- Show all gas station blips (found in shared/config.lua)
- Vehicle blowing up chance percent (found in shared/config.lua)
- Global tax and fuel prices (found in shared/config.lua)
- Target eye for all actions
- Menu estimating cost for vehicle being refueled (tax included)
- Fuel Nozzle prop and realistic fueling animation
- Added sounds when taking and replacing fuel nozzle, as well as refueling
- Select amount of fuel you want to put in your vehicle
- Option to pay cash or with your bank

<br>
<br>

![Codine Development Fuel Script Showcase Banner](https://i.imgur.com/HQOH3AX.png)

### Demonstration of the script

Here's a video showcasing the script in action!

[Click Here to Watch the Video!](https://youtu.be/ihZXGyOpliw)

<br>
<br>

![Codine Development Fuel Script Future Plans banner](https://i.imgur.com/1RoBsmo.png)

### Future Plans

- Add support for electric vehicles. (include mapping for electric chargers)
- Add back in support for jerry cans
- Send suggestions in our discord server!

<br>
<br>

![Codine Development Links Banner](https://i.imgur.com/SAqArzg.png)

### Codine Links

- [Discord](https://discord.gg/Ta6QNnuxM2)
- [Tebex](https://codine.tebex.io/)
- [Youtube](https://www.youtube.com/channel/UC3Nr0qtyQP9cGRK1m25pOqg)

### Credits:

Massive shoutout once again to the team at Project Sloth! (https://github.com/Project-Sloth) They create super sick scripts that have changed the game when it comes to fivem server development.
This script is based off of thier ps-fuel script. (https://github.com/Project-Sloth/ps-fuel)
