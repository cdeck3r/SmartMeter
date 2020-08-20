+++
title = "System Design"
description = "Design of the software/hardware system"
date = "2020-08-14"
author = "Christian Decker"
sec = 3
+++

<style>
img {
  max-width: 100%;
  height: auto;
}
</style>

This use case diagram depicts SmartMeter’s main services.

<img src="uml/uc_systemdesign.png" alt="system main services" />

The brief design sketch below shows SmartMeter’s hardware and software components. The local embedded camera system uploads the pictures on Dropbox. The server is a remote host on the Internet downloads them from there and performs the OCR processing.

<img src="uml/cp_systemdesign.png" alt="system main components"  />

The current design distributes some main services as well as the data across several systems on the Internet. This has implications on data and privacy protection. Although all connections are encrypted, potentially sensitive data is stored outside the physical boundaries of the house, therewith, making data and privacy vulnerable. Special attention needs to be paid on access restriction as well as on data management, e.g. data retention. 

An alternative is to perform all processing on the embedded camera system. This will keep all data local. We leave this for future work.
