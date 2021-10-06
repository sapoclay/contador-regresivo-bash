#!/bin/bash 
#https://linuxconfig.org/time-countdown-bash-script-example 

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
ahora=`date +%s` 

#Fecha completa introducida por el usuario 
if [ "$1" = "-d" ] ; then 
	fec_seg=`date -d "$2" +%s` 
	sec_m=`expr $fec_seg - $ahora` 

	#ERROR
	if [ $sec_m -lt 1 ]; then 
		echo "La fecha $2 ya ha pasado ..."
		exit 1 
	fi 
fi 

#Minutos introducidos por el usuario 
if [ "$1" = "-m" ] ; then 
	fec_seg=`expr 60 \* $2` 
	fec_seg=`expr $fec_seg + $ahora` 
	sec_m=`expr $fec_seg - $ahora` 

	#ERROR
	if [ $sec_m -lt 1 ]; then 
		echo "La hora $2 ya ha pasado ... Vuelve a ejecutar el script y utiliza un número entero." 
		exit 1
	fi 
fi 
 
 #Inicio varaiables para la barra de progreso

aument=0
tmp=0
colum=`tput cols`
colum=$[ $colum -5 ]
porcentaje=0
tiempo_total=0

#Muestra y calculo de lo que aparece en pantalla

while [ $sec_m -gt 0 ]; do 
	clear 
	
	echo "Hoy es "$(date +%A)", "$(date +%d)" de "$(date +%B)" de "$(date +%Y)" a las "$(date +%H:%M:%S)

	let sec_m=$sec_m-1 
	interval=$sec_m 
	segundos=`expr $interval % 60` 
	interval=`expr $interval - $segundos` 
	minutos=`expr $interval % 3600 / 60` 
	interval=`expr $interval - $minutos` 
	horas=`expr $interval % 86400 / 3600` 
	interval=`expr $interval - $horas` 
	dias=`expr $interval % 604800 / 86400` 
	interval=`expr $interval - $horas` 
	semanas=`expr $interval / 604800` 

	echo "... y queda hasta la fecha:" $(date -d@$fec_seg)
	echo "----------------------------" 
	echo "Segundos: " $segundos 
	echo "Minutos:  " $minutos 
	echo "Horas:    " $horas 
	echo "Días:     " $dias 
	echo "Semanas:  " $semanas 

#Barra de progreso
	
	echo -n "["

	progreso=$[$progreso + 1]
	if [ $tiempo_total -lt 1 ] ; then
		tiempo_total=$[$horas * 3600 + $minutos * 60 + $segundos]
	fi
	
	printf -v f "%$(echo $aument)s>" ; printf "%s\n" "${f// /-}]"
	
	tput cup 7 $colum

	tmp=$porcentaje
	porcentaje=$[$progreso * 100 / $tiempo_total] 
	porcentaje=$[$porcentaje]
	change=$[$porcentaje - $tmp]

	aument=$[ $colum * $porcentaje / 100 ]

	printf "[%d%%]" $porcentaje
	sleep 1

done

printf "\n"
echo "Programa finalizado !!!"
printf "\n"
