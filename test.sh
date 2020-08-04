$ImageId=''
docker run -d --name backup -p 5999:5000  -e JWTSECRET=secret -e DB_USERNAME=todo -e DB_PASSWORD=adming -e DB_NAME=todoDB $ImageId
docker run -d --name mern1 -p 5001:5000 -e JWTSECRET=secret -e DB_USERNAME=todo -e DB_PASSWORD=adming -e DB_NAME=todoDB $ImageId
docker run -d --name mern2 -p 5002:5000 -e JWTSECRET=secret -e DB_USERNAME=todo -e DB_PASSWORD=adming -e DB_NAME=todoDB $ImageId