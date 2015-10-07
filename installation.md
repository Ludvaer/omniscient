#Installation from zero
##Install ruby using rbenv.


main source:  https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-14-04
first instal libraries
```
sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
```

install rbenv
for ubuntu on other system replaceing .bashrc with smthing else may needed this thing called bash profile
```
cd
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

install ruby v sepecified in Gemfile
```
rbenv install -v 2.2.3
rbenv global 2.2.3
```

check installed version
'''
ruby -v
rails -v
'''
If commands does not 

##Install additional software

install very important gem 


```
gem install bundler
```

install rails v sepecified in Gemfile
```
gem install rails -v 4.2.3
```


Seems like I also run some of this commands during installation
Not sure what of it really used in current app, may be nothing yet
I will check next time I break and reinstall my system
```
sudo apt-get install -y software-properties-common python-software-properties
sudo apt-get install nodejs
sudo apt-get install -y bzip2
export PHANTOM_JS="phantomjs-1.9.8-linux-x86_64"
cd /tmp
curl -L https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 | tar xvjf -
sudo mv $PHANTOM_JS /usr/local/share
sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin
```
##Install postgeresql

main source: https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-ruby-on-rails-application-on-ubuntu-14-04
```
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib libpq-dev
```
replace pguser with YOUR username
```
sudo -u postgres createuser -s pguser
sudo -u postgres psql
#enter your password here
\q
```
now go to config/database.yml and fix username: and password: for test and and development CARE ABOUT IT NOT BEING SECRET IF YOU UPLOAD CODE SOMWHERE


##finally

now go to app root directory and bundle all gems needed
```
bundle
```

create databases
```
rake db:create
```

run server
```
rails s
```