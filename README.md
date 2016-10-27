# pfntuos-dashboard
From [geojson-dashboard](https://github.com/fulcrumapp/geojson-dashboard), a basic traditional use and occupancy site web map viewer. 

## Setup

### App
- clone repo
- add script `dump.sh` to create < 2mb geojson
- add columns, change names in `app.js` and `index.html`
- change symbology in `app.js`
- `serve` and view on `localhost:3000`

### Publishing

From [guide](http://bobbelderbos.com/2012/03/push-code-remote-web-server-git/), see also: [script](https://github.com/bbelderbos/Codesnippets/blob/master/bash/git_create_new_repo.sh)
```
$ ssh hillcrestgeo.ca
$ cd ~/repo && mkdir new_tus_app.git
$ cd new_tus_app.git
$ git init --bare 
$ mkdir /var/www/hillcrestgeo.ca/html/demos/new_tus_app
$ nano hooks/post-receive

    # #!/bin/sh
    # GIT_WORK_TREE=/var/www/hillcrestgeo.ca/html/demos/new_tus_app git checkout -f
$ chmod +x hooks/post-receive
$ exit
$ git remote add hillcrestgeo ssh://snorris@hillcrestgeo.ca/home/user/repo/new_tus_app.git
```

### Password protection
[guide](https://www.digitalocean.com/community/tutorials/how-to-set-up-password-authentication-with-nginx-on-ubuntu-14-04)  
On server:
```
sudo htpasswd -c /etc/nginx/.htpasswd_new_app username
sudo nano /etc/nginx/sites-enabled/hillcrestgeo.ca
```
Add section for new folder to the site config file using previous folders as a reference.
 
Remember to restart the server!!  
```
sudo service nginx restart
```