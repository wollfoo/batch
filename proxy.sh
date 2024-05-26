#!/bin/bash

# Hàm tạo chuỗi ngẫu nhiên
random() {
	tr </dev/urandom -dc A-Za-z0-9 | head -c5
	echo
}

# Hàm tạo địa chỉ IPv6 ngẫu nhiên
gen64() {
	local array=(1 2 3 4 5 6 7 8 9 0 a b c d e f)
	ip64() {
		echo "${array[$RANDOM % 16]}${array[$RANDOM % 16]}${array[$RANDOM % 16]}${array[$RANDOM % 16]}"
	}
	echo "$1:$(ip64):$(ip64):$(ip64):$(ip64)"
}

# Cài đặt 3proxy
install_3proxy() {
    echo "Installing 3proxy..."
    URL="https://raw.githubusercontent.com/quayvlog/quayvlog/main/3proxy-3proxy-0.8.6.tar.gz"
    wget -qO- $URL | tar -xvf-
    cd 3proxy-3proxy-0.8.6 || exit
    make -f Makefile.Linux
    mkdir -p /usr/local/etc/3proxy/{bin,logs,stat}
    cp src/3proxy /usr/local/etc/3proxy/bin/
    cp ./scripts/rc.d/proxy.sh /etc/init.d/3proxy
    chmod +x /etc/init.d/3proxy
    update-rc.d 3proxy defaults
    cd "$WORKDIR" || exit
}

# Tạo nội dung tệp cấu hình cho 3proxy
gen_3proxy() {
    cat <<EOF
daemon
maxconn 1000
nscache 65536
timeouts 1 5 30 60 180 1800 15 60
setgid 65535
setuid 65535
flush
auth strong

users $(awk -F "/" 'BEGIN{ORS="";} {print $1 ":CL:" $2 " "}' ${WORKDATA})

$(awk -F "/" '{print "auth strong\n" \
"allow " $1 "\n" \
"proxy -6 -n -a -p" $4 " -i" $3 " -e"$5"\n" \
"flush\n"}' ${WORKDATA})
EOF
}

# Tạo nội dung tệp proxy.txt cho người dùng
gen_proxy_file_for_user() {
    awk -F "/" '{print $3 ":" $4 ":" $1 ":" $2 }' ${WORKDATA} > proxy.txt
}

# Tải lên thông tin proxy lên dịch vụ chia sẻ tệp
upload_proxy() {
    local PASS=$(random)
    zip --password $PASS proxy.zip proxy.txt
    URL=$(curl -s --upload-file proxy.zip https://transfer.sh/proxy.zip)

    echo "Proxy is ready! Format IP:PORT:LOGIN:PASS"
    echo "Download zip archive from: ${URL}"
    echo "Password: ${PASS}"
}

# Tạo dữ liệu người dùng cho các proxy
gen_data() {
    seq $FIRST_PORT $LAST_PORT | while read port; do
        echo "usr$(random)/pass$(random)/$IP4/$port/$(gen64 $IP6)"
    done
}

# Tạo các quy tắc iptables để mở cổng cho các proxy
gen_iptables() {
    awk -F "/" '{print "iptables -I INPUT -p tcp --dport " $4 "  -m state --state NEW -j ACCEPT"}' ${WORKDATA}
}

# Tạo các lệnh ifconfig để cấu hình địa chỉ IPv6 cho các proxy
gen_ifconfig() {
    awk -F "/" '{print "ifconfig eth0 inet6 add " $5 "/64"}' ${WORKDATA}
}

# Cài đặt các gói cần thiết và 3proxy
echo "Installing necessary packages..."
apt-get update && apt-get install -y gcc net-tools bsdtar zip || exit

install_3proxy

# Thông tin về thư mục làm việc
echo "Working folder = /home/proxy-installer"
WORKDIR="/home/proxy-installer"
WORKDATA="${WORKDIR}/data.txt"
mkdir "$WORKDIR" && cd "$_" || exit

# Xác định địa chỉ IPv4 và IPv6 của máy chủ
IP4=$(curl -4 -s icanhazip.com)
IP6=$(curl -6 -s icanhazip.com | cut -f1-4 -d':')

echo "Internal IP = ${IP4}. External subnet for IPv6 = ${IP6}"

# Nhập số lượng proxy cần tạo
read -p "How many proxies do you want to create? Example 500: " COUNT

# Xác định cổng bắt đầu và kết thúc
FIRST_PORT=10000
LAST_PORT=$(($FIRST_PORT + $COUNT))

# Tạo dữ liệu cho các proxy
gen_data > "$WORKDATA"

# Tạo các quy tắc iptables và lệnh ifconfig
gen_iptables > "$WORKDIR/boot_iptables.sh"
gen_ifconfig > "$WORKDIR/boot_ifconfig.sh"
chmod +x "${WORKDIR}/boot_*.sh" /etc/rc.local

# Tạo cấu hình cho 3proxy
gen_3proxy >/usr/local/etc/3proxy/3proxy.cfg

# Thêm các lệnh vào rc.local để khởi động khi máy chủ bật
cat >>/etc/rc.local <<EOF
bash ${WORKDIR}/boot_iptables.sh
bash ${WORKDIR}/boot_ifconfig.sh
ulimit -n 10048
service 3proxy start
EOF

# Khởi động các lệnh trong rc.local
bash /etc/rc.local

# Tạo tệp proxy.txt cho người dùng và tải lên
gen_proxy_file_for_user
upload_proxy
