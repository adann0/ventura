#export JAVA_HOME=$(/usr/libexec/java_home -v 11.0.17)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/usr/local/opt/openjdk@8/bin:$PATH"
export PATH="/usr/local/opt/ruby@3.1/bin:$PATH"
export PATH="/usr/local/opt/openssl@3/bin:$PATH"

export PATH="/Users/$USER/Library/Android/sdk/cmdline-tools/latest/bin:$PATH"
export PATH="/Users/$USER/Library/Android/sdk/platform-tools:$PATH"
export PATH="/Users/nqqb/Library/Android/sdk/emulator:$PATH"
export PATH="/Users/nqqb/Library/Android/sdk/build-tools/33.0.1:$PATH"

#export SSL_CERT_DIR=""
#export NODE_EXTRA_CA_CERTS=""
#export REQUESTS_CA_BUNDLE=""
#export NSS_STRICT_NO_CACHE=DISABLED

alias cdd='cd $VIRTUAL_ENV/..'

alias lisp='clisp -q -modern -L french'
