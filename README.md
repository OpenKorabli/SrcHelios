# SrcHelios
## 介绍
为战舰世界制作的优化版字体，聚合Source Han Sans（多语言）与Warhelios字形。
## 版本
### 1. 通用版（SrcHelios-FC）
适合所有玩家——替换fontconfig.xml并引入新文件
### 2. 直接替换亚洲字库版（SrcHelios-DR-ASIA）
适合使用中文或日文作为游戏语言的玩家——替换中/日字库文件
### 3. 直接替换欧洲字库版（SrcHelios-DR-EU）
适合使用其他语言作为游戏语言的玩家——替换欧/韩字库文件
## 下载
进入[最新发布](https://github.com/LocalizedKorabli/SrcHelios/releases/latest)，按版本下载相应文件；

或直接点击以下链接下载：
- [通用版](https://github.com/LocalizedKorabli/SrcHelios/releases/download/1.0.0/SrcHelios-FC.zip)
- [直接替换亚洲字库版](https://github.com/LocalizedKorabli/SrcHelios/releases/download/1.0.0/SrcHelios-DR-ASIA.zip)
- [直接替换欧洲字库版](https://github.com/LocalizedKorabli/SrcHelios/releases/download/1.0.0/SrcHelios-DR-EU.zip)

大陆用户可通过[蓝奏云](https://tapio.lanzn.com/b0nyjuylc)下载。
## 安装
1. 进入游戏目录，打开`bin`文件夹；
2. 在`bin`文件夹内所有名称为纯数字的文件夹中，选择其中数值最高的一个或两个（若存在），分别执行下一步操作；
3. 打开数字文件夹后，再打开`res_mods`文件夹，将您下载的字体模组zip文件解压到`res_mods`文件夹中。

    以`通用版`为例，若bin文件夹内符合要求的两个数字文件夹分别为“8791303”和“8788819”，最终的目录结构（已省略其他文件）应为：
    ```
    游戏目录
    └─bin
        ├─8788819
        │   └─res_mods
        │       │   fontconfig.xml
        │       └─SrcHelios
        │               SrcHeliosBold.ttf
        │               SrcHeliosMedium.ttf
        │
        └─8791303
            └─res_mods
                │   fontconfig.xml
                └─SrcHelios
                        SrcHeliosBold.ttf
                        SrcHeliosMedium.ttf
    ```
## 效果
### 1. 数字和西里尔字符

#### 更紧凑的空格让数字显示更美观

- 安装前：

    <img width="600" alt="coverage" src="https://github.com/user-attachments/assets/469088e7-13d8-4f89-9fea-d30a00ce7f90">

- 安装后：

    <img width="600" alt="coverage" src="https://github.com/user-attachments/assets/f26bb205-e44d-40fc-a882-e70bf3594a51">

#### 更加合理的西里尔字符宽度

- 安装前后对比：

    <div align="left">
    <img src="https://github.com/user-attachments/assets/aaef3935-215b-4c5b-9cce-95c144e48152" alt="西里尔字符（安装前）" width="300" style="margin-right: 10px;">
    <img src="https://github.com/user-attachments/assets/dc01ec4c-bdb4-411c-a022-cba238f5c96c" alt="西里尔字符（安装后）" width="300" style="margin-right: 10px;">
    </div>


### 2. 多语言字符覆盖率

- 安装后效果：

    <img width="600" alt="coverage" src="https://github.com/user-attachments/assets/98a7eb8b-ade5-4997-94b7-097c40614997">
