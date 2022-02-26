(define-public base-operating-system
  (operating-system
    (host-name "mh-furan")
    (timezone "Europe/Rome")
    (locale "en_GB.utf8")

    ;; Use non-free Linux and firmware
    (kernel linux)
    (firmware (list linux-firmware))
    (initrd microcode-initrd)

    ;; Choose US English keyboard layout.  The "altgr-intl"
    ;; variant provides dead keys for accented characters.
    (keyboard-layout (keyboard-layout "us" "altgr-intl" #:model "thinkpad"))

    ;; Use the UEFI variant of GRUB with the EFI System
    ;; Partition mounted on /boot/efi.
    (bootloader (bootloader-configuration
                 (bootloader grub-efi-bootloader)
                 (target "/boot/efi")
                 (keyboard-layout keyboard-layout)))


    ;; Guix doesn't like it when there isn't a file-systems
    ;; entry, so add one that is meant to be overridden
    (file-systems (cons*
                   (file-system
                     (mount-point "/tmp")
                     (device "none")
                     (type "tmpfs")
                     (check? #f))
                   %base-file-systems))
   
   (users (cons (user-account
                  (name "furan")
                  (comment "Furan")
                  (group "users")
                  (home-directory "/home/furan")
                  (supplementary-groups '(
                                          "wheel"     ;; sudo
                                          "netdev"    ;; network devices
                                          "kvm"
                                          "tty"
                                          "input"
                                          "docker"
                                          "realtime"  ;; Enable realtime scheduling
                                          "lp"        ;; control bluetooth devices
                                          "audio"     ;; control audio devices
                                          "video")))  ;; control video devices

                 %base-user-accounts))
   
   ;; Add the 'realtime' group
   (groups (cons (user-group (system? #t) (name "realtime"))
                  %base-groups))
   
   ;; Install bare-minimum system packages
    (packages (append (list
                        git
                        ntfs-3g
                        exfat-utils
                        fuse-exfat
                        stow
                        nano
                        xterm
                        bluez
                        bluez-alsa
                        pulseaudio
                        tlp
                        xf86-input-libinput
                        nss-certs     ;; for HTTPS access
                        gvfs)         ;; for user mounts
                    %base-packages))
