+++
title = "Hardware Setup"
description = "COTS embedded camera system"
date = "2020-08-14"
author = "Christian Decker"
sec = 4
+++

<style>
img {
  max-width: 100%;
  height: auto;
}
</style>


We use [Raspberry Pi 3, Model B+](https://en.wikipedia.org/wiki/Raspberry_Pi) as the platform for the COTS embedded camera system. It connects to a [Raspberry Pi camera module] (https://www.geeetech.com/wiki/index.php/Raspberry_Pi_Camera_Module).

The regular electricity meter is inside a switch cabinet. The inner side of the cabinet's door holds the Raspberry Pi and the camera using magnets. The following picture shows the installation.

<img src="img/smeter_install.jpg" alt="SmartMeter installation" width="400px"/>

There are only 3 centimeters between the meter's display and the cabinet door. The camera looks at the display via the mirror. A Raspberry powered USB light supplies sufficient brightness for the camera to take pictures. The next picture shows the components.

<img src="img/smeter_front.jpg" alt="SmartMeter components" width="400px"/>

The picture shows how the installation is oriented towards the meter when the door is closed.

<img src="img/smeter_inside.jpg" alt="SmartMeter inside" width="400px"/>

When operating the camera captures a mirrored image of the electricity meter's display. Rotating and mirroring it will show the number correctly.

| Original image| Image rotated and mirrored  |
| ------------- | -------------   |
| <img src="img/metercam.png" alt="image captured by meter camera" width="75%" /> | <img src="img/metercam_numbers.png" alt="meter camera" /> |

