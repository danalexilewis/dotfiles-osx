# dotfiles-osx

## Adding symlinks
All files in dotfiles need to be symlinked to their respective locations:

```
cp dotfiles-osx/.z ~/.z
ln -s dotfiles-osx/.hypers.js ~/.hyper.js
ln -s dotfiles-osx/.p10k.zsh ~/.p10k.zsh
ln -s dotfiles-osx/.spacemacs ~/.spacemacs
ln -s dotfiles-osx/.spacevim ~/.spacevim
ln -s dotfiles-osx/.zshrc ~/.zshrc
rm  ~/Library/Application\ Support/code/User/settings.json
ln -s dotfiles-osk/VSCodium/settings.json ~/Library/Application\ Support/code/User/settings.jso
n```
