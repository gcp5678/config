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
    bash -c "$(curl -L https://raw.githubusercontent.com/voyku/config/main/py.sh)"
	bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)" 
}

function oci_config() {
  cd /root && rm -rf .oci && mkdir .oci && chmod 700 .oci && cd .oci && wget -O config https://raw.githubusercontent.com/voyku/config/main/config && chmod 600 config
  config="/root/.oci/config"
  read -rp "请输入你的秘钥名(名称不含.pem，默认路径/home/smithao/xxx.pem):" keya
  road="/home/smithao/"
  last=".pem"
  keyb=$road$keya$last
  mv ${keyb} /root/.oci/
  keynamea=${keyb##*/}
  echo -e "—————————————— ${keynamea} ——————————————"""
  chmod 600 /root/.oci/${keynamea}
  sed -i "s/kkkk/${keynamea}/g" ${config}
  echo -e "—————————————— 秘钥已设置 ——————————————"""
  oci setup oci-cli-rc
  
  rm -rf oci-cli-rc && wget -O oci_cli_rc https://raw.githubusercontent.com/voyku/config/main/oci_cli_rc
 
  oci_cli_rc="/root/.oci/oci_cli_rc"
  read -rp "请输入你的userid:" userid
  sed -i "s/uuuu/${userid}/g" ${config}
  echo -e "—————————————— userid已设置 ——————————————"""
  read -rp "请输入你的tenancyid:" tenancyid
  sed -i "s/tttt/${tenancyid}/g" ${config}
  echo -e "—————————————— tenancyid已设置 ——————————————"""
  while :; do
                echo -e "请输入你的region: [1-${#transport[*]}]"
                for ((i = 1; i <= ${#transport[*]}; i++)); do
                        Stream="${transport[$i - 1]}"
                                echo -e " $i.${Stream}"
                done
                read -p "$(echo -e "(输入数字)"):" v2ray_transport
                [ -z "$v2ray_transport" ] && v2ray_transport=1
                case $v2ray_transport in
                [1-4] ) 
				echo -e "区域为 = ${transport[$v2ray_transport - 1]}"
                        Regionsd="${transport[$v2ray_transport - 1]}"
						sed -i "s/gggg/${Regionsd}/g" ${config}
  echo -e "—————————————— region已设置 ——————————————"""
                        break
                        ;;
                *)
                        error
                        ;;
                esac
        done
  
  sed -i "s/xxx/${tenancyid}/g" ${oci_cli_rc}
  echo -e "—————————————— oci_cli_rc已设置 ——————————————"""
  yum install -y openssl
  openssl rsa -pubout -outform DER -in ~/.oci/${keynamea} | openssl md5 -c > opssl
  fingerprinta=$(cat /root/.oci/opssl)
  fingerprint=${fingerprinta#*=}
  sed -i "s/ffff/${fingerprint}/g" ${config}
  echo -e "—————————————— 秘钥指纹已设置，配置完成，可以使用 ——————————————"""
}

transport=(
   us-ashburn-1 
   us-phoenix-1
   eu-frankfurt-1
   uk-london-1 
)
function install_baota() {
  cd / && mkdir data && chmod 700 data 
  read -rp "请输入你的秘钥地址(例如/data/keyname):" keyname
  mv ${keyname} /data/
  keynameb=${keyname##*/}
  chmod 600 /data/${keynameb}
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
  echo -e "${Green}0.${Font}  安装oci"
  echo -e "${Green}1.${Font}  oci配置文件设置"
  echo -e "${Green}2.${Font}  开机脚本"
  read -rp "请输入数字：" menu_num
  case $menu_num in
  0)
  install_oci
  ;;
  1)
  oci_config
  ;;
  2)
  open_instance
  ;;
  esac
}
 menu "$@"


