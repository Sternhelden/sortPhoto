#!/bin/sh

# 2017-4-10 first version
# 2017-4-11 move RAW file to the RAW folder under date folder.

sortPhoto()
{
for ff in $1*
do
	if [ "$ff" != "." ] && [ "$(basename $ff)" != "@eaDir" ]; then
	echo $ff
	echo -e $ff"\r\n" >> $3
	echo ">>>>>>>>>>" >> $3
		if [ -f "$ff" ]; then
			DIRTOMAKE=$(exiv2 -pt $ff | grep -a Exif.Photo.DateTimeOriginal | sed 's/Exif.Photo.DateTimeOriginal                  Ascii      20  //')
			# echo $ff
			# echo ${DIRTOMAKE:0:4}
			# echo ${DIRTOMAKE:5:2}
			# echo ${DIRTOMAKE:8:2}
			if [ -n "${DIRTOMAKE:0:4}" ]; then
				#make year folder and set synoindex
				until [ -d $2${DIRTOMAKE:0:4} ]
				do
					mkdir -p $2${DIRTOMAKE:0:4}
					reIndex $2${DIRTOMAKE:0:4}
				done
				#make date folder
				until [ -d $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2} ]
				do
					mkdir -p $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}/\@eaDir
				done
				
				if [ ${ff##*.} = "ARW" ] || [ ${ff##*.} = "DNG" ] || [ ${ff##*.} = "PEF" ]; then
					
					#make RAW folder
					until [ -d $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}/RAW ]
					do
						mkdir -p $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}/RAW/\@eaDir
					done
					
					#move file
					mv $ff $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}/RAW
					echo "$(basename $ff) has moved to $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}/RAW"
					echo -e "$(basename $ff) has moved to $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}/RAW\r\n" >> $3
					if [ -d $(dirname $ff)/RAW/\@eaDir/$(basename $ff) ]; then
						cp -r $(dirname $ff)/RAW/\@eaDir/$(basename $ff) $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}/RAW/\@eaDir
						rm -r $(dirname $ff)/RAW\@eaDir
						#echo "\@eaDir$(basename $ff) has moved to $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}/\@eaDir"
					fi
					reIndex $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}/RAW
				else
					mv $ff $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}
					echo "$(basename $ff) has moved to $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}"
					echo -e "$(basename $ff) has moved to $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}\r\n" >> $3
					#echo $(dirname $ff)
					#echo $(basename $ff)
					if [ -d $(dirname $ff)/\@eaDir/$(basename $ff) ]; then
						cp -r $(dirname $ff)/\@eaDir/$(basename $ff) $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}/\@eaDir
						rm -r $(dirname $ff)/\@eaDir
						#echo "\@eaDir$(basename $ff) has moved to $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}/\@eaDir"
					fi
					reIndex $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}
				fi
			else
				echo "No EXIF information."
				echo -e "No EXIF information.\r\n" >> $3
			fi
		elif [ -d "$ff" ]; then
			sortPhoto $ff/ $2
		fi
	removeEmptyFolder $1
	fi
done
}

removeEmptyFolder()
{
if [ ! "$(ls -A $1)" ]; then
   echo "$1 is empty and removed!"
   echo -e "$1 is empty and removed!\r\n"
   rm -r /$1
fi
}

#function to reindex syno DB to show pictures in PhotoStation
reIndex()
{
	synoindex -R $1
}


now=$(date "+%Y-%m-%d")
until [ -e ./log-$now.txt ]
do
	touch ./log-$now.txt
done

echo -e "\r\n"$(date "+%Y-%m-%d %H:%M:%S")"\r\n" >> ./log-$now.txt
sortPhoto $1 $2 ./log-$now.txt


#$1 Source directory
#$2 Disitnation directory 
