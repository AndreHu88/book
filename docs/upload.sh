gitbook install

gitbook build ./ docs   

git add --all

git commit -m "some update"

git push -u origin master

osascript -e 'display notification "上传完成" with title "gitbook上传完成" subtitle "操作完成，可以体验" sound name "Glass"'
