# s3demo
 Nutanix S3 demo application

How to use:
Before we can deploy demo application in Nutanix Karbon Kubernetes cluster, we need to containerize it. To do that, first, we need to deploy a Docker Host, where you build docker images, and Docker Registry, where you store your docker images so Nutanix Karbon Kubernetes cluster can access it. To create Docker Host and Registry, we will use Nutanix Calm orchestration tool blueprints, which will automatically deploy both application( https://github.com/vildek/s3demo/tree/master/Nutanix%20Calm%20Blueprints). We will also use Nutanix Calm Runbooks, which allows executing step-by-step remote commands on Linux and Windows endpoints. Using Calm Runbook feature, we can create similar development pipelines like Jenkins automation platform. In our case, we have a Runbook pipeline, which clones application sourcecode from Github repository to Docker Host, builds a Docker image from the source code, tags Docker image, uploads Docker image to Docker Registry and starts the Docker container on the Docker host, so we can test it before deploying in Nutanix Karbon Kubernetes cluster. 

“S3 demo app pipeline” runbook can be found here - https://github.com/vildek/s3demo/tree/master/Nutanix%20Calm%20Runbook

First, let’s create a private Docker Registry (https://docs.docker.com/registry/) by launching “Docker Registry” blueprint from Nutanix Calm self-service portal:

!1(https://media-exp1.licdn.com/dms/image/C4D12AQHjf2aKGzuVpQ/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=sa8XKzjrEYzfgbB3T7yvVrXmYvQWb-wsVzE-X_03eJM)

Provide resource name, necessary parameters for generating self-signed TLS certificate and Docker Registry admin password. Press Create. Nutanix will create a new CentOS virtual machine and deploy a Docker Registry on it.

No alt text provided for this image
While “Docker Registry” is being created, deploy a Docker Host. From Nutanix Calm self-service portal launch “Docker Host” blueprint. Provide resource name and the admin password, we provided in Docker Registry blueprint. Press Create.

No alt text provided for this image
A soon as both applications “DockerHos01” and “DockerRegistry01” in Nutanix Calm application view shows status “Running”, we need to copy “DockerRegistry01” self-signed certificate on to “DockerHost01” server and create a new DNS record in DNS server, for example reg.demobox.lv, otherwise neitherthe Docker Host, nor Nutanix Karbon Kubernetes cluster can communicate with Docker Registry.

Open “DockerHost01” application in Nutanix Calm portal, from there open “Services” tab. Click on the āctive service "Docker_Registry_Open_Source_Service" and on the right side there will be a button “Open Terminal”. Press it. It will create a new SSH session inside the internet browser to Docker Host server using SSH keys. Do the same with “DockerRegistry01” application, open Terminal. 

No alt text provided for this image
To copy “DockerRegistry01 self-signed certificate into clipboard, move to directory “certs” in home directory and list contents of domain.crt file using “cat” tool. Select the certificate output from the file, verify that there is 5 dashes in front and at the end of the certificate. Do not copy any trailing white spaces, because it will make certificate invalid. Once you select the text, let go of mouse left-click button, Nutanix Calm will copy the text into clipboard. You can also copy text to clipboard using "Ctrl+Shift+C".

No alt text provided for this image
Switch browser tab to “DockerHost01” terminal window and there create a new file reg.demobox.lv.crt by using nano tool:

nano reg.demobox.lv.crt

Paste the clipboard into the file using "Ctrl+Shift+V". Then save the file using "Ctrl+X", Enter. Now update Docker Host certificate store and restart the Docker service:

sudo cp reg.demobox.lv.crt /etc/pki/ca-trust/source/anchors/

sudo update-ca-trust

sudo systemctl restart docker

Now we need to create a new endpoint for Nutanix Runbooks. Open Nutanix Calm portal and switch to Endpoints page. Press “Create Endpoint”. Provide endpoint name, IP address and the same CentOS private SSH key you provided in your Nutanix Calm environment. The private key must be in PEM format:

-----BEGIN RSA PRIVATE KEY-----

MIIEogIBAAKCAQ.....

-----END RSA PRIVATE KEY-----

No alt text provided for this image
Before we can configure Runbook, we need to generate new access keys for Nutanix S3 Object storage bucket. Open Nutanix Objects management portal, and switch to “Access Keys” tab. Press Add People, choose “Add people not in a directory service”, input email address and name and press Next. Press “Generate Keys” and then “Download Keys”.

No alt text provided for this image
No alt text provided for this image
No alt text provided for this image
The downloaded file will contain “Access Key” and “Secret Key”. Note them, we will need them later.

No alt text provided for this image
Now open Nutanix Objects Buckets management, for example, Nutanix Objects> s3.demobox.lv>Buckets. Select “s3appbucket” bucket and from Actions drop-down menu choose “Share”. Search for the user we created in previous step and add Read, Write rights to it. Press Save.

No alt text provided for this image
No alt text provided for this image
We can verify if the user has correct rights by installing a freeware tool “S3 Browser” - https://s3browser.com/ and opening the bucket contents.

In S3 Browser tool create a new account, provide REST endpoint URL, in our case it’s s3.demobox.lv and Access/Secret Keys we downloaded from Nutanix Objects management. Press Save, and then press "Buckets> Refresh Buckets list". “s3appbucket” bucket should appear in the left side of the window. Press upload and choose a file to upload. If the file uploads to bucket successfully, user has correct access rights.

No alt text provided for this image
No alt text provided for this image
Go back to Nutanix Calm management, open Runbooks page and open Runbook "S3 Demo App Pipeline". Open Configuration view and press “Add/Edit Variables”. Provide 4 variables - "Access Key", "Secret Key", "Bucket Name" and "Endpoint URL". "Endpoint URL" should be provided in URL format - "http://s3.demobox.lv". Press Done.

No alt text provided for this image
No alt text provided for this image
Runbook "S3 Demo App Pipeline" consists of six steps - deleting previous files if they exist, cloning application source code from Github, building Docker container from the code, tagging and uploading Docker container, starting the container on Docker Host and status output.

Open Runbook "S3 Demo App Pipeline" and press Execute. Leave default parameters on the first run. On next runs, you will have to provide new Docker container tag version. While Runbook is running, you can see server’s terminal output on every step. Once Runbook finishes with status “SUCCESS”, open Runbooks last step’s Output tab. If you see the same output as example below, demo application is successfully containerized.

No alt text provided for this image
Now let’s test our containerized application. Open URL in browser - http://<Docker host IP address>:30000

You should see a webpage “S3 Demo Application”:

No alt text provided for this image
Choose a file and Press Submit. 

No alt text provided for this image
If application shows a message “File uploaded to S3 Storage!” our containerized application is working properly. You can verify if the file is uploaded to Nutanix S3 Storage with S3 Browser tool.

No alt text provided for this image
No alt text provided for this image
Next, we need configure Nutanix Calm blueprint “S3 Application” which will deploy containerized demo application in Nutanix Karbon Kubernetes cluster. First, we need to verify that our containerized application Docker image is uploaded into Docker Registry, then we need to create a Docker Registry admin password secret in Nutanix Karbon Kubernetes cluster and finally we need to copy Docker Registry’s self-signed certificate on Nutanix Karbon worker nodes.

Open Docker registry s3demo application tag list URL in internet browser - "https://reg.demobox.lv:5000/v2/s3demo/tags/list".

It should look like this:

1.0.1 ({"name":"s3demo","tags":["1.0.1"]})

 Then create a new secret in Nutanix Karbon Kubernetes cluster ( docker-email can be random email address).

kubectl create secret docker-registry regpass --docker-server=reg.demobox.lv:5000 --docker-username=admin --docker-password=<parole> --docker-email=kv.admin@demo.lan

Next copy Docker Registry’s self-signed certificate to Nutanix Karbon worker nodes. To speed up the process, we have created a bash script, which will automatically connect to each worker node, copy the certificate, update certificate store and restart the docker process (https://github.com/vildek/s3demo/tree/master/Scripts/upload-ca-cert-karbon.sh).

First download SSH Access token script from Nutanix Karbon management. Then take private_key and user_cert values from SSH Access token script and replace the value in “upload-ca-cert-karbon.sh” script. Also change “ips=(x.x.x.x y.y.y.y z.z.z.z)” variable in the script to your worker nodes IP addresses. Next copy Docker Registry’s self-signed certificate - “domain.crt” to same directory where “upload-ca-cert-karbon.sh” script is located and run the script from bash shell, for example from Linux server or Windows Linux Subsystem. 

No alt text provided for this image
No alt text provided for this image
No alt text provided for this image
If you connect for the first time to Nutanix Karbon worker nodes, you will need to accept RSA key fingerprints.

No alt text provided for this image
Now we are ready to deploy S3 demo application in Nutanix Karbon Kubernetes cluster. In our environment we are using Citrix ADC IPAM controller to issue real LoadBalancer IP addresses for Kubernetes services or ingresses. If your Karbon cluster doesn’t have an IPAM controller, you can change the service type to Nodeport in "S3 Application" Nutanix Calm Blueprint, under Service tab.

To deploy our containerized demo application in Nutanix Karbon cluster, open Nutanix Calm self-service portal and launch “S3 Demo Application” blueprint. Specify Name of application and press Create.

No alt text provided for this image
No alt text provided for this image
Wait till Nutanix Calm shows that "S3 Demo Application" is in Running state, open Services Tab and under Published Service Tab on the right side, click on the App Link URL, to open demo application in internet browser.

No alt text provided for this image
No alt text provided for this image
Double check, if the application is running in correct Nutanix Karbon Kubernetes cluster:

No alt text provided for this image
Now choose a file and press Submit.

No alt text provided for this image
No alt text provided for this image
No alt text provided for this image
File has been successfully uploaded, which means that our containerized application is running in Nutanix Karbon Kubernetes cluster and can communicate with Nutanix S3 object storage without issues.
