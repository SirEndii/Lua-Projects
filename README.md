# Lua-Projects

These are my personal lua based projects for computercraft and [advanced peripherals](https://github.com/SirEndii/AdvancedPeripherals).

I mainly made them to show examples for advanced peripherals. 

If you want to use one of the scripts, you're free to go.
You can find specific instructions for the scripts online at our documentation, as example the [me bridge](https://docs.intelligence-modding.de/1.16/peripherals/me_bridge/).

You can install all scripts via the installer. The installer will install the script and the needed libraries

As example the automatic autocraft script for the me bridge

- First you want to install the installer:

`wget https://raw.githubusercontent.com/SirEndii/Lua-Projects/master/src/installer.lua installer`

- To see all currently available scripts, you can run `installer list`

![image](https://user-images.githubusercontent.com/67484093/208305492-a1a357c1-a954-491f-beab-44c49d3101a1.png)

- Now install the script you want. As example the ME Autocraft script `installer install meautocraft` This will install the script and the needed libraries.

![image](https://user-images.githubusercontent.com/67484093/208305656-956254f0-c82b-4f6a-8e15-dd0da9fc0f11.png)

The script is located at `NAME/SCRIPT.lua`. For the autocraft script this would be `meautocraft/meautocraft.lua`

It also creates an `startup` script for you. So you should delete any `startup` script you may have on your computer before installing the script.
