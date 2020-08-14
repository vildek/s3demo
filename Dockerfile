FROM node:14
#If you want to test your application in docker image, install text editing tools:
#RUN apt-get update && apt-get install -y nano vim 
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
RUN mkdir -p /home/node/app/uploads && chown -R node:node /home/node/app/uploads

#By default this app uses HTTP access to S3 storage. If you want to use HTTPS,than follow guidelines below. This app works in HTTP and HTTPS.
#If your Nutanix S3 certificate is not properly created(see guideliness in Nutanix portal - https://portal.nutanix.com/page/documents/details?targetId=Objects-v2_2:v22-replace-ssl-certificate-t.html), nodejs will not recognize the certificate chain and you won't be able to connect to your Nutanix S3 Bucket via HTTPS. If you want to use just a simple Let's Encrypt web server certificate, you will need to import certificate chain and export it as environment variable in docker image. Just put your chain file(PEM format) in the same directory as Dockerfile and uncomment these two line and the "ENV NODE_EXTRA_CA_CERTS" line:
#ADD s3.chain.crt /usr/local/share/ca-certificates/s3.chain.crt
#RUN chmod 644 /usr/local/share/ca-certificates/s3.chain.crt && update-ca-certificates
WORKDIR /home/node/app

COPY package*.json ./

USER node

RUN npm install
RUN npm install aws-sdk
RUN npm install fs
RUN npm install multer
RUN npm install multer-s3
RUN npm install body-parser

# Bundle app source
COPY --chown=node:node . .
#ENV NODE_EXTRA_CA_CERTS="/usr/local/share/ca-certificates/s3.chain.crt"
EXPOSE 3000
CMD [ "node", "server.js" ]