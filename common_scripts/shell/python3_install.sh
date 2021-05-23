yum -y groupinstall "Development tools"
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
yum install -y libffi-devel zlib1g-dev
yum install -y zlib* 

wget -P /temp/python3 https://www.python.org/ftp/python/3.9.5/Python-3.9.5.tgz

mkdir /temp/python3/target
tar -xvf /temp/python3/Python-3.9.5.tgz -C /temp/python3/target

mkdir /usr/local/python3

cd /temp/python3/target/Python-3.9.5

#第一个指定安装的路径,不指定的话,安装过程中可能软件所需要的文件复制到其他不同目录,删除软件很不方便,复制软件也不方便.
#第二个可以提高python10%-20%代码运行速度.gcc低于8.1.0版本时不要使用此参数
#第三个是为了安装pip需要用到ssl,后面报错会有提到.
./configure --prefix=/usr/local/python3 --with-ssl 

make && make install

ln -s /usr/local/python3/bin/python3 /usr/local/bin/python3
ln -s /usr/local/python3/bin/pip3 /usr/local/bin/pip3

python3 -V
pip3 -V


cd /
rm -rf /temp