cd local_data

cd direct_english
for i in $(ls lesson*.srt); do
  echo "de0${i:6:2}.srt"
  git mv $i "de0${i:6:2}.srt"
done

cd ../key_point_txt
for i in $(ls lesson*.txt); do
  echo "de0${i:6:2}.txt"
  git mv $i "de0${i:6:2}.txt"
done

cd ../nce1
for i in $(ls nce1lesson*.srt); do
  echo "nceone${i:10:3}.srt"
  git mv $i "nceone${i:10:3}.srt"
done

cd ../nce1_key_point_txt
for i in $(ls nce1lesson*.txt); do
  echo "nceone${i:10:3}.txt"
  git mv $i "nceone${i:10:3}.txt"
done

cd ../

git mv direct_english de
git mv direct_english_base de_base
git mv direct_english_json de_json
git mv key_point_txt de_key_point_txt
git mv key_point_json de_key_point_json

git mv nce1 nceone
git mv nce1_base nceone_base
git mv nce1_json nceone_json
git mv nce1_key_point_txt nceone_key_point_txt
git mv nce1_key_point_json nceone_key_point_json

for i in de nceone; do
  git rm -f ${i}_base/*
  git rm -f ${i}_json/*
  git rm -f ${i}_key_point_json/*
done
