# Automatically deploy docker on GCP

## propare project

### Fork the “hemakshis/Basic-MERN-Stack-App” to our own repository and clone it to local and rename `mern`

### Clone the project to the local
```shell script
git clone https://github.com/loveagri/mern.git
```  

### Install proper nodejs(8.12.0)

1. go to [nvm](https://github.com/nvm-sh/nvm)
2. choose the right way to install nvm according to you OS
3. open a new terminal and do follow
    ```shell script
    nvm install 8.12.0
    ```

### Install and configure project   
1. Run (from the project root) yarn install and cd client && yarn install
    ```shell script
    yarn install
    cd client && yarn install
    ```
2. Configure the config.js, this step is depend on your mangodb server and jwt key, all this should be in env form
    ```js
    // const JWTSECRET = process.env.JWTSECRET;
    // const MONGODB_URI = process.env.MONGODB_URI;
    //
    // module.exports = {
    //     jwtSecret: JWTSECRET,
    //     mongodburi: MONGODB_URI
    // };
    
    
    const JWTSECRET = process.env.JWTSECRET;
    const DB_USERNAME = process.env.DB_USERNAME;
    const DB_PASSWORD = process.env.DB_PASSWORD;
    const DB_NAME = process.env.DB_NAME;
    
    module.exports = {
        jwtSecret: JWTSECRET,
        mongodburi: 'mongodb+srv://' + DB_USERNAME + ':' + DB_PASSWORD + '@cluster0.sgccc.gcp.mongodb.net/' + DB_NAME + '?retryWrites=true&w=majority'
    };
    ``` 

### now, project done
___

## Local OS configure
### Linux-Configure SSH non-secret communication-Basic usage of "ssh-keygen"
1. Generate rsa key in the specified directory if you don't have
    ```shell script
    ssh-keygen  -t rsa  -C "loveagri"
    ```
   ```shell script
    # love @ love-Mac in ~ [16:29:17] 
    $ ll .ssh   
    total 40
    drwx------   7 love  staff   224B Aug  3 23:46 .
    drwxr-xr-x+ 71 love  staff   2.2K Aug  4 15:37 ..
    -rw-------   1 love  staff   1.8K May 30 12:36 id_rsa
    -rw-r--r--   1 love  staff   412B May 30 12:36 id_rsa.pub
    -rw-r--r--   1 love  staff   1.2K Aug  4 10:07 known_hosts
    -rw-------   1 love  staff   2.5K Jun 27 23:13 loveagri
    -rw-r--r--   1 love  staff   562B Jun 27 23:13 loveagri.pub
    ```
2. Copy id_rsa.pub content to GCP server ~/.ssh/authorized_keys (append not replace), if authorized_keys not exist, pls create.
    ```shell script
    # For ordinary users, it is recommended to set the permissions to 600: 
    chmod 600 authorized_keys id_rsa id_rsa.pub
    
    # For root users, it is recommended to set 644 permissions: 
    chmod 644 authorized_keys id_rsa id_rsa.pub
   ```
   ```
   [root@localhost .ssh]# cat authorized_keys 
   ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2JpLMqgeg9jB9ZztOCw0WMS8hdVpFxthqG1vOQTOji/cp0+8RUZl3P6NtzqfHbs0iTcY0ypIJGgx4eXyipfLvilV2bSxRINCVV73VnydVYl5gLHsrgOx+372Wovlanq7Mxq06qAONjuRD0c64xqdJFKb1OvS/nyKaOr9D8yq/FxfwKqK7TzJM0cVBAG7+YR8lc9tJTCypmNXNngiSlipzjBcnfT+5VtcFSENfuJd60dmZDzrQTxGFSS2J34CuczTQSsItmYF3DyhqmrXL+cJ2vjZWVZRU6IY7BpqJFWwfYY9m8KaL0PZ+JJuaU7ESVBXf6HJcQhYPp2bTUyff+vdV shoufeng
    ```
    congratulations, now, you can login server without password
    
3. Copy ir_rsa.pub to set git SSH key
    ![git](https://i.niupic.com/images/2020/08/04/8uvL.png)
    
    now, you can push code without password
    
### Build docker related file.  
1. Build `.dockerignore` file
   ```shell script
    .git
    .gitignore
    node_modules
    npm-debug.log
    Dockerfile*
    docker-compose*
    README.md
    LICENSE
    .vscode
    .idea
    .env
    client
    !client/build/
    .dockepwd
    deploy.sh
    update.sh
    ```
2. build `Dockerfile` file
    ```shell script
    # Filename: Dockerfile 
    FROM node:8.12.0
    WORKDIR /mid-term-project/mern/
    COPY . .
    RUN yarn install
    EXPOSE 5000
    CMD ["yarn", "server"]
    ```

### Build automated build release script `deploy.sh` and set docker access token
1. deploy.sh, don't forget to set you server user and ip or domain, your docker hub name, app name and 
    ```shell script
    #!/bin/bash
        
        HUB="hub username"
        APP="project name"
        
        if [[ $1 = '' ]];
        then
          VERSION="latest"
        else
          VERSION=$1
        fi
        
        #join full app name
        FULL_IMAGE_NAME="$HUB/$APP:$VERSION"
        echo "---------------full name: $FULL_IMAGE_NAME---------------"
        
        #recover unsubmit code
        git checkout .
        echo '---------------finish checkout---------------'
        
        #pull from remote repository
        git pull
        echo '---------------finish pull from remote repository---------------'
        
        #install modules and package code of client
        yarn install
        yarn heroku-postbuild
        echo "---------------finish install js libraries and build project---------------"
        
        docker build -t $FULL_IMAGE_NAME .
        echo "---------------finish build docker image---------------"
        
        docker logout
        echo "---------------logout docker successfully---------------"
        
        cat .dockepwd | docker login --username g6219700 --password-stdin
        echo "---------------login docker successfully---------------"
        
        docker push $FULL_IMAGE_NAME
        echo "---------------push to docker hub successfully---------------"
        
        ssh user@server.ip  /bin/bash /home/fuhong_tang_china/update.sh "$HUB/$APP" $VERSION
        echo "---------------login to remote server successfully---------------"
    ```
2. set docker hub Access Tokens, go to [https://hub.docker.com/settings/security](https://hub.docker.com/settings/security)
    ![hub](https://i.niupic.com/images/2020/08/04/8uwc.png)
    at last, create a '.dockerpwd' at the same document with deploy.sh file to store the docker hub Access Tokens, then shell command can read this file content
#### now, all local config done.
___
## Deployment server
### Create GCP server and open a ssh terminal
1. Update apt libraries
    ```shell script
    apt update && apt upgrade
    ```
2. Install docker
    ```shell script
    wget -qO- https://get.docker.com | sh
    
    # after install docker 
    sudo usermod -aG docker $USER 
    ```
3. Install nginx
    ```shell script
    sudo apt install -y nginx
    ```
4. Set nginx configs, then we can user reverse proxy to hide our backend server, another reason is that we can hot update our project without shutdown server.
    ```shell script
    sudo vim /etc/nginx/conf.d/server.conf
    ```
   server.conf
   ```shell script
    upstream server_side{
            server 127.0.0.1:5001;
            server 127.0.0.1:5002;
            server 127.0.0.1:5999 backup;
    }
    
    server {
           # If there is a fixed IP or have a domain map
           # listen       80;
           # server_name  127.0.0.1;
    
           # default server can response any request
           listen 80 default_server;
           listen [::]:80 default_server;
   
           location / {
                    proxy_pass http://server_side;
                    proxy_set_header Host $host;
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           }
    }
    ```
   if you set default server, you need edit /etc/nginx/nginx.conf, otherwise don't need
   ```shell script
    # comment this line
    #       include /etc/nginx/sites-enabled/*;
    ```
5. Check nginx configs and start nginx
    ```shell script
    sudo nginx -t
    sudo nginx
    ```

6. Create update.sh at home directory
    ```shell script
    #!/bin/bash
    
    echo "---------------successfully login to $USER---------------"
    
    LAST_IMAGE=`cat /home/fuhong_tang_china/.lastImage.txt`
    echo "read last version image info successfully"
    
    HUB_APP=$1
    VERSION=$2
    FULL_IMAGE_NAME="$HUB_APP:$VERSION"
    
    echo "====last image version info: $LAST_IMAGE===="
    echo "====new image version info: $FULL_IMAGE_NAME===="
    
    if [[ $1 = '' ]];
    then
      echo "---------------need a full version info---------------"
      exit
    fi
    
    if [[ $FULL_IMAGE_NAME = $LAST_IMAGE ]];
    then
      echo "---------------last version is same with new new version, don't update---------------"
      exit
    fi
    
    docker pull $FULL_IMAGE_NAME
    echo '---------------image pull finished---------------'
    
    ImageId=`docker images | grep -E $HUB_APP | grep -E $VERSION | awk '{print $3}'`
    echo "image id: $ImageId"
    
    docker rm -f backup
    echo "---------------old server backup removed---------------"
    
    docker run -d --name backup -p 5999:5000  -e JWTSECRET=`yourjwtscript` -e DB_USERNAME=`dbusernmae` -e DB_PASSWORD=`dbpassword` -e DB_NAME=`dbname` $ImageId
    echo "backup server started"
    
    seconds_left=10
    echo "please wait for ${seconds_left}s, to ensure that the backup server starts successfully"
    while [ $seconds_left -gt 0 ];do
        echo -n $seconds_left
        sleep 1
        seconds_left=$(($seconds_left - 1))
        echo -ne "\r     \r" #clear digital
    done
    
    echo '---------------counter down 10s, server mern1, mern2 start to remove---------------'
    
    docker rm -f mern1
    echo "---------------server mern1 removed---------------"
    
    docker rm -f mern2
    echo "---------------server mern2 removed---------------"
    
    docker run -d --name mern1 -p 5001:5000 -e JWTSECRET=`yourjwtscript` -e DB_USERNAME=`dbusernmae` -e DB_PASSWORD=`dbpassword` -e DB_NAME=`dbname` $ImageId
    echo "---------------server mern1 started---------------"
    
    docker run -d --name mern2 -p 5002:5000 -e JWTSECRET=`yourjwtscript` -e DB_USERNAME=`dbusernmae` -e DB_PASSWORD=`dbpassword` -e DB_NAME=`dbname` $ImageId
    echo "---------------server mern2 started---------------"
    
    docker rmi $LAST_IMAGE
    echo "---------------old image removed---------------"
    
    echo $FULL_IMAGE_NAME > /home/fuhong_tang_china/.lastImage.txt
    echo "---------------new image info written successfully---------------"
    
    echo "---------------deploy finished---------------"
    echo "---------------new version is $FULL_IMAGE_NAME---------------"
    ```

7. Pull the first version image from docker hub at first time
    ```shell script
    docker pull username/project:version0
    # run three containers, map ip 5xxx:5000
    docker run -d --name backup -p 5999:5000  -e JWTSECRET=`yourjwtscript` -e DB_USERNAME=`dbusernmae` -e DB_PASSWORD=`dbpassword` -e DB_NAME=`dbname` `version0ImageId`
    docker run -d --name mern1 -p 5001:5000 -e JWTSECRET=`yourjwtscript` -e DB_USERNAME=`dbusernmae` -e DB_PASSWORD=`dbpassword` -e DB_NAME=`dbname` `version0ImageId`
    docker run -d --name mern2 -p 5002:5000 -e JWTSECRET=`yourjwtscript` -e DB_USERNAME=`dbusernmae` -e DB_PASSWORD=`dbpassword` -e DB_NAME=`dbname` `version0ImageId`
    ``` 
    
    Creating a file named `.lastImage.txt` to store the last image information at the same document with update.sh, at first time, you should write the first version image information to `.lastImage.txt` like 'hubusername/project:version0'
    
#### now, docker config finished
___

## Last step, go to the root of your project and run
```shell script
   bash deploy.sh `your version0` # bash deploy.sh g6219700/mern:v1
```
Check your website and server to confirm whether it is deployed successfully.

Visit our project, please go to [http://34.72.111.143/](http://34.72.111.143/)