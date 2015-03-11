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
