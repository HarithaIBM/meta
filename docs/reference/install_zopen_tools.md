# Setting up your native z/OS Open Tools environment

Note: In the documentation that follows, _\<...\>_ indicates a value you need to provide, e.g. _\<z/OS\>_ would be replaced with the name of the z/OS system you are using.

To install _zopen tools_, you need to run _zopen-setup_ on z/OS: 

## Get zopen-setup to z/OS

- [download zopen-setup](https://zosopentools.link/setup-program) to your desktop
- open a terminal window on your desktop
- change into the directory you saved _zopen-setup_
- _sftp_ \<z/OS\>
- _put zopen-setup_
- _quit_

## Mark zopen-setup executable

- _ssh \<z/OS\>_
- _cd $HOME_
- _chmod u+x zopen-setup_

## Run zopen-setup and install tools into \<directory\>

- _cd $HOME_
- _./zopen-setup \<directory\>_

## Set up your environment to include zopen tools

- _cd $HOME/zopen/boot_
- _. ./.bootenv_

You will need to set up your environment every time you want to use _zopen tools_

