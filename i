#!/data/data/com.termux/files/usr/bin/bash -e

red='\033[1;31m'
yellow='\033[1;33m'
blue='\033[1;34m'
reset='\033[0m'


proot_patch() {
	printf "\n\n"
	printf "$[+] checking ..."
		axel --alternate https://github.com/Hax4us/Nethunter-In-Termux/raw/master/proot
			mv proot $PREFIX/bin
				chmod +x $PREFIX/bin/proot
				apk-mark hold proot 		
	}

setchroot() {
	chroot=minimal
}
unknownarch() {
	printf "$red"
	echo "[*] Unknown Architecture :("
	printf "$reset"
	exit
}

checksysinfo() {
	printf "$blue [*] Checking host architecture ..."
	case $(getprop ro.product.cpu.abi) in
		arm64-v8a)
			SETARCH=arm64
			;;
		armeabi|armeabi-v7a)
			SETARCH=armhf
			;;
		*)
			unknownarch
			;;
	esac
}


checkdeps() {
	printf "${blue}\n"
	echo " [*] Updating apt cache..."
	apt update -y &> /dev/null
	echo " [*] Checking for all required tools..."

	for i in proot ; do
		if [ -e $PREFIX/bin/$i ]; then
			echo "  • $i is OK"
		else
			echo "Installing ${i}..."
			apt install -y $i || {
				printf "$red"
				echo " ERROR: check your internet connection or apt\n Exiting..."
				printf "$reset"
				exit
			}
		fi
	done
}
