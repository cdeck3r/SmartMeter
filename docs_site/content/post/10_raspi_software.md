+++
title = "SmartMeter Camera Software"
description = "Software for the SmartMeter camera system"
date = "2020-08-19"
author = "Christian Decker"
sec = 10
+++

<style>
img {
  max-width: 100%;
  height: auto;
}
</style>


The SmartMeter software runs on the Raspberry Pi. It takes pictures and uploads them to Dropbox. The central script `smeter.sh` controls all functions.

### Scheduling

An external timer switch powers-on the Raspberry Pi at pre-defined time. After the reboot the crontab runs the central control script [`smeter.sh`](https://github.com/cdeck3r/SmartMeter/blob/master/raspi/smeter.sh), which takes the pictures (`takepicture.sh`) and uploads them to Dropbox (`fileservice.sh`). At the end, the script shuts down the Raspberry Pi. At a later time, the external timer switch powers-off. 

The timer switch has only 28 slots for defining on and off times. This is not sufficient for 15 min intervals per hour. We define a coarse-grained timer duty cycle of 50% within 1 hour, which consists of 30 min power-on duty and 30 min when the Raspberry is powered off. In the power-on duty time, the `smeter.sh` control script performs three measurement activities at 0, 15, 30 min after the start. This schedule achieves three 15 min intervals and leaves out one within a hour. The exact schedule deviates a bit from this description in order to give time management activities to take place before the external timer switch powers-off. The following figure depicts the schedule.

<img src="uml/sd_schedule.png" alt="SmartMeter software on Raspi" />

The schedule repeats as soon as the external timer switch powers-on the Raspberry Pi again.


### Maintenance Mode

The above schedule makes it difficult to do maintenance activities. A developer needs to login after the bootup and stop the `smeter.sh` script before the Raspberry Pi shuts down. 

**Maintenance mode:**

> The control script checks for a USB thumb drive at its startup. If it finds the file `maintenance` in the root directory, it disables the shutdown.

The developer has to set the external time switch to permanent on in order to avoid powers-off .

The [`maintenance.sh`](https://github.com/cdeck3r/SmartMeter/blob/master/raspi/maintenance.sh) script implements the check for the maintenance mode. The following figure depicts the maintenance mode setting in `smeter.sh` as an activity diagram.

<img src="uml/ac_maintenance.png" alt="Maintenance mode of the SmartMeter camera software"/>


### Log Rotation

We use standard linux tool `logrotate`. The config file defines the parameters and resides in the same directory as the other scripts. `logrotate.sh` has the following functions:

1. Call the linux tool `logrotate`
1. Upload the logfiles to dropbox

The central control script `smeter.sh` calls the `logrotate.sh` after the picture upload.




 