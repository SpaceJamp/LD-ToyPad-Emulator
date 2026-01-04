sudo apt install -y git libusb-1.0-0-dev libudev-dev podman
[[ -f /boot/firmware/config.txt ]] && ( echo "dtoverlay=dwc2" | sudo tee -a /boot/firmware/config.txt ) || ( echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt )
echo "dwc2" | sudo tee -a /etc/modules
echo "libcomposite" | sudo tee -a /etc/modules
echo "usb_f_rndis" | sudo tee -a /etc/modules

git clone https://github.com/Berny23/LD-ToyPad-Emulator.git
cd LD-ToyPad-Emulator

printf '\necho "$UDC" > UDC\nsleep 2;\nchmod a+rw /dev/hidg0' >> usb_setup_script.sh

sudo cp usb_setup_script.sh /usr/local/bin/toypad_usb_setup.sh
sudo chmod +x /usr/local/bin/toypad_usb_setup.sh
(sudo crontab -l 2>/dev/null; echo "@reboot sudo /usr/local/bin/toypad_usb_setup.sh") | sudo crontab -