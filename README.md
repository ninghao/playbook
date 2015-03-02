[Ninghao Playbook](https://github.com/ninghao/playbook "Ninghao Playbook 仓库")（宁皓剧本），是用 Ansible 写的一个自动化配置 Drupal 本地开发环境的剧本，它需要结合 [Vagrant](http://ninghao.net/course/1569 "Vagrant 课程") 使用。它可以自动配置虚拟机，安装好 Drupal 所需要的运行环境（nginx，php-fpm，mariadb ... ），还有 Drupal 本身，以及一些常用的模块（views，token，features，module_filter ... ）。

![playbook](http://work.ninghao.net/wp-content/uploads/2015/03/playbook.jpg)

## 操作摘要

<pre>1. 创建项目
   cd ~/desktop
   git clone https://github.com/ninghao/playbook.git ninghao_drupal

2. 编辑配置文件
   cd ninghao_drupal/playbooks
   cp -R config_default config

3. 启动虚拟机
   vagrant up

4. 连接到 master 机器

   Mac 用户可以：
   vagrant ssh master

   Windows 用户需要先查看连接到 master 的信息：
   vagrant ssh-config

   然后把相关信息输入到 Putty 里面，默认连接使用的用户是 vagrant，密码也是 vagrant 。

5. 生成 ssh 公钥与密钥

   在 Master 机器上：
   ssh-keygen
   ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@192.168.33.130
   ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@192.168.33.131
   ansible-playbook -l local /vagrant/playbooks/local.yml
   ansible-playbook -l dev /vagrant/playbooks/dev.yml

6. 编辑本机的 hosts 文件

   在你的电脑上：
   Mac：打开 /etc/hosts ，Windows：打开 C:\Windows\System32\Drivers\etc ，添加下面的内容：
   # Local
   192.168.33.130 dp.ninghao.local
   192.168.33.130 phpmyadmin.ninghao.local

   # Dev
   192.168.33.131 dp.ninghao.dev
   192.168.33.131 phpmyadmin.ninghao.dev

7. 打开浏览器测试

</pre>

##  Ninghao Playbook 都做了什么

主要就两件事：配置 Drupal 运行环境，还有安装 Drupal。目前只支持 Drupal 7 。Ninghao Playbook 用的 box（ninghao/playbook-64） 是基于 CentOS 7 做的，你也可以使用其它的 CentOS 的 box（比如 chef/centos-7.0） ，Vagrant 会按照 Ninghao Playbook 自动去配置 box 。

启动以后，你会得到三台虚拟机， Master（控制）， Local（本地），还有 Dev（开发）。Master 用来控制 Local 还有 Dev，主要是在它上面执行 Ninghao Playbook 来自动配置 Local 与 Dev 。启动以后，在 Master 上面已经安装好了 Ansible 。

运行 Drupal 我定义两台虚拟机，Local 与 Dev。这样做是为了模拟 Drupal 开发用到的本地环境与开发环境。比如怎么样把在本地所做的修改，同步到开发环境上，怎么样把开发环境上的数据库同步到本地。

### 环境

环境可以理解成是网站运行的不同的地方，首先你需要一个 local（本地）环境，你的开发都是在本地进行的，团队的其它成员都有自己的本地开发环境。开发到一定程度以后，可以把代码推送到 Dev（开发）或者 Staging （工作）环境上去运行，你的团队成员，也可以把它们的工作推送到这个开发环境上，一般这个开发环境是在远程。然后你需要再把开发的东西推送到 Production （生产）环境上，也就是网站正式运行的环境。

为了简单点，Ninghao Playbook 在本地同时搭建了两个环境，一个是 Local ，一个是 Dev。你可以分别控制它们。

### Box

Box 是 Vagrant 管理的虚拟机镜像，Ninghao Playbook 里面用到了 ninghao/playbook-64 这个 Box ，是基于 CentOS 7 做的一个 Box，默认这个 Box 里面已经安装好了运行 Drupal 需要的一些东西，nginx，php-fpm，mariadb，drush 等等。这些东西都是由 Ninghao Playbook 控制的，也就是你可以自己去修改配置文件，去改变 Box 里的东西，比如去安装新的 php 扩展，新的服务，去改变 Drupal 的设置等等。
> 你可以在百度云盘上下载到 ninghao/playbook-64 这个 Box：http://pan.baidu.com/s/1qWmc18S

### 默认

Drupal：config/*/drupal.yml

*   管理员：admin
*   管理员密码：admin
*   数据库名：drupal
*   数据库用户：drupal
*   数据库密码：drupal
MariaDB：config/*/mariadb.yml

root 用户的默认密码：root

## 准备

*   一台 64 位架构的电脑。不管是 mac 还是 pc ，只要是 64 位架构就行。内存可以大一些，硬盘最好是固态的 。建议您至少有一台这样的电脑，没有的话，可以跟老婆或者老妈商量商量，用来学习是个不错的理由 ：）
*   在本地安装 Vagrant。我们要用 Vagrant 去管理虚拟机，因为 Drupal 要运行在这些 Linux 系统的虚拟机上。
*   在本地安装 Git 。Git 用来做版本控制，你可以用它来跟踪宁皓剧本的变化。

## 用法

### 1. 克隆一份 Ninghao Playbook

把 Ninghao Playbook 仓库克隆到本地一份。先进入到你想存储 Drupal 项目的地方，我想把要开发的项目放到桌面上。
<pre>cd ~/desktop
git clone https://github.com/ninghao/playbook.git ninghao_drupal</pre>
上面的命令，会在我的用户主目录下面的 desktop（桌面） 目录里，克隆了一份 Ninghao Playbook，放到了 ninghao_drupal 这个目录的下面。

### 2. 创建配置文件

用文本编辑器打开 ninghao_drupal 。然后复制一下 config_default 这个目录，命名为 config ，再根据自己的需求去编辑 config 目录下面的一些配置文件，比如 Drupal 要使用的数据库的名字，管理员的用户名，密码之类的。注意 config 目录下面应该有两个目录，一个是 dev，一个是 local ，分别表示在不同的环境下的不同的配置。

### 3. 启动

进入到你的项目所在的目录，然后执行：
<pre>vagrant up</pre>
上面的命令，会自动到 Atlas 去下载 ninghao/playbook-64 这个 box ，放到自己的电脑上，为当前项目导入并使用这个 box 。启动以后，你会得到三台主机 master，local 还有 dev，你可以分别 ssh 连接到它们。

### 4. 配置

#### 连接到 master

启动以后，先登录到 master 这台主机上，Mac 用户可以这样：
<pre>vagrant ssh master</pre>
Windows 用户要使用 Putty 工具 ssh 连接到虚拟机，你可以先查看一下 ssh 连接的信息：
<pre>vagrant ssh-config</pre>
会返回：
<pre>Host master
  HostName 127.0.0.1
  User vagrant
  Port 2222
</pre>
上面是你用 Putty 连接到 master 上的 ssh 信息，我这里，HostName 主机名是 127.0.0.1 ，User 是 vagrant，注意 Port 端口号是 2222，你要用的端口号很可能跟这个不一样。

#### 生成 ssh 密钥与公钥

连接到 master 上以后，先去生成 ssh 的密钥与公钥，然后你要把生成的公钥放到 local 跟 dev 这两台机器上，这样你在 master 上就可以不需要密码，直接 ssh 连接到 local 与 dev 了，下面是具体的方法：

在 master 主机上，执行：
<pre>ssh-keygen</pre>
一路回车，上面的命令会生成密钥与公钥，这些文件默认的位置是在：~/.ssh ，文件名是：id_rsa 还有 id_rsa.pub。你要把 id_rsa.pub 这个文件里的内容放到 local 与 dev 上去，可以这样做：
<pre>ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@192.168.33.130</pre>
会提示你输入密码，默认是 vagrant。上面的命令，会把 id_rsa.pub 里的内容，复制到 192.168.33.130 上的 vagrant 这个用户的 .ssh 目录下面的，authorized_keys 这个文件里。现在，你就可以直接在 master 上，ssh 连接到 192.168.33.130（local）上了，不需要输入密码。

用同样的方法，再去处理一下 dev 这个机器：
<pre>ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@192.168.33.131</pre>

#### 执行 Ninghao Playbook

现在，你就可以在 master 机器上，执行 Ninghao Playbook，去配置 local 还有 dev 这两台机器了。配置 local，可以这样：
<pre>ansible-playbook -l local /vagrant/playbooks/local.yml</pre>
配置 dev，执行：
<pre>ansible-playbook -l dev /vagrant/playbooks/dev.yml</pre>
完成以后，会在 local 与 dev 这两台机器上都安装好 Drupal 所需要的环境，还有 Drupal 本身。

### 5. 配置主机名

默认 local 环境使用的主机名是 dp.ninghao.local，IP 地址是 192.168.33.130，dev 环境使用的主机名是 dp.ninghao.dev ，IP 地址是 192.168.33.131。你需要手工配置一下自己电脑上的 hosts 文件，这是一个文本文件，你可以用文件编辑器打开并编辑它，然后添加下面内容：
<pre># Local
192.168.33.130 dp.ninghao.local
192.168.33.130 phpmyadmin.ninghao.local

# Dev
192.168.33.131 dp.ninghao.dev
192.168.33.131 phpmyadmin.ninghao.dev</pre>
Windows：C:\Windows\System32\Drivers\etc ，Mac：/etc/hosts

### 6. 测试

一切正常的话，你现在应该可以通过 dp.ninghao.local 打开 Local 环境的 Drupal ，用 dp.ninghao.dev 可以访问 Dev 环境的 Drupal 。

### 7. 连接

Mac 用户可以使用 vagrant ssh 命令可以连接到主机，Windows 用户应该要用到 Putty 这个小工具。Mac 用户可以这样连接到 local 主机：
<pre>vagrant ssh local</pre>
要连接到 dev 主机，可以这样：
<pre>vagrant ssh dev</pre>
Windows 用户使用 Putty 的时候，你要知道 ssh 的 IP 地址（127.0.0.1），端口号（每台主机的 ssh 端口号是不同的），还有用户（默认是 vagrant）跟密码（默认也是 vagrant），可以这样查看这些信息：
<pre>vagrant ssh-config</pre>
根据返回的信息，去配置使用 Putty ，连接到不同的主机（ master，local 或者 dev ）。

## 目录结构

启动并且都配置好以后，你的项目的目录结构看起来会像下面这样：
<pre>.
├── .gitignore
├── Vagrantfile
├── app
│   └── local
│   └── dev
└── playbooks
    ├── config
    │   ├── dev
    │   └── local
    ├── config_default
    │   ├── dev
    │   └── local
    ├── files
    │   └── repo
    │   └── shell
    ├── roles
    │   ├── drupal
    │   │   └── tasks
    │   ├── drupal_contrib
    │   │   └── tasks
    │   ├── init
    │   │   └── tasks
    │   ├── mariadb
    │   │   └── tasks
    │   ├── nginx
    │   │   └── tasks
    │   ├── php-fpm
    │   │   └── tasks
    │   ├── phpmyadmin
    │   │   └── tasks
    │   └── tool
    │       └── tasks
    └── templates
        ├── drupal
        └── nginx</pre>

*   .gitignore：这个文件的作用是告诉 Git 要忽略跟踪的文件都有哪些。
*   Vagrantfile：Vagrant 要用到的配置文件。
*   app：这里面是在不同环境下安装好的 Drupal ，还有一些其它的应用，比如 phpMyAdmin。local 里面是本地环境下的应用，dev 目录里面是开发环境下的应用。
*   playbooks：这里是写好的剧本。就是配置服务器用的代码。
    *   config：配置文件，就是一些变量，你可以修改这些配置文件里的对应的变量的值。
    *   config_default：默认的配置文件。
    *   files：要复制到服务器上的一些文件。复制到哪里，是在 playbook 里面指定的。
    *   roles：把配置按照功能，分成不同的 role ，每个 role 都有自己的功能。
        *   drupal：配置与安装 Drupal 用的。
        *   drupal_contrib：配置安装并启用一些 Drupal 常用的模块。
        *   init：一些初始化的配置。
        *   mariadb：配置数据库。
        *   nginx：配置 Web 服务器。
        *   php-fpm：配置 php 。
        *   phpmyadmin：配置安装 phpMyAdmin。
        *   tool：配置安装一些常用的工具。
        *   templates：这里也是一些要复制到服务器上的文件，只不过，这些文件里面，可以设置变量。这些变量的值，是在 config 目录下面设置的。

## 问题

### 第一次 vagrant up 的时候，下载 box 太慢了

你可以先把 box 文件下载到本地，然后在本地手工去添加这个 box ，再去执行 vagrant up 的时候，Vagrant 会直接使用你添加到本地的 box 。百度云盘：http://pan.baidu.com/s/1qWmc18S 。

下载 ninghao_playbook_64.box 这个 box ，然后手工添加它，比如下载之后这个 box 文件在 downloads 目录下面，这个 box 文件的名字是 ninghao_playbook_64.box ，手工添加它可以这样：
<pre>vagrant box add ninghao/playbook-64 ~/downloads/ninghao_playbook_64.box</pre>

完成以后，用 vagrant box list  查看一下可用的 box，你会看到刚才添加的 ninghao/playbook-64 ，这样再用 vagrant up 启动的时候，就不需要去下载这个 box 了，会直接在本地导入它。

---
made with ：） by [ninghao.net](http://ninghao.net)
