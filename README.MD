****************************************************************
This repo is used to build RA program for NBR project.
Author: Jinlai He
Time: 2017-03-22
****************************************************************

****************************************************************
Before build this repo, please check you has set the default git server address and login name:
There should be a file named "config" in /home/<name>/.ssh path, and the content for this file is below:
    Host domain.com
        User B

Example for my setting as below:
    Host git.nane.cn
        User hejinlai

Detailed information for this setting can refer to website:
http://stackoverflow.com/questions/6041516/git-submodule-update-with-other-user        
****************************************************************

****************************************************************
Description for each file as below:

1. gomodules.txt
Store the main module name and path, the format is below:
    submodule=xxxx,path=yyyy

Example:
    submodule=src/smartconn.cc/liugen/audio,path=ssh://git.nane.cn:29418/project/ra/firmware/audiomanager

2. gomodules_dep.txt
Store the dependency module name and path, the format is below:
    submodule=xxxx,path=yyyy

Example:
    submodule=src/github.com/satori/go.uuid,path=https://github.com/satori/go.uuid.git

3. cmodules.txt
Store the C/C++ releted module name, example as below:
    src/smartconn.cc/LuoYang/PageFlip

4. main_module.txt
Store the main module name, example as below:
    src/smartconn.cc/tosone/ra_main

5. initsubmodule.sh
Init, create or update all submodules.

6. build.sh
The function for build.sh is below:
6.1. Use initsubmodle.sh to init, create or update all submodules.
6.2. Check cross-compile nvironment.
6.3. Create release folder.
6.4. Build and release C/C++ releted submodules.
6.5. Build and release ra

****************************************************************
