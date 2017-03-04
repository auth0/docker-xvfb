VERSION=6.9.5
docker build . -t auth0brokkr/node-xvfb:$VERSION
docker push auth0brokkr/node-xvfb:$VERSION