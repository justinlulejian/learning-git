#!/bin/sh -x

echo "Install git on new machine, confgure it, and generate SSH keys, then echo it"
echo "\nso that we can paste it into https://github.com/settings/ssh#."

keygen ()
{
  # Generating public/private rsa key pair.
  ssh-keygen -t rsa -C "justin@lulejian.com"
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
}

copy_pub ()
{
# Install xclip and copy the key to the  clipboard for copying
sudo apt-get install xclip
xclip -sel clip < ~/.ssh/id_rsa.pub
echo "id_rsa.pub copied to clipboard."
}

# Installing and configuring git
echo "Installing and configuring git for user."
sudo apt-get install git
git config --global user.name "Justin Lulejian"  # convert to var
git config --global user.email "justin@lulejian.com" # convert to var

if [ -e ~/.ssh/id_rsa.pub ]  # Check if this file exists, if not generate it.
then
  echo "id_rsa.pub exists, copying to the clipboard."
  copy_pub
else
  echo "id_rsa.pub does not exist, generating one..."
  keygen
  copy_pub
fi

# Open github account SSH settings in web browser
echo "Opening giuthub setting window in web browser."
xdg-open "https://github.com/settings/ssh#" &

# Test SSH connection
ssh -T git@github.com

# SSH exits with 1 apparently because conection is closed by github automatically?
if [ $? -eq 1 ]
then
  echo "Successfull connection to github via SSH!"
fi
