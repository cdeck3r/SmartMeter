# SmartMeter

Our goal is to improve our energy footprint. Therefore, we aim for a fine-grained tracking of the electricity consumption in a family home. 

The project has its own website under https://cdeck3r.com/SmartMeter.

## Project Description

A COTS camera-based embedded computer system takes pictures of a regular electricity meter. A server software performs an OCR and converts the pictures into numbers. Finally, a statistics report reveals some insights on consumption patterns and behaviors which enables us to improve our energy footprint.

This is a tiny research project. It focusses on software for 

* reliably taking pictures
* data management across various systems at home as well as on the Internet
* AI based optical character recognition
* unattended operation
* fine-grained consumption statistics

Expected results

* 24/7 solution delivering electricity consumption data
* Set of real world pictures used for future AI projects

Learning goals

* Methods and tools for AI based image processing
* Assess the maturity and ease of use of available tools

## Hardware

The COTS camera-based embedded system is a [Raspberry Pi 3](https://en.wikipedia.org/wiki/Raspberry_Pi) with a [Raspberry Pi camera module] (https://www.geeetech.com/wiki/index.php/Raspberry_Pi_Camera_Module) connected to it. Follow the [instruction](https://projects.raspberrypi.org/en/projects/getting-started-with-picamera) for connecting and first steps using the Pi camera module

Images are stored on Dropbox and processed by a cloud server on the Internet.

## Quickstart

Raspberry Pi software setup

* use a standard RaspiOS image
* connect the camera
* install the software from repo's `raspi` directory

Server software setup

* linux system required 
* install the software from the repo's `server/` directory 
* *TBD: there is a docker image*

For full instructions see

* [install_raspi.md](install_raspi.md)
* install_server.md

## Development

Start in project's root dir. Create docker image

```bash
docker-compose build smeter-dev 
```

Spin up the container and get a shell from the container
```bash
docker-compose up -d smeter-dev
docker exec -it smeter-dev /bin/bash
```

Run the following workflow to generate the documentation for the project website

```bash
cd /SmartMeter/scripts
snakemake doc --cores 1
```