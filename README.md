# Stripts to generate IMG for SDM845 Phones

# How to use it

1. Configure vars in .env file
   * `DEVICE`: one of `oneplus6`, `pocof1`, `shift6mq`
   * The `PHOSH` and `PLAMO` desktops are both built automatically, no configuration needed
2. Execute "sudo bash all.sh"

This will generate bootimg and rootfs IMG files for both PHOSH and PLAMO to flash it via fastboot

Put your device in fastboot mode, and execute (pick the desktop and variant you want):

   * fastboot flash boot openSUSE-Tumbleweed-ARM-<DESKTOP>-<device><variant>.aarch64.boot.img
   
   * fastboot -S 100M flash userdata openSUSE-Tumbleweed-ARM-<DESKTOP>-<device>.aarch64.root.img
   
   * fastboot erase dtbo
   
