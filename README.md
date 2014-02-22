** the-migrator **
******************

  ["My dad migrates orgs..."](http://www.youtube.com/watch?v=nP2xnAMQ3HM)

## Installation
- may need to handle some environment specific dependencies from gems used
  - on debian based GNU/Linux systems install the following packages (sqlite dependencies)
    - sqlite3
    - libsqlite3-dev
  - on mac os x
    - ```brew install sqlite```

## Bash script startup
*for simple access to run in various environment modes*

- add the following to your `~/.bash_aliases` for quick startup menu with ```the-migrator [environment-mode]``` at bash

```
## the-migrator ##
##################

function the-migrator-init(){
echo -e ""
echo -e "You chose to run in $1 mode, if you did not pass a parameter, please do so..."
echo -e ""
echo -e "Here are all the available options:"
echo -e "  => development (default when no parameters are passed)"
echo -e "       * this includes auto page reload functionality"
echo -e "  => production"
echo -e "  => staging"
echo -e ""
rackup -E $1
}

alias the-migrator='cd ~/code/the-migrator && the-migrator-init'
```