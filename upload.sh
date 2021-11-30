
gitbook build ./ docs  

cp -r _book/* ../book_upload_dir/

cd ../book_upload_dir/

git add --all

git commit -m "some update"

git push -u origin master

osascript -e 'display notification "上传完成" with title "上传完成" subtitle "" sound name "Glass"'
