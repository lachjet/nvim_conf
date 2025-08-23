# lachjet/nvim_conf (OpenBSD)
Neovim Config for OpenBSD
![Screenshot from 2025-08-24 09-33-51](https://raw.githubusercontent.com/lachjet/nvim_conf/refs/heads/OpenBSD/images/Screenshot%20from%202025-08-24%2009-33-51.png)


## LSP and programs
For this config to work you will require to download the lsps manually. I decided to avoid using mason, so that the lsps can be shared by any other editor that needs them. 

## Set up keybinding to open from desktop
To set up a keybinding from desktop, write a keybinding that runs the following
command:
```
gnome-terminal --maximize -- bash --rcfile ~/.bashpath -i -c nvim
```
- `gnome-terminal` may be replaced by whatever terminal you use.\\
- `bash` may also be replaced with whatever shell you use.\\

Note: For shells only been tested on bash. For terminal emulators, gnome-terminal seems to work nicely. Have used it with kitty, however clipboard buffers don't seem to work as nicely.  
- `~/.bashpath` can be replaced by a .bashrc if desired. However to ensure nvim opens quickly, this file should only do the minimum of what it has to. Currently mine only defines the required paths for the lsp and program executables. 
- the --maximize option is to ensure that nvim starts up using the entire screen to avoid a user needing to maximize it manually to see all the text. 
