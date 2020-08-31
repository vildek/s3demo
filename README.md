# Nutanix S3 demo application
![logo](https://media-exp1.licdn.com/dms/image/C4D12AQFat28Q6ojuUg/article-cover_image-shrink_720_1280/0?e=1604534400&v=beta&t=VVEsXZYh92RsOKn6ncqDYS8aSjGrHHslfulhKa1QzZc)

How to use:
Before we can deploy demo application in Nutanix Karbon Kubernetes cluster, we need to containerize it. To do that, first, we need to deploy a Docker Host, where you build docker images, and Docker Registry, where you store your docker images so Nutanix Karbon Kubernetes cluster can access it. To create Docker Host and Registry, we will use Nutanix Calm orchestration tool blueprints, which will automatically deploy both application( https://github.com/vildek/s3demo/tree/master/Nutanix%20Calm%20Blueprints). We will also use Nutanix Calm Runbooks, which allows executing step-by-step remote commands on Linux and Windows endpoints. Using Calm Runbook feature, we can create similar development pipelines like Jenkins automation platform. In our case, we have a Runbook pipeline, which clones application sourcecode from Github repository to Docker Host, builds a Docker image from the source code, tags Docker image, uploads Docker image to Docker Registry and starts the Docker container on the Docker host, so we can test it before deploying in Nutanix Karbon Kubernetes cluster. 

“S3 demo app pipeline” runbook can be found here - https://github.com/vildek/s3demo/tree/master/Nutanix%20Calm%20Runbook

First, let’s create a private Docker Registry (https://docs.docker.com/registry/) by launching “Docker Registry” blueprint from Nutanix Calm self-service portal:

![1](https://media-exp1.licdn.com/dms/image/C4D12AQHjf2aKGzuVpQ/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=sa8XKzjrEYzfgbB3T7yvVrXmYvQWb-wsVzE-X_03eJM)

Provide resource name, necessary parameters for generating self-signed TLS certificate and Docker Registry admin password. Press Create. Nutanix will create a new CentOS virtual machine and deploy a Docker Registry on it.

![2](https://media-exp1.licdn.com/dms/image/C4D12AQFhw1zaTYlkBw/article-inline_image-shrink_1000_1488/0?e=1604534400&v=beta&t=1CX2lCOWgrm13LeI06GBsjpfkEcW_hqSgdVwx-OVgzM)
While “Docker Registry” is being created, deploy a Docker Host. From Nutanix Calm self-service portal launch “Docker Host” blueprint. Provide resource name and the admin password, we provided in Docker Registry blueprint. Press Create.

![3](https://media-exp1.licdn.com/dms/image/C4D12AQG3E0L1XxCRyg/article-inline_image-shrink_1000_1488/0?e=1604534400&v=beta&t=eutqPp4_J9nmqsRSoh0EotSgnzRH9zQ-1ggjkXxC3Lo)
A soon as both applications “DockerHos01” and “DockerRegistry01” in Nutanix Calm application view shows status “Running”, we need to copy “DockerRegistry01” self-signed certificate on to “DockerHost01” server and create a new DNS record in DNS server, for example reg.demobox.lv, otherwise neitherthe Docker Host, nor Nutanix Karbon Kubernetes cluster can communicate with Docker Registry.

Open “DockerHost01” application in Nutanix Calm portal, from there open “Services” tab. Click on the āctive service "Docker_Registry_Open_Source_Service" and on the right side there will be a button “Open Terminal”. Press it. It will create a new SSH session inside the internet browser to Docker Host server using SSH keys. Do the same with “DockerRegistry01” application, open Terminal. 

![4](https://media-exp1.licdn.com/dms/image/C4D12AQFz0HcJpIDwfA/article-inline_image-shrink_1000_1488/0?e=1604534400&v=beta&t=ZcxZXabqxGpLAS7Pj8pzy0aB_XGMvuYpjaWuCWL_zv8)
To copy “DockerRegistry01 self-signed certificate into clipboard, move to directory “certs” in home directory and list contents of domain.crt file using “cat” tool. Select the certificate output from the file, verify that there is 5 dashes in front and at the end of the certificate. Do not copy any trailing white spaces, because it will make certificate invalid. Once you select the text, let go of mouse left-click button, Nutanix Calm will copy the text into clipboard. You can also copy text to clipboard using "Ctrl+Shift+C".

![5](https://media-exp1.licdn.com/dms/image/C4D12AQErJszEKQRpzA/article-inline_image-shrink_1000_1488/0?e=1604534400&v=beta&t=ywSiVIVUzBx4h8ZxKjVDeKsY28Ax19aqiR9-PpCXJwE)
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

![6](https://media-exp1.licdn.com/dms/image/C4D12AQGgerNu7F44CA/article-inline_image-shrink_1000_1488/0?e=1604534400&v=beta&t=XnI4mlh-02tLr6HROvokhXiHRcvSMVtXl_tOsXGM57s)
Before we can configure Runbook, we need to generate new access keys for Nutanix S3 Object storage bucket. Open Nutanix Objects management portal, and switch to “Access Keys” tab. Press Add People, choose “Add people not in a directory service”, input email address and name and press Next. Press “Generate Keys” and then “Download Keys”.

![7](https://media-exp1.licdn.com/dms/image/C4D12AQHTYhwn5UiL6g/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=zw75ecBIjLxA0VKylkrMxjAjn1ABcz4f8cwyWYzc_IQ)
![8](https://media-exp1.licdn.com/dms/image/C4D12AQG0GGXwwt73Sw/article-inline_image-shrink_1000_1488/0?e=1604534400&v=beta&t=ZQkIVjlfPWFQWOjFax1QdKnbsaXKdwd-lvF0WzaMcSk)
![9](https://media-exp1.licdn.com/dms/image/C4D12AQExIVgnBORBQQ/article-inline_image-shrink_1000_1488/0?e=1604534400&v=beta&t=H5azquNEtEkMSpkGkTGn0l0IXkq7uuectrFYEd7WqTs)
The downloaded file will contain “Access Key” and “Secret Key”. Note them, we will need them later.
![10](https://media-exp1.licdn.com/dms/image/C4D12AQHn42BBivYnbg/article-inline_image-shrink_1000_1488/0?e=1604534400&v=beta&t=kqbwP1IUJ6F58syGUT4RuGIEjmjov853ZJoiacBOuZo)
Now open Nutanix Objects Buckets management, for example, Nutanix Objects> s3.demobox.lv>Buckets. Select “s3appbucket” bucket and from Actions drop-down menu choose “Share”.
Search for the user we created in previous step and add Read, Write rights to it. Press Save.

![11](https://media-exp1.licdn.com/dms/image/C4D12AQGoadX6m4rpiA/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=vsTgGBByGhv7ueLd6OQyB4rylWrr9dfg7T3H6S10Y34)
![12](https://media-exp1.licdn.com/dms/image/C4D12AQFLVNM3mS6_sA/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=GYH88cW4bOn6vipchEN-ELODuX31kVq3rCJlZUsQTHc)
We can verify if the user has correct rights by installing a freeware tool “S3 Browser” - https://s3browser.com/ and opening the bucket contents.

In S3 Browser tool create a new account, provide REST endpoint URL, in our case it’s s3.demobox.lv and Access/Secret Keys we downloaded from Nutanix Objects management. Press Save, and then press "Buckets> Refresh Buckets list". “s3appbucket” bucket should appear in the left side of the window. Press upload and choose a file to upload. If the file uploads to bucket successfully, user has correct access rights.

![13](https://media-exp1.licdn.com/dms/image/C4D12AQHhe5eJO3a0yQ/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=9z8C4RQvhgSPbRX36QjgZDS9CrRz--I5z9jMruu_2Ls)
![14](https://media-exp1.licdn.com/dms/image/C4D12AQGBrIS0LaMiXA/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=Uy5GWc1KifnFP4L_gipaAyz_ne_Q-wqOue6_x_CYMws)
Go back to Nutanix Calm management, open Runbooks page and open Runbook "S3 Demo App Pipeline". Open Configuration view and press “Add/Edit Variables”. Provide 4 variables - "Access Key", "Secret Key", "Bucket Name" and "Endpoint URL". "Endpoint URL" should be provided in URL format - "http://s3.demobox.lv". Press Done.

![15](https://media-exp1.licdn.com/dms/image/C4D12AQGUesCmFFrfzA/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=mv_X-r0wCEfLW4ldVl9M8MR23Vw5K4qnO0BDkGH-j_U)
![16](https://media-exp1.licdn.com/dms/image/C4D12AQGG_NRB5CQJxA/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=FHdtCrxCx72dTeF9CXazT-4CAHjDh3fXkD8aolNXi4I)
Runbook "S3 Demo App Pipeline" consists of six steps - deleting previous files if they exist, cloning application source code from Github, building Docker container from the code, tagging and uploading Docker container, starting the container on Docker Host and status output.

Open Runbook "S3 Demo App Pipeline" and press Execute. Leave default parameters on the first run. On next runs, you will have to provide new Docker container tag version. While Runbook is running, you can see server’s terminal output on every step. Once Runbook finishes with status “SUCCESS”, open Runbooks last step’s Output tab. If you see the same output as example below, demo application is successfully containerized.

![17](https://media-exp1.licdn.com/dms/image/C4D12AQGE_xcyKL4l7w/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=plKKWGF0xCA0VFB5FssC5LzTFucsG6LPh7ZnmxQ_iSU)
Now let’s test our containerized application. Open URL in browser - http://<Docker host IP address>:30000

You should see a webpage “S3 Demo Application”:
![18](https://media-exp1.licdn.com/dms/image/C4D12AQEmET_yznQohg/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=tD3HGZLVtCE1_xvdD_szakBSckTmVa86jiDRYfhudyw)
Choose a file and Press Submit. 

![19](https://media-exp1.licdn.com/dms/image/C4D12AQHzZY_5nhsayw/article-inline_image-shrink_1000_1488/0?e=1604534400&v=beta&t=ua9wdvr1tFgbuu5pbuGr3QsF6Bw6z23yBzd9FPKIPNc)
If application shows a message “File uploaded to S3 Storage!” our containerized application is working properly. You can verify if the file is uploaded to Nutanix S3 Storage with S3 Browser tool.

![20](https://media-exp1.licdn.com/dms/image/C4D12AQEjYzMbnTo7WQ/article-inline_image-shrink_1000_1488/0?e=1604534400&v=beta&t=nBcQq844IZ5zsGcy5NA2KPKOjAm-PRyxg-4LoJjCbS0)
![21](https://media-exp1.licdn.com/dms/image/C4D12AQGXGcNt0Q1-OQ/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=R7oP7jgVqD0efZWQjGNfeG4Xl3hV0bihRd9cv4HhdqU)
Next, we need configure Nutanix Calm blueprint “S3 Application” which will deploy containerized demo application in Nutanix Karbon Kubernetes cluster. First, we need to verify that our containerized application Docker image is uploaded into Docker Registry, then we need to create a Docker Registry admin password secret in Nutanix Karbon Kubernetes cluster and finally we need to copy Docker Registry’s self-signed certificate on Nutanix Karbon worker nodes.

Open Docker registry s3demo application tag list URL in internet browser - "https://reg.demobox.lv:5000/v2/s3demo/tags/list".

It should look like this:

1.0.1 ({"name":"s3demo","tags":["1.0.1"]})

 Then create a new secret in Nutanix Karbon Kubernetes cluster ( docker-email can be random email address).

kubectl create secret docker-registry regpass --docker-server=reg.demobox.lv:5000 --docker-username=admin --docker-password=<parole> --docker-email=kv.admin@demo.lan

Next copy Docker Registry’s self-signed certificate to Nutanix Karbon worker nodes. To speed up the process, we have created a bash script, which will automatically connect to each worker node, copy the certificate, update certificate store and restart the docker process (https://github.com/vildek/s3demo/tree/master/Scripts/upload-ca-cert-karbon.sh).

First download SSH Access token script from Nutanix Karbon management. Then take private_key and user_cert values from SSH Access token script and replace the value in “upload-ca-cert-karbon.sh” script. Also change “ips=(x.x.x.x y.y.y.y z.z.z.z)” variable in the script to your worker nodes IP addresses. Next copy Docker Registry’s self-signed certificate - “domain.crt” to same directory where “upload-ca-cert-karbon.sh” script is located and run the script from bash shell, for example from Linux server or Windows Linux Subsystem. 

![22](https://media-exp1.licdn.com/dms/image/C4D12AQH4NVqXbl7pXg/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=m6A8e0oO71oLprM8L7LGN7wUK1b5a4gyFmtFQTaV7jY)
![23](https://media-exp1.licdn.com/dms/image/C4D12AQFOaUFZilmjVA/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=zbP1-JM0Y-NITXA--TE9Ult8u1whBZWRm1RAYxJHZgA)
![24](https://media-exp1.licdn.com/dms/image/C4D12AQGTiunTs7MxNQ/article-inline_image-shrink_1000_1488/0?e=1604534400&v=beta&t=twHblGUc7ZitNC5tgqRom57xsnqR4P3nl79XdUs24_s)
If you connect for the first time to Nutanix Karbon worker nodes, you will need to accept RSA key fingerprints.

![25](https://media-exp1.licdn.com/dms/image/C4D12AQHNNvk4RUtTzg/article-inline_image-shrink_1000_1488/0?e=1604534400&v=beta&t=bj8EEOhheaptYBGCRFLVOmrHUdaztjZK9X8Jp1Jh9JY)
Now we are ready to deploy S3 demo application in Nutanix Karbon Kubernetes cluster. In our environment we are using Citrix ADC IPAM controller to issue real LoadBalancer IP addresses for Kubernetes services or ingresses. If your Karbon cluster doesn’t have an IPAM controller, you can change the service type to Nodeport in "S3 Application" Nutanix Calm Blueprint, under Service tab.

To deploy our containerized demo application in Nutanix Karbon cluster, open Nutanix Calm self-service portal and launch “S3 Demo Application” blueprint. Specify Name of application and press Create.

![26](https://media-exp1.licdn.com/dms/image/C4D12AQEPGyV6vaa-CA/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=cTjSP_TPOLdR8edWHPNaCu7WEY0acIvgbpoXvPmY7dQ)
![27](https://media-exp1.licdn.com/dms/image/C4D12AQGv642Ub8I3WA/article-inline_image-shrink_1000_1488/0?e=1604534400&v=beta&t=mh-7oWmlzViEump9ClQJ9uhO_QLjb8tJQQ2yk4U0jNY)
Wait till Nutanix Calm shows that "S3 Demo Application" is in Running state, open Services Tab and under Published Service Tab on the right side, click on the App Link URL, to open demo application in internet browser.

![28](https://media-exp1.licdn.com/dms/image/C4D12AQGiUeIY5MGEag/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=me0h5eAcgQwLYUzzH8b_-gKyUEAPsD2tImjFheK5gb0)
![29](https://media-exp1.licdn.com/dms/image/C4D12AQF_izIcm1L57g/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=H32Fidui13AptmfDblyEMxXGzahYX8FTH0MvJhDdvK8)
Double check, if the application is running in correct Nutanix Karbon Kubernetes cluster:

![30](https://media-exp1.licdn.com/dms/image/C4D12AQHKCf1As2uwxQ/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=w1LUy3L02klTFX1-gbcAgA7Gl8wnT4x3usNh1Hc-qQc)
Now choose a file and press Submit.

![31](https://media-exp1.licdn.com/dms/image/C4D12AQFALr2u5yn_VA/article-inline_image-shrink_1000_1488/0?e=1604534400&v=beta&t=csoMT8g3SfgXKazqcVK0qK9DmUs8BuSSLhAr20al7CA)
![32](https://media-exp1.licdn.com/dms/image/C4D12AQHzY-hkhpXGOg/article-inline_image-shrink_1000_1488/0?e=1604534400&v=beta&t=EAIv5APefAqt4nVJr9L98-i1x15qJyfOCBD6UXLhRSk)
![33](https://media-exp1.licdn.com/dms/image/C4D12AQGhc4u8WzHQOA/article-inline_image-shrink_1500_2232/0?e=1604534400&v=beta&t=PI-Sk_mN5pfsaNFOJNet9Q59EZ9toEXv8lmNt4FDtJY)
File has been successfully uploaded, which means that our containerized application is running in Nutanix Karbon Kubernetes cluster and can communicate with Nutanix S3 object storage without issues.
