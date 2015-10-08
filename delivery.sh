#!/bin/bash

### 案件のルートディレクトリを取得 ###
all_path=$1

### 取得したディレクトリが間違っていれば終了 ###
if [ ! -d "$all_path" ]
then
  echo "No such directory in this path. Please retry."
  exit
fi

### 案件名のみを取得する ###
pro_dir="${all_path#*./}" #一番最初の./だけ取り除く
pro_dir="${pro_dir#*diff/}" #diffを取り除く
if [ `echo "$pro_dir" | awk '{print index($0, "/")}'` != 0 ] #pro_dirがすでに案件名の場合はスルー
then
pro_dir=`echo "$pro_dir" | awk '{print substr($0, 1, index($0, "/")-1)}'` #最初の"/"までを案件名とする
fi

### おおもとの納品用ディレクトリ作成（存在すればスルーされる）###
if [ ! -d delivery ]
then
  mkdir delivery
fi

### 年月日時分秒取得と同時に納品フォルダ作成 ###
deli_dir="$pro_dir"_"$(date '+%Y%m%d')"_"$(date '+%H%M%S')" # ここで年月日時分秒を取得
mkdir delivery/$deli_dir

### 納品フォルダに、案件のhtdocsをコピー（htdocsの後に"/"を書いているとhtdocsの下からコピーされてしまう。）###
cp -R $all_path delivery/$deli_dir

### 不要フォルダ・ファイルの削除 ###
find delivery/$deli_dir \( -name *less -or -name _modules -or -name Templates -or -name _*.js -or -name .DS_Store \) | xargs rm -rf {} \;

### 終了宣言 ###
echo Finished.