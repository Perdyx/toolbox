# Author: Per
# Description: Customized Kali Linux image with pre-installed tools for reconnaissance and web application security testing.

FROM kalilinux/kali-rolling:latest


########## Setup environment ##########

# Use bash as default shell for all RUN commands and for image users
SHELL ["/bin/bash", "-lc"]

# Silence the default Kali welcome message
RUN touch /root/.hushlogin

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    GOPATH=/root/go \
    GOBIN=/usr/local/bin \
    GO111MODULE=on \
    PATH=/root/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Set working directory
WORKDIR /root

# Update and upgrade the system
RUN apt update -y
RUN apt upgrade -y


########## Tmux ##########

# Install tmux
RUN apt-get install -y --no-install-recommends tmux

# Add banner file and display with welcome message on tmux shell startup
COPY ./config/banner.txt /root/.motd.txt
RUN cat >> /root/.bashrc <<'EOF'
########## Tmux startup script ##########
GREEN=$'\e[1;32m'
RESET=$'\e[0m'

# Fix tmux font rendering issues
export LANG=en_US.UTF-8

# Autostart or attach to a tmux session on shell startup, if not already in one
if [[ -z "$TMUX" ]] && [[ -n "$PS1" ]] && [[ "$(tty)" == "/dev/pts/"* ]]; then
    tmux attach || tmux
fi

if [[ -n "$TMUX" && $- == *i* ]]; then
    # Display banner
    cat .motd.txt
    echo -e "\n\n"

    # List network connections
    lsof -i -nP | grep -E 'LISTEN|ESTABLISHED'

    # Display connection info
    # echo -e "\n[${GREEN} $(curl -s ipinfo.io/ip) ${RESET}] - $(curl -s ipinfo.io/org)"
    # echo -e "$(curl -s ipinfo.io/city), $(curl -s ipinfo.io/region), $(curl -s ipinfo.io/country)\n"
		
		echo
		tmux ls

    echo "Happy hacking!"
fi
EOF

# Simplify the BASH prompt
RUN sed -i 's/PROMPT_ALTERNATIVE=twoline/PROMPT_ALTERNATIVE=backtrack/g' /root/.bashrc

# Customize tmux
COPY ./config/tmux.conf /root/.tmux.conf


########## OpenSSH Server ##########

# Install OpenSSH server
RUN apt-get install -y --no-install-recommends openssh-server

# Create SSH directory and set permissions
RUN mkdir -p /var/run/sshd
RUN chmod 0755 /var/run/sshd

# Allow root login and set root password (change 'toor' to a strong password)
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo "root:kaliguard" | chpasswd

# Expose SSH port and change it to a non-standard port
EXPOSE 22


########## Install Base Packages ##########

# Install base packages and tools
RUN apt-get install -y --fix-missing --no-install-recommends \
    build-essential \
    curl \
    git \
    jq \
    nano \
    passwd \
    vim \
    wget \
    kali-linux-headless \
		mcp-kali-server \
    massdns


########## Golang ##########

# Install Golang using packaged golang-go for easier maintenance and some helpers
RUN apt-get install -y --no-install-recommends golang-go
RUN mkdir -p /root/go
RUN mkdir -p /opt/tools
RUN chown -R root:root /opt/tools
RUN go env -w GO111MODULE=on
RUN go env -w GOPROXY=direct

# Install Golang-based tools
RUN go install -v github.com/tomnomnom/anew@latest
RUN go install -v github.com/tomnomnom/assetfinder@latest
RUN go install -v github.com/tomnomnom/httprobe@latest
RUN go install -v github.com/tomnomnom/waybackurls@latest

RUN go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# Temporary fix to make nuclei install work
RUN apt install -y nuclei
#RUN go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

RUN go install -v github.com/ffuf/ffuf/v2@latest
RUN go install -v github.com/lc/gau/v2/cmd/gau@latest
RUN go install -v github.com/jaeles-project/gospider@latest
RUN go install -v github.com/d3mondev/puredns/v2@latest
RUN go install -v github.com/PentestPad/subzy@latest
RUN go install -v github.com/sensepost/gowitness@latest


########## Image Optimizations and Cleanup ##########

# Clean up apt caches and temporary files to keep image smaller
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN history -c


########## Entrypoint ##########

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
