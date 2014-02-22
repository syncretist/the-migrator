** the-migrator **
******************

  ["My dad migrates orgs..."](http://www.youtube.com/watch?v=nP2xnAMQ3HM)

## Bash scripting for simple access to run in various environment modes

- add the following to your `~/.bash_aliases` for quick startup menu with ```the-migrator [environment-mode]``` at bash

```
## the-migrator ##
##################

function the-migrator-init(){
rackup -E $1
echo -e ""
echo -e "You chose to run in $1 mode, if you did not pass a parameter, please do so..."
echo -e ""
echo -e "Here are all the available options:"
echo -e "  => development (default when no parameters are passed)"
echo -e "       * this includes auto page reload functionality"
echo -e "  => production"
echo -e "  => staging"
echo -e ""
}

alias the-migrator='cd ~/code/the-migrator && the-migrator-init'
```