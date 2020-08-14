# Install Raspberry Pi

Tested with

* Raspberry Pi 3 model B+
* [RaspiOS image](https://www.raspberrypi.org/downloads/raspberry-pi-os/) with desktop and recommended software, Release date 2020-05-27 

## Setup SmartMeter software

Install the project's SmartMeter software on the Raspberry Pi.

...


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

