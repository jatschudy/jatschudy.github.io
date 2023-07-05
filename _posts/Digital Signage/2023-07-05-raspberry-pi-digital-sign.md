---
title: Raspberry Pi Digital Sign
date: 2023-07-05 08:46:00 -0500
categories: [Digital Signage]
tags: [raspberry pi,concerto,digital sign,media board]
---

### Set static IP

### Setup Display
*Copy and open autostart file*
```bash
cp -r /etc/xdg/lxsession~/.config/
nano .config/lxsession/LXDE-pi/autostart
```

*Then add these lines replacing <WEBURL>*
```txt
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

