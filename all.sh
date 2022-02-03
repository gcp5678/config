#!/usr/bin/env bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# 字体颜色配置
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
Blue="\033[36m"
Font="\033[0m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
OK="${Green}[OK]${Font}"
ERROR="${Red}[ERROR]${Font}"


function install_python() {
  yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make libffi-devel 
  wget https://www.python.org/ftp/python/3.7.2/Python-3.7.2.tgz
  tar -zxf Python-3.7.2.tgz
  mkdir -p /usr/local/python3
  cd Python-3.7.2/ && ./configure --prefix=/usr/local/python3make && make install
  ln -s /usr/local/python3/bin/python3 /usr/bin/python3ln && ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
  python3 --version 
}

function install_oci() {
   
   bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"
}

function oci_config() {
  cd /root && mkdir .oci && chmod 700 .oci && cd .oci && wget -O key.pem https://raw.githubusercontent.com/voyku/config/main/key.pem && chmod 600 key.pem
  read -rp "请输入你的秘钥:" key
  key.pem="/root/.oci/key.pem"
  sed -i "s/kkkk/${key}/g" ${key.pem}
  echo -e "—————————————— 秘钥已设置 ——————————————"""
  oci setup oci-cli-rc
  wget -O config https://raw.githubusercontent.com/voyku/config/main/config
  rm -rf oci-cli-rc && wget -O oci_cli_rc https://raw.githubusercontent.com/voyku/config/main/oci_cli_rc
  read -rp "请输入你的userid:" userid
  read -rp "请输入你的tenancyid:" tenancyid
  read -rp "请输入你的region:" region
  oci_cli_rc="/root/.oci/oci_cli_rc"
  config="/root/.oci/config"
  sed -i "s/uuuu/${userid}/g" ${confi
  echo -e "—————————————— userid已设置 ——————————————"""
  sed -i "s/tttt/${tenancyid}/g" ${config}
  echo -e "—————————————— tenancyid已设置 ——————————————"""
  sed -i "s/gggg/${region}/g" ${config}
  echo -e "—————————————— region已设置 ——————————————"""
  sed -i "s/xxx/${tenancyid}/g" ${oci_cli_rc}
  echo -e "—————————————— oci_cli_rc已设置 ——————————————"""
  openssl rsa -pubout -outform DER -in ~/.oci/key.pem | openssl md5 -c > opssl
  fingerprinta=$(cat /root/.oci/opssl)
  fingerprint=${IPA#*=}
  sed -i "s/ffff/${fingerprint}/g" ${config}# 字体颜色配置
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
Blue="\033[36m"
Font="\033[0m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
OK="${Green}[OK]${Font}"
ERROR="${Red}[ERROR]${Font}"


function install_python() {
  yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make libffi-devel 
  wget https://www.python.org/ftp/python/3.7.2/Python-3.7.2.tgz
  tar -zxf Python-3.7.2.tgz
  mkdir -p /usr/local/python3
  cd Python-3.7.2/ && ./configure --prefix=/usr/local/python3make && make install
  ln -s /usr/local/python3/bin/python3 /usr/bin/python3ln && ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
  python3 --version 
}

function install_oci() {
   
   bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"
}

function oci_config() {
  cd /root && mkdir .oci && chmod 700 .oci && cd .oci && wget -O key.pem https://raw.githubusercontent.com/voyku/config/main/key.pem && chmod 600 key.pem
  read -rp "请输入你的秘钥:" key
  key.pem="/root/.oci/key.pem"
  sed -i "s/kkkk/${key}/g" ${key.pem}
  echo -e "—————————————— 秘钥已设置 ——————————————"""
  oci setup oci-cli-rc
  wget -O config https://raw.githubusercontent.com/voyku/config/main/config
  rm -rf oci-cli-rc && wget -O oci_cli_rc https://raw.githubusercontent.com/voyku/config/main/oci_cli_rc
  read -rp "请输入你的userid:" userid
  read -rp "请输入你的tenancyid:" tenancyid
  read -rp "请输入你的region:" region
  oci_cli_rc="/root/.oci/oci_cli_rc"
  config="/root/.oci/config"
  sed -i "s/uuuu/${userid}/g" ${config}
  echo -e "—————————————— userid已设置 ——————————————"""
  sed -i "s/tttt/${tenancyid}/g" ${config}
  echo -e "—————————————— tenancyid已设置 ——————————————"""
  sed -i "s/gggg/${region}/g" ${config}
  echo -e "—————————————— region已设置 ——————————————"""
  sed -i "s/xxx/${tenancyid}/g" ${oci_cli_rc}
  echo -e "—————————————— oci_cli_rc已设置 ——————————————"""
  openssl rsa -pubout -outform DER -in ~/.oci/key.pem | openssl md5 -c > opssl
  fingerprinta=$(cat /root/.oci/opssl)
  fingerprint=${IPA#*=}
  sed -i "s/ffff/${fingerprint}/g" ${config}
  echo -e "—————————————— 秘钥指纹已设置，配置完成，可以使用 ——————————————"""
}

function install_baota() {
  cd / && mkdir data && chmod 700 data && wget -O smithao https://raw.githubusercontent.com/voyku/config/main/smithao && chmod 600 smithao
  smithaoprikey="
  -----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sI
CxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVP
imfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL2
2wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3
+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrq
ZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQIBJQKCAQAV5qsFYO64YFKKNTfF
AMr0JZyQLiBKpjbEK8LNF+UmMCeiV4t3Ho6SsyjOyqlji9PSg58AhE2jNX5ckCXD
8ShsPYlP/eLjZAlxQApmQLMpgcjHTvzpMJ2AmEbpaHMeV8gh9IPGfkM6Q9Sexl/h
V/f/+LQrNcmFsVZ5YG+0+mkuWtGme7DlRp8ETgy4HkTFLTHj+LN2WVeY9PBjsavH
+epM+cQVqL1ch3ZTXX2q0/0mqqQyKD53yPwtP3esBPltFS/3Kh9STbmwDhW/7ad4
Bnl1/akT+7UjdoYGJip7T4r5KVTZ6OgJE8pMPbLJqi/CEP0SYZKNAI43FBXpYBEi
G5itAoGBANntyc8bNOhpzb2fvp5AouJyA5pqWeIMLDMaIFy1KbV3Wdd6EMDBaBsD
8UOfwcQvC1TN1rgw1wLoQtIswZObitPTWyrI1A1C+mQNwbPmpqudUadQMiDyNmv5
PeQKbcmolPhjx4HI0t4auoTfL3iuR1PULSrJHZTIfR5d/au2sB7JAoGBAL5hVdeF
lsj8wCjCHZ7ocD4Tjr7hTCMsyOurV15lAcRqbFy66AjWh+EpjDG3J46sMisZ475T
9HRXdIcIeDSrYYqrcYnJqOYuhm/qqH97OU+7lpxiYayMR/el/QavOjkk8I8HMYBZ
YZIMYEt+tU3QZVpZXWsgxy2dstkPbQMOC8yhAoGAb+jPaloUP/768qv6GenXGlY5
M55lgeqTPNYQnk8xF/8EnxUrMozUmEBLdcC9cpSyyq7j4gs9+pLx4YyawWuMepz3
dtXUrN00eJFxTosy/i4w2WCIcch8z6mApYjQl/yfhnhtXlJecg25udpkfD3Rmb/7
hKx2+WAI5hSXBSZ2HaUCgYEAiu0VILtuCEm8qB7zBUHVXbs+pvdu6TxbRDDsuoEP
IKCv8KQRGzTEBSwoCJpo+WjmVs20B22yYrxb89W/gGFi2tAia3d7QC/J4vdYXQbk
ofeXazMJAV9yyXkgbKlh1qxA1xMWSOdHMzl2s6Gm5cGWEX97hYafLyAM45Wik4bK
Vw0CgYEAw5uBLV007yANAC9Au8eMUF3V2SHpgEvWJVwQBqCAsPypwcf09jkMwFSs
rMp6SvQpprQVyIXuMhwx6CKDMX6Q4PEQ99JyKCGITA5OJVE158ORpL7fekfV46iv
SGOGJWOkqaFAQDPafFJcHLdWHD9FOqjRUqPZCpBCpJ3TN2u+1R0=
-----END RSA PRIVATE KEY-----
  "
  smithaokey="/data/smithao"
  sed -i "s/mmmm/${smithaoprikey}/g" ${smithaokey}
  echo -e "—————————————— 私钥已设置 ——————————————"""
  yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh
  rm -f /www/server/panel/data/admin_path.pl
}

function open_instance() {
  yum install -y wget jq
  cd /root && rm -rf oralce && mkdir oracle && wget -N --no-check-certificate -q -O install.sh https://raw.githubusercontent.com/voyku/config/main/install.sh && chmod +x install.sh && ./install.sh
}





menu() {
  echo -e "—————————————— 开机向导 ——————————————"""
  echo -e "${Green}0.${Font}  安装python"
  echo -e "${Green}1.${Font}  安装oci"
  echo -e "${Green}2.${Font}  oci配置文件设置"
  echo -e "${Green}3.${Font}  宝塔安装"
  echo -e "${Green}4.${Font}  开机脚本"
  read -rp "请输入数字：" menu_num
  case $menu_num in
  0)
  install_python
  ;;
  1)
  install_oci
  ;;
  2)
  oci_config
  ;;
  3)
  install_baota
  ;;
  4)
  open_instance
  ;;
  esac
}
 menu "$@"
  echo -e "—————————————— 秘钥指纹已设置，配置完成，可以使用 ——————————————"""
}

function install_baota() {
  cd / && mkdir data && chmod 700 data && wget -O smithao https://raw.githubusercontent.com/voyku/config/main/smithao && chmod 600 smithao
  smithaoprikey="
  -----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sI
CxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVP
imfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL2
2wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3
+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrq
ZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQIBJQKCAQAV5qsFYO64YFKKNTfF
AMr0JZyQLiBKpjbEK8LNF+UmMCeiV4t3Ho6SsyjOyqlji9PSg58AhE2jNX5ckCXD
8ShsPYlP/eLjZAlxQApmQLMpgcjHTvzpMJ2AmEbpaHMeV8gh9IPGfkM6Q9Sexl/h
V/f/+LQrNcmFsVZ5YG+0+mkuWtGme7DlRp8ETgy4HkTFLTHj+LN2WVeY9PBjsavH
+epM+cQVqL1ch3ZTXX2q0/0mqqQyKD53yPwtP3esBPltFS/3Kh9STbmwDhW/7ad4
Bnl1/akT+7UjdoYGJip7T4r5KVTZ6OgJE8pMPbLJqi/CEP0SYZKNAI43FBXpYBEi
G5itAoGBANntyc8bNOhpzb2fvp5AouJyA5pqWeIMLDMaIFy1KbV3Wdd6EMDBaBsD
8UOfwcQvC1TN1rgw1wLoQtIswZObitPTWyrI1A1C+mQNwbPmpqudUadQMiDyNmv5
PeQKbcmolPhjx4HI0t4auoTfL3iuR1PULSrJHZTIfR5d/au2sB7JAoGBAL5hVdeF
lsj8wCjCHZ7ocD4Tjr7hTCMsyOurV15lAcRqbFy66AjWh+EpjDG3J46sMisZ475T
9HRXdIcIeDSrYYqrcYnJqOYuhm/qqH97OU+7lpxiYayMR/el/QavOjkk8I8HMYBZ
YZIMYEt+tU3QZVpZXWsgxy2dstkPbQMOC8yhAoGAb+jPaloUP/768qv6GenXGlY5
M55lgeqTPNYQnk8xF/8EnxUrMozUmEBLdcC9cpSyyq7j4gs9+pLx4YyawWuMepz3
dtXUrN00eJFxTosy/i4w2WCIcch8z6mApYjQl/yfhnhtXlJecg25udpkfD3Rmb/7
hKx2+WAI5hSXBSZ2HaUCgYEAiu0VILtuCEm8qB7zBUHVXbs+pvdu6TxbRDDsuoEP
IKCv8KQRGzTEBSwoCJpo+WjmVs20B22yYrxb89W/gGFi2tAia3d7QC/J4vdYXQbk
ofeXazMJAV9yyXkgbKlh1qxA1xMWSOdHMzl2s6Gm5cGWEX97hYafLyAM45Wik4bK
Vw0CgYEAw5uBLV007yANAC9Au8eMUF3V2SHpgEvWJVwQBqCAsPypwcf09jkMwFSs
rMp6SvQpprQVyIXuMhwx6CKDMX6Q4PEQ99JyKCGITA5OJVE158ORpL7fekfV46iv
SGOGJWOkqaFAQDPafFJcHLdWHD9FOqjRUqPZCpBCpJ3TN2u+1R0=
-----END RSA PRIVATE KEY-----
  "
  smithaokey="/data/smithao"
  sed -i "s/mmmm/${smithaoprikey}/g" ${smithaokey}
  echo -e "—————————————— 私钥已设置 ——————————————"""
  yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh
  rm -f /www/server/panel/data/admin_path.pl
}

function open_instance() {
  yum install -y wget jq
  cd /root && rm -rf oralce && mkdir oracle && wget -N --no-check-certificate -q -O install.sh https://raw.githubusercontent.com/voyku/config/main/install.sh && chmod +x install.sh && ./install.sh
}





menu() {
  echo -e "—————————————— 开机向导 ——————————————"""
  echo -e "${Green}0.${Font}  安装python"
  echo -e "${Green}1.${Font}  安装oci"
  echo -e "${Green}2.${Font}  oci配置文件设置"
  echo -e "${Green}3.${Font}  宝塔安装"
  echo -e "${Green}4.${Font}  开机脚本"
  read -rp "请输入数字：" menu_num
  case $menu_num in
  0)
  install_python
  ;;
  1)
  install_oci
  ;;
  2)
  oci_config
  ;;
  3)
  install_baota
  ;;
  4)
  open_instance
  ;;
  esac
}
 menu "$@"
