#!/bin/sh
#处理新概念文本
#找出所有ISO-8859编码的文件，并转码为UTF-8
for i in $(file * | grep 'ISO-8859' | awk 'BEGIN{FS=":"} {print $1}'); do iconv -f GBK -t UTF-8 $i > ${i/.txt/.new.txt}; done
#找出所有UTF-16编码的文件，并转码为UTF-8
for i in $(file lesson??.txt | grep 'UTF-16' | awk 'BEGIN{FS=":"} {print $1}'); do iconv -f UTF-16 -t UTF-8 $i > ${i/.txt/.new.txt}; done
#偶数行后面加空行
gsed '1~2!G' -i *.txt
#转为windows风格的断行，这里应该调查一下，可否通过sed直接完成
unix2dos *.txt

file $(git diff --name-only 149c917043eb0778d3b1205d6e23dc80e2356f1f..HEAD)
for i in $(file $(git diff --name-only 149c917043eb0778d3b1205d6e23dc80e2356f1f..HEAD) | grep 'ISO-8859' | awk 'BEGIN{FS=":"} {print $1}'); do iconv -f GBK -t UTF-8 $i > ${i/.srt/.new.srt}; done

for i in $(file $(git diff --name-only 149c917043eb0778d3b1205d6e23dc80e2356f1f..HEAD) | grep 'UTF-16' | awk 'BEGIN{FS=":"} {print $1}'); do iconv -f UTF-16 -t UTF-8 $i > ${i/.srt/.new.srt}; done

#批量重命名
for i in $(ls nce1lesson???.txt); do git mv $i "nceone${i:10:3}.txt"; done

#字幕处理GBK
for i in $(file * | grep 'ISO-8859' | awk 'BEGIN{FS=":"} {print $1}')
do
  j="${i}_tmp"
  iconv -f GBK -t UTF-8 $i > $j
  mv $j $i
  dos2unix $i
done

#字幕处理UTF-16
for i in $(file * | grep 'UTF-16' | awk 'BEGIN{FS=":"} {print $1}')
do
  j="${i}_tmp"
  iconv -f UTF-16 -t UTF-8 $i > $j
  mv $j $i
  dos2unix $i
done

#批量重命名
for i in $(ls); do
  mv $i "de0${i:6:2}.txt"
done

for i in $(ls nce1video??_*); do
#  echo $i
  mv $i "nceone0${i:9:2}.jpg"
done

for i in $(ls nce1video???_*); do
#  echo $i
  mv $i "nceone${i:9:3}.jpg"
done

#处理QQ号
for i in *.txt; do
  gsed 'N;N;s/\n/\t/g;' $i | awk 'BEGIN{FS="\t+"} {print $2, $3, $4}' > processed/${i/.txt/.new.txt}
done
