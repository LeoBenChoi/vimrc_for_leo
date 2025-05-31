# vimrc for Leo REMADE.md

描述：纯vim，这个是我个人使用的vimrc，可以进行一个参考，目前在适配windows的vim和gvim，Linux目前适配了kali。



## 安装

**前提条件： 提前安装git命令**



### Windows：

目前我用的是win11，安装方法如下：

1. 到vim官网下载安装包，安装vim

2. 到用户目录下创建`.vim`文件夹，在`C:\Users\<yourusername>\.vim`下执行git命令

   ```powershell
   git clone http://github.com/LeoBenChoi/vimrc_for_leo.git ./
   copy .vimrc ../
   ```
   
3. 现在可以使用基本功能了，后续是插件安装

5. 打开vimrc之后，执行以下函数

   ```
   :call InstallPlugins()
   ```

6. vimrc全功能安装完成



### Linux

Kali、CentOS、Ubuntu、Rocky：

1. 创建.vim文件夹（有些系统没有）

   ```bash
   mkdir ~/.vim
   ```

   

2. 克隆项目

   ```bash
    git clone https://github.com/LeoBenChoi/vimrc_for_leo.git ~/.vim/
   ```

   

   **CentOS的vimrc需要放到~/下，也就是执行了克隆项目之后需要吧**

3. 现在可以使用基本功能了，后续是插件安装

4. 打开vimrc之后，执行以下函数

   ```
   :call InstallPlugins()
   ```

   

5. 我的vimrc全功能安装完成

### 一些小问题

- 扩展文件名问题：

  | 扩展   | 推荐使用的系统                |
  | ------ | ----------------------------- |
  | vimrc  | Windows，CentOS，             |
  | .vimrc | Windows，Ubuntu，Kali，Rocky         |
  | _vimrc | Windows，CentOS，Ubuntu，Kali，Rocky |

  
