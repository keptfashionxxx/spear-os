FROM accetto/ubuntu-vnc-xfce-g3

USER root

# 1. Enable official repositories for Thunderbird to bypass Snap requirements
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:mozillateam/ppa

# 2. Set pinning priorities to favor native packages over snap stubs
RUN echo 'Package: thunderbird*\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001' > /etc/apt/preferences.d/mozillateamppa

# 3. Reinstall your complete applications stack and tools all at once
RUN apt-get update && apt-get install -y \
    neofetch \
    wireshark \
    john \
    nmap \
    nikto \
    snort \
    radare2 \
    blender \
    hexchat \
    thunderbird \
    oneko

# 4. Automate your custom 4-point pinwheel star logo asset file creation
RUN mkdir -p /home/headless/.config/neofetch && \
    echo '@\n                      @@@\n                     @@@@@\n                     @@@@@@@\n                     @@@@@@@@@\n                    @@@@@@@@@@@\n                    @@@@@@@@@@@@@\n                    @@@@@@@@@@@@@@@@@\n                   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n                   @@..@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n                 @@@@..@@@@...@.......@@@@@@@@@@@\n               @@@@@@@......@@@..@@@@@@@@@@@@@@\n             @@@@@@@@@....@@@@@..@@@@@@@@@@@@\n           @@@@@@@@@@@..@...@@@.......@@@@\n         @@@@@@@@@@@@@..@@@..@@..@@@@@@@\n      @@@@@@@@@@@@@@@@@@@@@@@@@..@@@@@@\n         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n                     @@@@@@@@@@@@@@@@@\n                         @@@@@@@@@@@@@\n                          @@@@@@@@@@@@\n                            @@@@@@@@@\n                              @@@@@@@\n                                @@@@@\n                                 @@@\n                                  @@' > /home/headless/kf_ascii.txt

# 5. Configure Neofetch to align variables and display OS: KF Linux cleanly
RUN echo 'print_info() {\n    print_info_custom() {\n        echo -e "$(color 1)OS$(color 7): KF Linux"\n    }\n    print_info_custom\n    info "Kernel" kernel\n    info "Uptime" uptime\n    info "Packages" packages\n    info "Shell" shell\n    info "Theme" theme\n    info "Terminal" term\n    info "CPU" cpu\n    info "Memory" memory\n}\nos_arch="off"\nimage_backend="ascii"\nimage_source="/home/headless/kf_ascii.txt"\ngap=2\nascii_distro="off"' > /home/headless/.config/neofetch/config.conf

# 6. Set correct permissions for the headless environment profile
RUN chown -R 1001:1001 /home/headless && chmod -R 755 /home/headless

USER 1001

# 7. EXPOSE NATIVE DISPLAY PORTS FOR AUTOMATED ROUTING
EXPOSE 6080 5901

# 8. ENFORCE AUTO-STARTUP ENTRYPOINT ENGINE (No extra ports or manual proxies needed)
ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]

USER 1001

# 7. Anchor the native desktop startup background process engine onto Port 6080
CMD ["/headless/vnc_startup.sh", "--vnc-id", "1"]
