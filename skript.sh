#!/bin/bash

# vytvorenie skupin
sudo groupadd manazer
sudo groupadd pracovnik

# vytvorenie manazerov
declare -a zoznamManazerov
zoznamManazerov+=(ManazerMichal ManazerkaIveta ManazerMilan)
for i in ${zoznamManazerov[@]}; do
	sudo useradd -g manazer -m $i
	echo "$i:SilneHeslo$i" | sudo chpasswd
done

# vytvorenie pracovnikov
declare -a zoznamPracovnikov
zoznamPracovnikov+=(Jaroslav Zdenka Eugen Florian Dorota Dana Vojtech Stanislava Blazej Ivana Kristof Danka)
poradoveCislo=1
for i in ${zoznamPracovnikov[@]}; do
	sudo useradd -g pracovnik -m $i
	echo "$i:Heslo$i$poradoveCislo" | sudo chpasswd
	((poradoveCislo++))
done


# uprava prav domovskych priecinkov
sudo chmod -R g-rx /home/*


# vytvorenie zdielanych priecinkov pre celu firmu a pre manazerov + zmena prav
mkdir /home/shared
cd /home/shared
sudo mkdir Firma
sudo chmod -R 777 Firma  # povolenie read write a execute pre vsetkych

sudo mkdir Manazeri
sudo chown -R :manazer Manazeri  # zmena vlastnika priecinku
sudo chmod -R 770 Manazeri  # povolenie read write a execute pre vlastnika a skupinu

# instalacia potrebnych programov
sudo apt install "snapd"
sudo snap install "teams-for-linux"
sudo snap install "weektodo"

# odkazy na plochu
declare -A zoznamAplikacii
zoznamAplikacii+=(
	["/var/lib/snapd/desktop/applications/firefox_firefox.desktop"]="Firefox"
	["/usr/share/applications/org.kde.dolphin.desktop"]="Správca súborov"
	["/var/lib/snapd/desktop/applications/thunderbird_thunderbird.desktop"]="Thunderbird"
	["/var/lib/snapd/desktop/applications/teams-for-linux_teams-for_linux.desktop"]="Microsoft Teams"
	["/usr/share/applications/libreoffice-startcenter.desktop"]="LibreOffice"
	["/usr/share/applications/libreoffice-writer.desktop"]="LibreOffice Writer"
	["/usr/share/applications/libreoffice-calc.desktop"]="LibreOffice Calc"
	["/usr/share/applications/libreoffice-impress.desktop"]="LibreOffice Impress"
	["/var/lib/snapd/desktop/applications/weektodo_weektodo.desktop"]="WeekToDo"
	["/usr/share/applications/org.kde.okular.desktop"]="Okular"
)

declare -a vsetciPouzivatelia
vsetciPouzivatelia+=${zoznamManazerov[@]}
vsetciPouzivatelia+=${zoznamPracovnikov[@]}

for i in ${vsetciPouzivatelia[@]}; do
	for j in ${!zoznamAplikacii[@]}; do
		sudo mkdir "/home/$i/Plocha"
		sudo ln -s "$j" "/home/$i/Plocha/${zoznamAplikacii[$j]}"
	done
done
