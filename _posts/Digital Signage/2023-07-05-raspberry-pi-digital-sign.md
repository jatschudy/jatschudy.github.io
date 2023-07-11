---
title: Raspberry Pi Digital Sign
date: 2023-07-05 08:46:00 -0500
categories: [Digital Signage, Display]
tags: [raspberry pi,concerto,digital sign,media board]
---

### Overview
These steps will set a raspberry pi to open chromium at startup and navigate to a desired website. Unclutter is used to hide the mouse. The last part, which is not ideal, sets the pi to restart at 3:23 AM every day. This is not always needed and is specific to my use case as the pi was running a cached version of the digital sign rather than showing new content from the source. I also noticed they would start to lag and crash after prolonged use without a restart so this solved two problems.

### Installs and Display Setup
```bash
sudo apt install unclutter -y
cp -r /etc/xdg/lxsession~/.config/
nano .config/lxsession/LXDE-pi/autostart
```

*Then add these lines replacing <WEBURL> with the correct address*
```ini
@unclutter -idle 0
@xset s off
@xset -dpms
@xset s noblank
@chromium-browser --noerrors --disable-session-crashed-bubble --disable-infobars --start-fullscreen --incognito <WEBURL>
```

### Set a daily reboot
```bash
sudo nano /etc/crontab
```
*Add this line*
```txt
23 3    * * *   root    reboot
```

