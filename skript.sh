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
