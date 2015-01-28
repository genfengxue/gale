# gale
server for wind

## 开发环境
* 手动编译安装```node v0.10.36```
* coffee
```
sudo npm install -g coffee-script #v1.8.0
```
* git
```
sudo apt-get install git
```
* vim
```
sudo apt-get install vim-gtk
```
* node-gyp
```
sudo npm install -g node-gyp
```
* mongodb 从官方网站下载安装，apt-get的版本比较旧
```
wget 'https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.6.7.tgz?_ga=1.248495747.50323675.1407724116' -O 'mongodb-linux-x86_64-2.6.7.tgz'
tar xvfz mongodb-linux-x86_64-2.6.7.tgz
sudo service mongodb stop
sudo cp mongodb-linux-x86_64-2.6.7/bin/* /usr/bin/
sudo service mongodb start
```

## 进入项目根目录：
```
npm install
npm start
```
