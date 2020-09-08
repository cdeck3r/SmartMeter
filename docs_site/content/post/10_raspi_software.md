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


The SmartMeter camera software runs on the Raspberry Pi. It takes pictures and uploads them to Dropbox. The central script `smeter.sh` controls all functions.

For installation instruction see [install_raspi.md](https://github.com/cdeck3r/SmartMeter/blob/master/install_raspi.md).

### Scheduling

An external timer switch powers-on the Raspberry Pi at a pre-defined time. After the reboot the cron scheduler runs the central control script [`smeter.sh`](https://github.com/cdeck3r/SmartMeter/blob/master/raspi/smeter.sh), which takes the pictures (`takepicture.sh`) and uploads them to Dropbox (`fileservice.sh`). At the end, the script shuts down the Raspberry Pi. At a later time the external timer switch powers-off. 

The timer switch has only 28 slots for defining on and off times. This is not sufficient for 15 min intervals per hour. We define a coarse-grained timer duty cycle of 50% within 1 hour, which consists of 30 min power-on duty and 30 min when the Raspberry is powered off. In the power-on duty time, the `smeter.sh` control script performs three measurement activities at 0, 15, 30 min after the start. This schedule achieves three 15 min intervals and leaves out one within a hour. The exact schedule deviates a bit from this description in order to give time management activities to take place before the external timer switch powers-off. The sleep delay after the cron scheduler starts gives time for the OS to bring the ressources online. The following figure depicts the schedule.

<img src="uml/sd_schedule.png" alt="SmartMeter software on Raspi" />

The schedule repeats as soon as the external timer switch powers-on the Raspberry Pi again.


### Maintenance Mode

The above schedule makes it difficult to do maintenance activities. A developer needs to login after the bootup and stop the `smeter.sh` script before the Raspberry Pi shuts down. 

**Maintenance mode:**

> The control script checks for a USB thumb drive at its startup. If it finds the file `maintenance` in the root directory, it will disable the shutdown at the end of `smeter.sh` control script.

The developer has to set the external time switch to permanent on in order to avoid further powers-off.

The [`maintenance.sh`](https://github.com/cdeck3r/SmartMeter/blob/master/raspi/maintenance.sh) script implements the check for the maintenance mode. The following figure depicts the maintenance mode setting in `smeter.sh` as an activity diagram.

<img src="uml/ac_maintenance.png" alt="Maintenance mode of the SmartMeter camera software"/>


### Log Rotation

We use standard linux tool `logrotate`. The config file `logrotate.conf` defines the parameters and resides in the same directory as the other scripts. `logrotate.sh` has the following functions:

1. Call the linux tool `logrotate` on the `log` directory
1. Upload the logfiles to dropbox

The central control script `smeter.sh` calls `logrotate.sh` before the duty cycle ends and the system shuts down.

### Logfile Analysis

The scripts like `smeter.sh`, `fileservice.sh`, `logrotate.sh` report their actions in a logfile. A typical log line looks like the following example.

```
2020-08-31 01:02:01,1598828521 - /home/pi/smartmeter/smeter.sh - INFO - SmartMeter camera system starts.
```

Apart from regular log lines the logfiles contain all other script output as well. Run the following command to cleanup the logfiles and only store log lines in `smartmeter.log`.
```bash
src/filterlog.sh > smartmeter.log
```

An R jupyter notebook runs the analysis and computes various summary statistics. An important output is the boxplot figure below. It shows the varying runtime of different scripts. One gains insight in the regular runtime behavior of the SmartMeter software.

<img src="img/activity_durations.png" alt="Durations of the scripts as result of logfile analysis" />

The following table displays summary stats for each script. Each number reports the runtime in seconds.

|         | `smeter.sh` | `fileservice.sh` | `logrotate.sh` |
|---------|-----------|----------------|--------------|
| Min.    | 1738      | 38.0           | 9.00         |
| 1st Qu. | 1739      | 39.0           | 10.00        |
| Median  | 1740      | 41.0           | 10.00        |
| Mean    | 1742      | 41.1           | 10.96        |
| 3rd Qu. | 1743      | 42.0           | 11.00        |
| Max.    | 1752      | 52.0           | 17.00        |

The complete logfile analysis is available as an R jupyter notebook. The notebook runs on [mybinder](https://mybinder.org/). Just click the badge below to run a recent analysis.
