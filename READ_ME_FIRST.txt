
[Guide] Enabling VoLTE/VoWiFi v2

   Thread starter HomerSp Start date Jan 1, 2020 

Try this first. Dont forget to cycle the mobile data connection and sim card to see if it worked.

Preface
With this guide I can officially deprecate the other guide I wrote, as we will no longer have to hack together a solution by loading profiles for other carriers. Meaning, that this should just work provided an mbn exists for your carrier - doesn't matter from which device. This has been reported to work on TMO in the US, which did not work with my other method.

Prerequsities
* You must have working DIAG mode. See my other thread for more information on how to set that up.

Downloads
* AsusVoLTE v1.0.1
* EfsTools 0.10 modded 1.2
* EFS items
* Xiaomi Mi 9T MBNs (optional)

Step 1 - setting props
Install the AsusVoLTE app from above, make sure to upgrade if you already have it installed. Run the app and press the Enable VoLTE button; this should set some properties on the device to force-enable VoLTE after we have also done the other steps below. If you already enable VoLTE using my old method you can safely skip this step.
If you prefer to not use the app, simply run this in an adb shell:
Code:

setprop persist.vendor.dbg.ims_volte_enable 1
setprop persist.vendor.dbg.volte_avail_ovr 1
setprop persist.vendor.dbg.vt_avail_ovr 1
setprop persist.vendor.dbg.wfc_avail_ovr 1


If you are unable to set those properties for whatever reason, like if you have returned to stock after flashing the mbn and no longer have root, there is another possibility to force VoLTE/VoWiFi; There's a secret code you can use to force-enable it, but unfortunately it does not survive a reboot (not sure why ASUS didn't make it persistent).
Enter this in the dialler:
Code:

*#*#3642623344#*#*

The number will clear itself, and you shouldn't see any output if it succeeded.
When you have done this, go to (System) Settings -> Mobile network and toggle Mobile data off then on again. You should hopefully see the VoWiFi or VoLTE icon in the status bar now, but like I said above you will have to redo this if you reboot the phone - so if you can, please use the properties method instead.

Step 2 - making sure it works
Before we begin, make sure you close down QPST, otherwise EfsTools will error out because there can not be two clients connected at once.
Unzip EfsTools from above, open up a cmd window and cd to the directory where you extracted it. Depending on how you connect to diag you will need to modify EfsTools.exe.config - if you're connecting via USB you most likely won't have to do anything as it will find the port automatically, unless you have more than one port, in which case you can simply change port from Auto to the COM port of the phone (for example COM13).
If you are connected via wifi you will need to change port to 2500 (or whatever port you used in the AsusVoLTE app) and remote to true. So the efstool line should look something like this:
Code:

<efstool port="2500" remote="true" baudrate="38400" password="FFFFFFFFFFFFFFFF" spc="000000"/>

You can test the connection by running this in the cmd window:
Code:

EfsTools.exe efsInfo

This should report back some info if everything is working. If not, try rebooting the device and redo the bits from the DIAG guide.

Step 3 - disabling mcfg
Extract efs.zip from above to the same directory as EfsTools.exe, and make sure the mcfg_autoselect_by_uim file is there. Now simply run this in the cmd window, one line at a time:
Code:

EfsTools.exe writeFile -i mcfg_autoselect_by_uim -o /nv/item_files/mcfg/mcfg_autoselect_by_uim
EfsTools.exe writeFile -i mcfg_autoselect_by_uim -o /nv/item_files/mcfg/mcfg_autoselect_by_uim -s 1

If everything worked you should see no error messages.

Step 4 - writing mbn
If you are using the Xiaomi Mi 9T mbns zip from above, move it to the EfsTools directory and extract it. Now we simply need to find the mbn for your carrier.
The mbn directory structure is generally laid out like this: <region>/<carrier>/commerci/<country>/mcfg_sw.mbn. For example, the one for my carrier is eu/h3g/commerci/se/mcfg_sw.mbn. Copy the mcfg_sw.mbn file to the same directory as the EfsTools.exe, then go to the cmd window you opened and type this:
Code:

EfsTools.exe uploadDirectory -i mcfg_sw.mbn -o / -v

To get it working on the second SIM slot you will also have to run this:
Code:

EfsTools.exe uploadDirectory -i mcfg_sw.mbn -o / -s 1


If it has worked you should see a bunch of output, but no errors. Try rebooting now, and hopefully after it has booted you will have fully functional VoLTE and VoWiFi.

Source code:
AsusVoLTE - Github
EfsTools - Github

Let me know if this works for you, or if you have any questions.

Regards