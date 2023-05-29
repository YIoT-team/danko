# YIoT Danko: Project Status

<a href="https://cdn.yiot.dev/docs/devices/cv-2se.pdf"><img width="500px" src="https://cdn.yiot.dev/docs%2Fimages%2FDIN1_2.png" align="center" hspace="1" vspace="1"></img></a>

[PDF Documentation](https://cdn.yiot.dev/docs/devices/cv-2se.pdf)

YIoT Danko is a protocols converter and security processor for protocols such as: 

- ModbusASCI/RTU/TCP
- MQTT
- SNMP
- WebSocket

It works with RS485, Ethernet, WiFi, and 4G/5G. The industrial applications of  YIoT Danko include facilitating security for industrial infrastructures.

YIoT Danko secures the infrastructure communication between internal and external entities while also introducing a layer of security in industrial cloud services and operations. This security protocol leverages the `zero-trust` security principle which maximizes its ability to protect critical assets while minimizing potential security threats and risks.

YIoT Danko offers flexible and compact data filtration capabilities that enable experts to consolidate and analyse data to derive critical insights and specific pieces of information. The flexible data filtration capabilities of this protocol ensure that data present in the infrastructure flows smoothly and safely without interruptions and security complications.


## YIoT Danko components


### YIoT Portal

User-friendly services orchestrator. It helps to run different services. Personal VPN server, MQTT broker, NodeRed etc. These services can be in the Cloud and on premise.
All services can have different access type: VPN only, Public, both.

VPN helps to control access to your private data or to  make an internal data available globally.

There is an integration with discord.

Some links to video:

- [Creation of personal VPN server](https://www.linkedin.com/feed/update/urn:li:activity:7016300934557241345)
- [NodeRed reads data from remote server via VPN](https://www.linkedin.com/feed/update/urn:li:activity:7018319836275494912)

Screenshots:

<a href="https://cdn.yiot.dev/docs%2Fimages%2Fnodered-creation.png"><img width="400px" src="https://cdn.yiot.dev/docs%2Fimages%2Fnodered-creation.png" align="center" hspace="1" vspace="1"></img></a>
<a href="https://cdn.yiot.dev/docs%2Fimages%2Fvpn.png"><img width="400px" src="https://cdn.yiot.dev/docs%2Fimages%2Fvpn.png" align="center" hspace="1" vspace="1"></img></a>


<a href="https://cdn.yiot.dev/docs%2Fimages%2Fvpn-clients.png"><img width="400px" src="https://cdn.yiot.dev/docs%2Fimages%2Fvpn-clients.png" align="center" hspace="1" vspace="1"></img></a>
<a href="https://cdn.yiot.dev/docs%2Fimages%2Fvpn-qr.png"><img width="400px" src="https://cdn.yiot.dev/docs%2Fimages%2Fvpn-qr.png" align="center" hspace="1" vspace="1"></img></a>

<a href="https://cdn.yiot.dev/docs%2Fimages%2Fmqtt-status.png"><img width="400px" src="https://cdn.yiot.dev/docs%2Fimages%2Fmqtt-status.png" align="center" hspace="1" vspace="1"></img></a>
<a href="https://cdn.yiot.dev/docs%2Fimages%2Fmqtt-topics.png"><img width="400px" src="https://cdn.yiot.dev/docs%2Fimages%2Fmqtt-topics.png" align="center" hspace="1" vspace="1"></img></a>

### YIoT Danko devices

YIoT Danko is OpenWRT-based OS. It uses the latest OpenWRT with docker. Target hardware are x86_64 and ARM64. 

<a href="https://cdn.yiot.dev/docs%2Fimages%2Fdanko-login.png"><img width="400px" src="https://cdn.yiot.dev/docs%2Fimages%2Fdanko-login.png" align="center" hspace="1" vspace="1"></img></a>


YIoT Danko gives possibility to easily create local **VPN server** or to add multiple **VPN client** connection.

<a href="https://cdn.yiot.dev/docs%2Fimages%2Fdanko-vpn-server.png"><img width="400px" src="https://cdn.yiot.dev/docs%2Fimages%2Fdanko-vpn-server.png" align="center" hspace="1" vspace="1"></img></a>

<a href="https://cdn.yiot.dev/docs%2Fimages%2Fdanko-vpn-client-add.png"><img width="400px" src="https://cdn.yiot.dev/docs%2Fimages%2Fdanko-vpn-client-add.png" align="center" hspace="1" vspace="1"></img></a>
<a href="https://cdn.yiot.dev/docs%2Fimages%2Fdanko-vpn-clients.png"><img width="400px" src="https://cdn.yiot.dev/docs%2Fimages%2Fdanko-vpn-clients.png" align="center" hspace="1" vspace="1"></img></a>



On configure specific data processing using functional block diagrams. Like: NAT, proxies, data filtering.

<a href="https://cdn.yiot.dev/docs%2Fimages%2Fdanko-fbd.png"><img width="400px" src="https://cdn.yiot.dev/docs%2Fimages%2Fdanko-fbd.png" align="center" hspace="1" vspace="1"></img></a>

Also, YIoT Danko has Luci access adwanced configuration.

<a href="https://cdn.yiot.dev/docs%2Fimages%2Fdanko-luci.png"><img width="400px" src="https://cdn.yiot.dev/docs%2Fimages%2Fdanko-luci.png" align="center" hspace="1" vspace="1"></img></a>
<a href="https://cdn.yiot.dev/docs%2Fimages%2Fdanko-luci-interfaces.png"><img width="400px" src="https://cdn.yiot.dev/docs%2Fimages%2Fdanko-luci-interfaces.png" align="center" hspace="1" vspace="1"></img></a>

There is possibility to simple run of services in Docker, like it's done for YIoT Portal.

[YIoT Danko documentation](https://cdn.yiot.dev/docs/devices/cv-2se.pdf)

Firmware can be released as an image or as an installer.

### YIoT Control application

Control application helps to do an initial setup of YIoT Danko device. And it provides a quick access to YIoT Danko functionality.

<a href="https://cdn.yiot.dev/docs%2Fimages%2Fcontrol-application.png"><img width="300px" src="https://cdn.yiot.dev/docs%2Fimages%2Fcontrol-application.png" align="center" hspace="1" vspace="1"></img></a>

### Use cases

#### Global access to own Web Cameras

RTSP or other video stream cam be sent via VPN without external services

#### Global access to own GPS tracker

Data will belong only to you. There is no need in third-party services. Pay attention that YIoT Portal can be run on your servers.

#### Simple sharing of IoT Data

Any your local device can share data via YIoT Danko VPN to YIoT Portal and proxy server can provide a global access.

#### Simple private transport via cloud

Connect different locations via VPN.
Send IoT, IIoT or any other data.

#### Protocols conversion

For example, Modbus RTU <-> Modbus TCP

#### Data filtering and redirection

Detect some data in Modbus traffic, convert to MQTT
