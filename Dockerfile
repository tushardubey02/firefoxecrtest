FROM ubuntu:22.04

# Install dependencies including audio libraries
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
    libasound2 \
    libpulse0 \
    libdrm2 \
    libxkbcommon0 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libpango-1.0-0 \
    libcairo2 \
    libfontconfig1 \
    libfreetype6 \
    && rm -rf /var/lib/apt/lists/*

# Download Firefox ESR (Long Term Support - guaranteed < 137.0.2)
RUN wget -O firefox.tar.bz2 "https://ftp.mozilla.org/pub/firefox/releases/128.5.0esr/linux-x86_64/en-US/firefox-128.5.0esr.tar.bz2" \
    && tar -xjf firefox.tar.bz2 -C /opt/ \
    && ln -s /opt/firefox/firefox /usr/local/bin/firefox \
    && rm firefox.tar.bz2

# Verify version (skip GUI libraries check)
RUN firefox --version || echo "Firefox installed but may need display for full functionality"

CMD ["firefox", "--version"]