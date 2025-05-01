# Use Ubuntu 24 as the base image
FROM ubuntu:24.04

# Set environment variable to suppress interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Preconfigure keyboard layout to English (US)
RUN echo 'keyboard-configuration keyboard-configuration/layoutcode select us' | debconf-set-selections

# Install packages
RUN apt-get install --no-install-recommends xfce4-session \
    xfwm4 xfce4-panel thunar zutty \
    tightvncserver \
    sudo util-linux iproute2 net-tools git curl wget nano gdebi gnupg dialog htop util-linux uuid-runtime gnome-keyring seahorse openssh-server

RUN apt-get install -y \
    dbus dbus-x11\
    sudo htop wget curl nano gnupg gdebi iproute2 net-tools dialog util-linux uuid-runtime \
    apt-transport-https openssh-server xdotool proxychains4 tesseract-ocr imagemagick

RUN apt-get install -y \
    ca-certificates fonts-liberation xdg-utils \
    libappindicator3-1 libasound2t64 libatk1.0-0 libatk-bridge2.0-0 libatspi2.0-0 libayatana-common0 libayatana-indicator3-7 \
    libbsd0 \
    libc6 libcairo2 libcups2 libcurl4 \
    libdbus-1-3 \
    libexpat1 \
    libgbm1 libgl1 libglib2.0-0 libgtk-3-0 libgtk-3-0t64 libgtk-3-bin libgtk-3-bin libgtk-3-common libgtk-4-1 libgtk-4-1 libgtk-4-bin libgtk-4-common \
    libnotify4 libnotify-bin libnspr4 libnss3 \
    libpango-1.0-0 \
    libudev1 libuuid1 \
    libvulkan1 \
    libwebkit2gtk-4.1-0 libwebkitgtk-6.0-4 \
    libx11-6 libx11-xcb1 libxau6 libxcb1 libxcb-glx0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render0 libxcb-render-util0 libxcb-shape0 libxcb-shm0 libxcb-sync1 libxcb-util1 libxcb-xfixes0 libxcb-xinerama0 libxcb-xkb1 libxcomposite1 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxkbcommon0 libxkbcommon-x11-0 libxrandr2

# Download and install the Google Chrome from the official source
RUN wget -O /tmp/google-chrome-stable.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    gdebi --n /tmp/google-chrome-stable.deb && \
    rm /tmp/google-chrome-stable.deb

# Download and install the Wipter application from the official source
# Download and install the Wipter application
RUN wget -O /tmp/wipter.deb https://github.com/hoainv1807/Docker-Ubuntu-XFCE-XRDP/releases/download/wipter/wipter.deb && \
     gdebi --n /tmp/wipter.deb && \
     rm /tmp/wipter.deb

# Download Uprock and install
RUN wget -O /tmp/uprock_v0.0.8.deb https://github.com/hoainv1807/Docker-Ubuntu-XFCE-XRDP/releases/download/wipter/uprock_v0.0.8.deb
RUN gdebi --n /tmp/uprock_v0.0.8.deb && \
    rm /tmp/uprock_v0.0.8.deb

# Grass
COPY Grass.deb /tmp/
RUN apt install /tmp/Grass.deb -y && apt update && apt install -f -y && rm /tmp/Grass.deb

# Set up X resources for customization
RUN echo "*customization: -color" > /root/.Xresources

# Set up TightVNC configuration
RUN mkdir -p /root/.vnc
RUN mkdir -p /root/.local/share

# Create .Xauthority for root and ensure correct permissions
RUN touch /root/.Xauthority && chmod 600 /root/.Xauthority

# Move OpenSSH Server to 22222
RUN sed -i 's/#Port 22/Port 22222/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "ListenAddress 0.0.0.0" >> /etc/ssh/sshd_config && \
    echo "ListenAddress ::" >> /etc/ssh/sshd_config && \
    mkdir -p /var/run/sshd

# Create a shortcuts
RUN mkdir -p /root/Desktop && \
    cat <<EOF > /root/Desktop/google-chrome.desktop
[Desktop Entry]
Version=1.0
Name=Google Chrome
Comment=Access the Internet
Exec=/usr/bin/google-chrome-stable --no-sandbox --window-size=1600,900 %U
Icon=google-chrome
Terminal=false
Type=Application
Categories=Network;WebBrowser;
EOF
RUN chmod a+x /root/Desktop/google-chrome.desktop
RUN dbus-launch gio set /root/Desktop/google-chrome.desktop "metadata::trusted" true

RUN mkdir -p /root/Desktop && \
    cat <<EOF > /root/Desktop/wipter-app.desktop
[Desktop Entry]
Name=Wipter
Comment=Wipter
Exec=/opt/Wipter/wipter-app %U
Icon=wipter-app
Terminal=true
Type=Application
Categories=Network;
StartupWMClass=Wipter
EOF
RUN chmod a+x /root/Desktop/wipter-app.desktop
RUN dbus-launch gio set /root/Desktop/wipter-app.desktop "metadata::trusted" true

RUN mkdir -p /root/Desktop && \
    cat <<EOF > /root/Desktop/peer2profit.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Peer2Profit
Comment=Peer2Profit
Exec=/usr/bin/peer2profit
Icon=peer2profit
Terminal=true
Type=Application
Categories=Network;
StartupNotify=true;
EOF
RUN chmod a+x /root/Desktop/peer2profit.desktop
RUN dbus-launch gio set /root/Desktop/peer2profit.desktop "metadata::trusted" true

RUN mkdir -p /root/Desktop && \
    cat <<EOF > /root/Desktop/uprock-mining.desktop
[Desktop Entry]
Name=UpRock Mining
Comment=UpRock Mining
Exec=uprock-mining
Icon=uprock-mining
Terminal=true
Type=Application
Categories=Network;
StartupNotify=true;

# Clean up unnecessary packages and cache to reduce image size
RUN apt-get autoclean && apt-get autoremove -y && apt-get autopurge -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose the VNC port
EXPOSE 5901 22222

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/entrypoint.sh

# Use tini clear zombie process
ENTRYPOINT ["/usr/bin/tini", "--"]

# Set the default command
CMD ["/usr/local/bin/entrypoint.sh"]
