+++
title = "Conclusion"
description = "Summary, conclusion and next steps"
date = "2020-08-14"
author = "Christian Decker"
sec = 99
+++

SmartMeter records the overall electricity consumption in a family home. It augments a regular electricity meter with an COTS embedded camera system. A server software creates a consumption report providing insights in energy usage patterns.

The list below displays the achieved objectives:

* [X] reliably taking pictures
* [ ] data management across various systems at home as well as on the Internet
* [ ] AI based optical character recognition
* [ ] unattended operation
* [ ] fine-grained consumption statistics

In the current design, data is stored and processed on an Internet server outside the physical boundaries of the house. In a future SmartMeter implementation, all processing and data handling will be performed on the embedded camera system. This will improve the situation on privacy and data protection.