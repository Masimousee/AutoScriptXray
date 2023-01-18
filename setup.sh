#!/bin/bash
    if [ "${EUID}" -ne 0 ]; then
            echo "You need to run this script as root"
            exit 1
    fi
    if [ "$(systemd-detect-virt)" == "openvz" ]; then
            echo "OpenVZ is not supported"
            exit 1
    fi
    red='\e[1;31m'
    green='\e[0;32m'
    yell='\e[1;33m'
    tyblue='\e[1;36m'
    NC='\e[0m'
    purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
    tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
    yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
    green() { echo -e "\\033[32;1m${*}\\033[0m"; }
    red() { echo -e "\\033[31;1m${*}\\033[0m"; }
    cd /root

# Perizinan
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`

BURIQ () {
    curl -sS https://raw.githubusercontent.com/firdaus-rx/xray/main/member/ip > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f  /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f  /root/tmp
}
    MYIP=$(curl -sS ipv4.icanhazip.com)
    Name=$(curl -sS https://raw.githubusercontent.com/firdaus-rx/xray/main/member/ip | grep $MYIP | awk '{print $2}')
    echo $Name > /usr/local/etc/.$Name.ini
    CekOne=$(cat /usr/local/etc/.$Name.ini)

    Bloman () {
    if [ -f "/etc/.$Name.ini" ]; then
    CekTwo=$(cat /etc/.$Name.ini)
        if [ "$CekOne" = "$CekTwo" ]; then
            res="Expired"
        fi
    else
    res="Permission Accepted..."
    fi
}

    PERMISSION () {
        MYIP=$(curl -sS ipv4.icanhazip.com)
        IZIN=$(curl -sS https://raw.githubusercontent.com/firdaus-rx/xray/main/member/ip | awk '{print $4}' | grep $MYIP)
        if [ "$MYIP" = "$IZIN" ]; then
        Bloman
        else
        res="Permission Denied!"
        fi
        BURIQ
}

    echo -ne "[ ${green}INFO${NC} ] Check permission : !!!"

    PERMISSION
    if [ -f /home/needupdate ]; then
    red "Your script need to update first !"
    exit 0
    elif [ "$res" = "Permission Accepted..." ]; then
    green "Permission Accepted!"
    else
    red "Permission Denied!"
    green "Contact admin !"
    green "WA   : 0813-2433-6437"
    green "Tele : https://t.me/firdaus_rx"
    sleep 10
    exit 0
    fi
    sleep 3

# REPO
    REPO="https://private.driveme.workers.dev/0:/xray/"
    REPOGH="https://raw.githubusercontent.com/firdaus-rx/xray/main/"

# Buat direktori xray
    mkdir -p /etc/xray
    mkdir -p /root/akun
    mkdir -p /root/akun/vmess
    mkdir -p /root/akun/vless
    mkdir -p /root/akun/trojan
    mkdir -p /root/akun/shadowsocks
    curl -s ipinfo.io/city >> /etc/xray/city
    curl -s ifconfig.me > /etc/xray/ipvps
    curl -s ipinfo.io/org | cut -d " " -f 2-10 >> /etc/xray/isp
    curl -s {$REPOGH}versi | cut -d " " -f 2-10 >> /etc/xray/version
    touch /root/akun/vless/.vless.conf
    touch /root/akun/vmess/.vmess.conf
    touch /root/akun/trojan/.trojan.conf
    touch /root/akun/shadowsocks/.shadowsocks.conf
    touch /etc/xray/domain
    mkdir -p /var/log/xray
    chown www-data.www-data /var/log/xray
    chmod +x /var/log/xray
    touch /var/log/xray/access.log
    touch /var/log/xray/error.log
    touch /var/log/xray/access2.log
    touch /var/log/xray/error2.log
    mkdir -p /var/lib/firdaus >/dev/null 2>&1
    echo "IP=" >> /var/lib/firdaus/ipvps.conf


#Instal Vnstat
clear
function instal_vnstat(){
    clear
    wget ${REPO}xray/vnstat.sh
    clear
    chmod +x vnstat.sh && ./vnstat.sh
}

clear
#Instal BBR Update Kernel
function update_kernel(){
    clear
    clear
    wget ${REPO}xray/bbr.sh
    clear
    chmod +x bbr.sh && ./bbr.sh
}

# Change Environment System
function first_setup(){
    timedatectl set-timezone Asia/Jakarta
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
    
}

# Update and remove packages
function base_package() {
    sudo apt-get autoremove -y man-db apache2 ufw exim4 firewalld -y
    sudo add-apt-repository ppa:vbernat/haproxy-2.7 -y
    sudo apt update && apt upgrade -y
    sudo apt-get install -y --no-install-recommends software-properties-common
    sudo apt install squid nginx zip pwgen openssl netcat socat cron bash-completion \
    curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils \
    tar wget curl ruby zip unzip p7zip-full python3-pip haproxy libc6 util-linux build-essential \
    msmtp-mta ca-certificates bsd-mailx iptables iptables-persistent netfilter-persistent \
    net-tools  jq openvpn easy-rsa python3-certbot-nginx -y
    sudo apt-get autoremove -y
    apt-get clean all
}

# Fungsi input domain
clear
function pasang_domain() {
    clear
    yellow "Tambah Domain Untuk Server Nginx, Xray Server"
    read -rp "Input ur domain : " -e pp
    if [ -z $pp ]; then
        echo -e "
        Nothing input for domain!
        Then a random domain will be created"
    else
    echo "$pp" > /etc/xray/domain
    echo $pp > /root/domain
        echo "IP=$pp" > /var/lib/firdaus/ipvps.conf
    fi
}

# Pasang SSL
function pasang_ssl() {
    rm -rf /etc/xray/xray.key
    rm -rf /etc/xray/xray.crt
    domain=$(cat /etc/xray/domain)
    STOPWEBSERVER=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
    rm -rf /root/.acme.sh
    mkdir /root/.acme.sh
    systemctl stop $STOPWEBSERVER
    systemctl stop nginx
    curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
    chmod +x /root/.acme.sh/acme.sh
    /root/.acme.sh/acme.sh --upgrade --auto-upgrade
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
    ~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
    chmod 777 /etc/xray/xray.key
}

#Instal Xray
function install_xray() {
    echo -e "[ ${green}INFO${NC} ] Checking... "
    apt install iptables iptables-persistent -y
    echo -e "[ ${green}INFO$NC ] Enable chronyd"
    systemctl enable chronyd
    systemctl restart chronyd
    echo -e "[ ${green}INFO$NC ] Enable chrony"
    systemctl enable chrony
    systemctl restart chrony
    echo -e "[ ${green}INFO$NC ] Setting chrony tracking"
    chronyc sourcestats -v
    chronyc tracking -v
    echo -e "[ ${green}INFO$NC ] Setting dll"
    apt clean all && apt update
    apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
    apt install socat cron bash-completion ntpdate -y
    ntpdate pool.ntp.org
    apt -y install chrony
    apt install zip -y
    apt install curl pwgen openssl netcat cron -y
    
    # install xray
    echo -e "[ ${green}INFO$NC ] Downloading & Installing xray core"
    domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
    chown www-data.www-data $domainSock_dir
    # / / Ambil Xray Core Version Terbaru
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.5.6
    wget -O /etc/xray/config.json "${REPO}xray/config.json" >/dev/null 2>&1 
    clear
    wget -O /etc/systemd/system/runn.service "${REPO}xray/runn.service" >/dev/null 2>&1 
    clear
    domain=$(cat /etc/xray/domain)
    IPVS=$(cat /etc/xray/ipvps)
    
    # Settings UP Nginix Server
    clear
    wget -O /etc/nginx/conf.d/xray.conf "${REPO}xray/xray.conf" >/dev/null 2>&1
    clear
    sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf
    clear
    clear
    wget -O /etc/nginx/nginx.conf "${REPO}xray/nginx.conf" >/dev/null 2>&1

    # > Set Permission
    chmod +x /etc/systemd/system/runn.service

    # > Create Service
    rm -rf /etc/systemd/system/xray.service.d
    cat >/etc/systemd/system/xray.service <<EOF
Description=Xray Service
Documentation=https://github.com/firdaus-rx
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

EOF
}

#Instal Menu
function menu(){
    cd /usr/bin/
    # > Add menu
    wget -O ~/menu-main.zip "${REPOGH}menu.zip" >/dev/null 2>&1
    mkdir /root/menu
    7z e  ~/menu-main.zip -o/root/menu/ >/dev/null 2>&1
    chmod +x /root/menu/*
    mv /root/menu/* /usr/bin/
    
    # > Add Website Profile
    wget -O ~/web-main.zip "${REPOGH}web.zip" >/dev/null 2>&1
    mkdir /root/web
    7z e  ~/web-main.zip -o/root/web/ >/dev/null 2>&1
    chmod +x /root/web/*
    mv /root/web/* /var/www/html/
}

# Membaut Default Menu 
function profile(){
    cat >/root/.profile <<EOF
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
    if [ -f ~/.bashrc ]; then
        . ~/.bashrc
    fi
fi
mesg n || true
menu
EOF

cat >/etc/cron.d/xp_all <<EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/bin/xp
EOF

chmod 644 /root/.profile

cat >/etc/cron.d/daily_reboot <<EOF
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 5 * * * root /sbin/reboot
EOF

echo "*/1 * * * * root echo -n > /var/log/nginx/access.log" >/etc/cron.d/log.nginx
echo "*/1 * * * * root echo -n > /var/log/xray/access.log" >>/etc/cron.d/log.xray
service cron restart
cat >/home/daily_reboot <<EOF
5
EOF

cat >/etc/systemd/system/rc-local.service <<EOF
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
EOF

echo "/bin/false" >>/etc/shells
echo "/usr/sbin/nologin" >>/etc/shells
cat >/etc/rc.local <<EOF
#!/bin/sh -e
# rc.local
# By default this script does nothing.
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
systemctl restart netfilter-persistent
exit 0
EOF

    chmod +x /etc/rc.local

}

# Restart layanan after install
function enable_services(){
    systemctl daemon-reload
    systemctl start netfilter-persistent
    systemctl enable --now rc-local
    systemctl enable --now cron
    systemctl enable --now netfilter-persistent
    systemctl restart nginx
    systemctl restart xray
}

# Fingsi Install Script
function instal(){
    instal_vnstat
    update_kernel
    first_setup
    base_package
    pasang_domain
    pasang_ssl
    install_xray
    menu
    profile
    enable_services
    log_install  >> /root/log-install.txt
}

function log_install(){
    echo ""
    echo "   >>> Service & Port"          
    echo "   - Nginx   	    	             : 81"
    echo "   - Vmess TLS	    	         : 443"
    echo "   - Vmess None TLS	             : 80"
    echo "   - Vless TLS	         	     : 443"
    echo "   - Vless None TLS	             : 80"
    echo "   - Trojan GRPC	                 : 443"
    echo "   - Trojan WS		             : 443"
    echo "   - Sodosok WS/GRPC               : 443"
    echo "" 
    echo "   >>> Server Information & Other Features" 
    echo "   - Timezone	         	         : Asia/Jakarta (GMT +7)" 
    echo "   - Auto Remove Experied Account  : [ON]"
    echo "   - IPtables		                 : [ON]" 
    echo "   - IPv6			                 : [ON]" 
    echo "   - Auto Reboot                   : [ON]" 
    echo "   - Full Orders For Various Services"
    echo ""
    echo -e ""

}
instal
echo ""
history -c
rm -rf /root/menu
rm -rf /root/web
rm -rf /root/*.zip
rm -rf /root/*.sh
rm -rf /root/install_bbr.log
echo -ne "[ ${yell}WARNING${NC} ] reboot now ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
reboot
fi