#!/bin/sh

# 2017-4-10 first version
# 2017-4-11 move RAW file to the RAW folder under date folder.

sortPhoto()
{
for ff in $1*
do
	if [ "$ff" != "." ] && [ "$(basename $ff)" != "@eaDir" ]; then
	echo $ff
		if [ -f "$ff" ]; then
			DIRTOMAKE=$(exiv2 -pt $ff | grep Exif.Photo.DateTimeOriginal | sed 's/Exif.Photo.DateTimeOriginal                  Ascii      20  //')
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
					if [ -d $(dirname $ff)/RAW/\@eaDir/$(basename $ff) ]; then
						cp -r $(dirname $ff)/RAW/\@eaDir/$(basename $ff) $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}/RAW/\@eaDir
						rm -r $(dirname $ff)/RAW\@eaDir
						#echo "\@eaDir$(basename $ff) has moved to $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}/\@eaDir"
					fi
					reIndex $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}/RAW
				else
					mv $ff $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}
					echo "$(basename $ff) has moved to $2${DIRTOMAKE:0:4}/${DIRTOMAKE:5:2}${DIRTOMAKE:8:2}"
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
			fi
		elif [ -d "$ff" ]; then
			sortPhoto $ff/ $2
		fi
	fi
	removeEmptyFolder $1
done
}

removeEmptyFolder()
{
if [ ! "$(ls -A /$1)" ]; then
   echo "$1 is empty and removed!"
   rm -r /$1
fi
}

#function to reindex syno DB to show pictures in PhotoStation
reIndex()
{
	synoindex -R $1
}

sortPhoto $1 $2

#$1 Source directory
#$2 Disitnation directory 
