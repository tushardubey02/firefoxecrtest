FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    libgtk-3-0 \
    libdbus-glib-1-2 \
    libxt6 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    && rm -rf /var/lib/apt/lists/*

# Download Firefox 136.0.1 directly from Mozilla's FTP archive
RUN wget -O firefox.tar.bz2 "https://ftp.mozilla.org/pub/firefox/releases/136.0.1/linux-x86_64/en-US/firefox-136.0.1.tar.bz2" \
    && tar -xjf firefox.tar.bz2 -C /opt/ \
    && ln -s /opt/firefox/firefox /usr/local/bin/firefox \
    && rm firefox.tar.bz2

# Verify version
RUN firefox --version

CMD ["firefox", "--version"]