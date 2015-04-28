#字幕处理GBK
for i in $(file * | grep 'ISO-8859' | awk 'BEGIN{FS=":"} {print $1}')
do
  j="${i}_tmp"
  iconv -f GBK -t UTF-8 $i > $j
  mv $j $i
  dos2unix -r $i
done

#字幕处理UTF-16
for i in $(file * | grep 'UTF-16' | awk 'BEGIN{FS=":"} {print $1}')
do
  j="${i}_tmp"
  iconv -f UTF-16 -t UTF-8 $i > $j
  mv $j $i
  dos2unix -r $i
done
