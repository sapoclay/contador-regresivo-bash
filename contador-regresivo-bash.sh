#!/bin/bash 

# Mensaje de error
 
if [ "$#" -lt "2" ] ; then 
	echo "Haces un uso incorrecto!!" 
	echo "Los meses deben escribirse en inglés. Un ejemplo correcto sería:" 
	echo './contador.sh -d  "12 Jan 2022 17:46"' 
	echo 'También puedes utilizar minutos como parámetro. Un ejemplo sería:' 
	echo './contador.sh -m  65' 
	exit 1 
fi 

#fecha actual pasada a seg
now=`date +%s` 

#Fecha completa introducida por el usuario 
if [ "$1" = "-d" ] ; then 
	until=`date -d "$2" +%s` 
	sec_rem=`expr $until - $now` 

	#ERROR
	if [ $sec_rem -lt 1 ]; then 
		echo "La fecha $2 ya ha pasado ..."
		exit 1 
	fi 
fi 

#Minutos introducidos por el usuario 
if [ "$1" = "-m" ] ; then 
	until=`expr 60 \* $2` 
	until=`expr $until + $now` 
	sec_rem=`expr $until - $now` 

	#ERROR
	if [ $sec_rem -lt 1 ]; then 
		echo "La hora $2 ya ha pasado ... Vuelve a ejecutar el script y utiliza un número entero." 
		exit 1
	fi 
fi 
 
 #Inicio varaiables para la barra de progreso

_R=0
_C=7
tmp=0
percent=0
total_time=0
col=`tput cols`
col=$[ $col -5 ]

#Muestra y calculo de lo que aparece en pantalla

while [ $sec_rem -gt 0 ]; do 
	clear 
	
	echo "Hoy es "$(date +%A)", "$(date +%d)" de "$(date +%B)" de "$(date +%Y)" a las "$(date +%H:%M:%S)

	let sec_rem=$sec_rem-1 
	interval=$sec_rem 
	seconds=`expr $interval % 60` 
	interval=`expr $interval - $seconds` 
	minutes=`expr $interval % 3600 / 60` 
	interval=`expr $interval - $minutes` 
	hours=`expr $interval % 86400 / 3600` 
	interval=`expr $interval - $hours` 
	days=`expr $interval % 604800 / 86400` 
	interval=`expr $interval - $hours` 
	weeks=`expr $interval / 604800` 

	echo "... y queda hasta la fecha:" $(date -d@$until)
	echo "----------------------------" 
	echo "Segundos: " $seconds 
	echo "Minutos:  " $minutes 
	echo "Horas:    " $hours 
	echo "Días:     " $days 
	echo "Semanas:  " $weeks 

#Barra de progreso
	
	echo -n "["

	progress=$[$progress + 1]
	if [ $total_time -lt 1 ] ; then
		total_time=$[$hours * 3600 + $minutes * 60 + $seconds]
	fi
	
	printf -v f "%$(echo $_R)s>" ; printf "%s\n" "${f// /=}"
	_C=7
	tput cup 7 $col

	tmp=$percent
	percent=$[$progress * 100 / $total_time]
	printf "]%d%%" $percent
	change=$[$percent - $tmp]

	_R=$[ $col * $percent / 100 ]

	sleep 1

done

printf "\n"
echo "Programa finalizado !!!"
printf "\n"
