FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    libgtk-3-0 \
    libdbus-glib-1-2 \
    libxt6 \
    && rm -rf /var/lib/apt/lists/*

# Download and install Firefox 136.0 (example version < 137.0.2)
RUN wget -O firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-136.0&os=linux64&lang=en-US" \
    && tar -xjf firefox.tar.bz2 -C /opt/ \
    && ln -s /opt/firefox/firefox /usr/local/bin/firefox \
    && rm firefox.tar.bz2

CMD ["firefox", "--version"]