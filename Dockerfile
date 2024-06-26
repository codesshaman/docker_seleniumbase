FROM debian:bullseye-20240513

#==============================
# Install Environment Variables
#==============================
ARG ARGUMENTS
ARG USER_ID
ARG GRUP_ID
ARG OPTIONS
ENV USER_ID=${USER_ID}
ENV GRUP_ID=${GRUP_ID}
ENV OPTIONS=${OPTIONS}
ENV PYTHONIOENCODING=utf8
ENV ARGUMENTS=${ARGUMENTS}
RUN echo "export PYTHONIOENCODING=utf8" >> ~/.bashrc && \
    echo "export USER_ID=${USER_ID}" >> ~/.bashrc && \
    echo "export GRUP_ID=${GRUP_ID}" >> ~/.bashrc

#============================
# Install Linux Dependencies
#============================
RUN apt update && apt install -y \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    libcairo2-dev \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libwayland-client0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    libu2f-udev \
    libvulkan1 \
    xdg-utils \
    dirmngr \
    gnupg2

#=================================
# Install Bash Command Line Tools
#=================================
RUN apt-get -qy --no-install-recommends install \
    curl \
    sudo \
    unzip \
    nano \
    wget \
    xvfb && \
    rm -rf /var/lib/apt/lists/*

#================
# Add GPG-keys
#================
RUN gpg --batch --keyserver hkp://keyserver.ubuntu.com --recv-keys E88979FB9B30ACF2 && \
    gpg --export --armor E88979FB9B30ACF2 | apt-key add - && \
    apt-get purge -y gnupg2 dirmngr && \
    rm -rf /var/lib/apt/lists/*

#================
# Install Chrome
#================
RUN curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | tee /usr/share/keyrings/google-chrome.gpg >> /dev/null && \
    echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | tee /etc/apt/sources.list.d/google-chrome.list && \
    apt update && apt install -y google-chrome-stable
# RUN curl -LO  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
#     apt-get install -y ./google-chrome-stable_current_amd64.deb && \
#     rm google-chrome-stable_current_amd64.deb


#================
# Install Python
#================
RUN apt update && apt install -y \
    python3-setuptools \
    python3-venv \
    python3-pip \
    python3-dev \
    python3 && \
    alias python=python3 && \
    echo "alias python=python3" >> ~/.bashrc

#===========================
# Configure Virtual Display
#===========================
RUN set -e && \
	  echo "Starting X virtual framebuffer (Xvfb) in background..." && \
	  Xvfb -ac :99 -screen 0 1280x1024x16 > /dev/null 2>&1 & \
	  export DISPLAY=:99 && \
	  exec "$@"

COPY SeleniumBase /SeleniumBase
COPY SeleniumBase/integrations/docker/docker-entrypoint.sh /
COPY SeleniumBase/integrations/docker/run_docker_test_in_chrome.sh /
RUN chmod +x *.sh && cd /SeleniumBase && pip install . && \
    cd / && pip install --upgrade pip setuptools wheel

COPY requirements.txt /

RUN seleniumbase get chromedriver --path
RUN cd / && pip install -r requirements.txt

ENV PYTHONPATH=/home/app/.local

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
