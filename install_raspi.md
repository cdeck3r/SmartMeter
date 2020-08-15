# Install Raspberry Pi

Tested with

* Raspberry Pi 3 model B+
* [RaspiOS image](https://www.raspberrypi.org/downloads/raspberry-pi-os/) with desktop and recommended software, Release date 2020-05-27 

## Setup SmartMeter software

Install the project's SmartMeter software on the Raspberry Pi.

* Copy the content of `raspi` directory onto the Raspberry Pi

##### **Setup Dropbox Uploader**

GitHub repo of Dropbox Uploader: https://github.com/andreafabrizi/Dropbox-Uploader

You will need a dropbox account.

1. Go to https://www.dropbox.com/developers/apps and login
1. Click on *Create App*, 
1. In section 1, select first radio button *Scoped access* 
1. In section 2, select *App folder* 
1. In section 3, name your app
1. Finally, hit *Create App*
1. on the next screen tick all permissions for *Files and folders*, but not `files.permanent_delete`
1. set the `Access token expiration` to `No expiration` 
1. click on the *Generate* button
1. copy the access token in the file `~/.dropbox_uploader` on the Raspberry Pi


##### **Run SmartMeter as a cronjob**

Install the provided cronjob example [smartmeter.crontab](https://github.com/cdeck3r/SmartMeter/blob/master/raspi/smartmeter.crontab)

```bash
crontab smartmeter.crontab
crontab -l
```

The last line verifies that the cronjob got installed. The example schedules the script every 15 minutes within a full hour starting at minute 5. So, it runs 0:05, 0:20, 0:35, ...

## Bare Raspberry Pi Setup 

These instructions describe the initial setup of an unboxed, brand-new Raspberry Pi. 

Tools

* [SD Formatter portable](https://sourceforge.net/projects/thumbapps/files/Utilities/SD%20Card%20Formatter/): format SD card
* [Etcher](https://github.com/balena-io/etcher/releases/download/v1.5.102/balenaEtcher-Portable-1.5.102.exe): create bootable SD card from image; 
* putty / [WinSCP 5.17.7](https://winscp.net/download/WinSCP-5.17.7-Portable.zip): ssh to raspberry pi


### Prepare RaspiOS

1. format SD card using SD formatter
1. Flash the image using Etcher
1. add empty file `SSH` to SD card's root directory

### Boot and login

1. Insert SD card into raspberry Pi and bootup
1. SSH into pi
    * host: raspberrypi.local
    * user: pi
    * pass: raspberry
    
### Setup on shell prompt 

1. Run: `sudo raspi-config`
    * enable VNC, see menu `Interfacing Options`
    * configure screen resolution, see `Advanced Options -> Resolution`
1. Configure VNC to accept other auth method, required if you want to VNC into the raspi with another viewer than realvnc 
    * root shell: `sudo su` 
    * Add the following lines at the end of `/root/.vnc/config.d/vncserver-x11`
```
Authentication=VncAuth
Encryption=AlwaysOff
Password=e0fd0472492935da
```
    * Password is set to *foobar*. Use `vncpasswd -server` to create a new one.
1. Reboot or restart VNC server: `systemctl restart vncserver-x11-serviced.service`     
    
### Service GUI using VNC

1. Use a VNC client of your choice
    * Server: `raspberrypi.local`
    * Password: `foobar`
1. Complete setup on the service GUI

