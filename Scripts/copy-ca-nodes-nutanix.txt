#!/bin/sh
private_key='-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAxOuZK4nK0Kr6YenUsfDs/4hCsUUBsMegSsEDIYPpa7k4laow
Hv+TDUEHJl6nyFcwsQAT2/uWoHD/b45uUjJchaR3frXDOjgRs3KQ+Q+0pDWLMLjA
+cvvqzBYH1YL1hLNyHoIZTcE1vqU9Nt/OKwR/LXYPiXCpV4VqLwkvDZb/150XYJt
rTsh8G8jG2ug65c1/St08DZDIiWSH/HVFpcdWnxLEL+W6TB/Y44YqkdaZWoiFlnv
c377V0i6+UPpul3AEixFaibQ+ETB771LTvx5uMFvqcOr2QayicdQnqLCemRJNMz2
9je2vkjP6hk8gC//iRnb5CFvCEBLfCU9yPn9XQIDAQABAoIBAQDAfckRbTWLescc
dVXLx0X0l/8Rh/IaG1mOGVR1K5w+CCXO7zjw5EWb3CggEsESLmDTdM70598a4Lph
Eyq2QLJ+lQGWJBk9zNdIwcIDJJ4hMpHoQ4Gn7PlQLwbFQvh4/5KW2Oth/UFG4FZB
cFrRTCqdDCjgv0qhGfI0Kg4CyWRun+6L3x+Pb7c5eYmMKzrENlol++aMjP0Q0KzT
EWS0rbBNmKWC7rKQ8l0v2pQrrhSv5xExZRynB4N+wxnM/udk+YU5t7OJpWiNzeFv
6nu1be8Ybh3xAKz8RJOuhzd82gggpilbfXQeyiduLyJjIglzp3UdrNE4dGqvN9+g
L45fYbKBAoGBAPWDg0h1KTHFJbnrv/iBVv7fL8hMnoDDWMD2VIkK6ejA9/bQpIey
lUmpqPeuoTzcWY2whdOKTVggdE0hRdbfSvanlQXbjcTRSsGy4rcbWP4m0Yr/vVbz
em/CRcPq3Y9V9YeDNZ0YE2D74infcd8Sl4C4kqbNBHAV21Or+jHIOmahAoGBAM1U
wdP5BusZ79GpGZLtKl4LoxA/RwQqlJwcn1LvPjTxM+pzxiUgCnCZbYzqbMIkNYLN
Hh63MMGegFl+0D3AAR6PQk6Ojt9oTngEQPzTuv5S6xOT1xDyofzX/4unrRdyZQ3c
Maw1r8jrsKhPcLt+JM1bUd5JYZiGbzfzJR5VR+k9AoGACp7UyAahcJC5sBA9rq9R
pxbah0yhMqrApSBCyebZ9YKbd2bRJzmXcadQMt6wBOT3TsTLFTqPW/eTcF63GbNx
F7hqHuW/fTscg8KMQiWBtQTS3bNwall/+2OpBu+bA/9Q7rrDT/dhpzleMDeFQoQY
X64cUfDed0bKxRTUbuDdfeECgYB1MFafwJVuQRNaugRakvmHS2T5tOO3QQYoQz27
e8gpNzDGMuV38t2Cfk7EClegRkI0MRVrumodV3UxnusDEz6QTnstkreAUmvWm7br
lXw4AuMf/VTV22UQhcbX0g88PpHmYzIGc22sYrgkl5JjsA8ZFXGYSJFnF/MKH7+j
nFC6kQKBgFgN/0eSXZsW+ki3FtIX1vNvxbFiiA9xd/Qjoo8YZjdGwCvyI6bM4YY+
//5Q2/1fmxP3TLI+2hyCDbNv2bzHhyKZGeRfszOQFyjtWpvBZXhy/ZVOwy5eSGWu
YT495BSpJJEM7YrrPNVZEzaZ6b/hJGSgD9h4/Osvjg4r1mqEy5cF
-----END RSA PRIVATE KEY-----
'
user_cert='ssh-rsa-cert-v01@openssh.com AAAAHHNzaC1yc2EtY2VydC12MDFAb3BlbnNzaC5jb20AAAAg0S5H8i2srpLWfiWjV2hwenzLZgb8PzJBL6i4oWQhFQIAAAADAQABAAABAQDE65kricrQqvph6dSx8Oz/iEKxRQGwx6BKwQMhg+lruTiVqjAe/5MNQQcmXqfIVzCxABPb+5agcP9vjm5SMlyFpHd+tcM6OBGzcpD5D7SkNYswuMD5y++rMFgfVgvWEs3IeghlNwTW+pT02384rBH8tdg+JcKlXhWovCS8Nlv/XnRdgm2tOyHwbyMba6DrlzX9K3TwNkMiJZIf8dUWlx1afEsQv5bpMH9jjhiqR1plaiIWWe9zfvtXSLr5Q+m6XcASLEVqJtD4RMHvvUtO/Hm4wW+pw6vZBrKJx1CeosJ6ZEk0zPb2N7a+SM/qGTyAL/+JGdvkIW8IQEt8JT3I+f1dAAAAAAAAAAAAAAABAAAABWFkbWluAAAACwAAAAdudXRhbml4AAAAAAAAAAAAAAAAXlT1ZwAAAAAAAAASAAAACnBlcm1pdC1wdHkAAAAAAAAAAAAAARcAAAAHc3NoLXJzYQAAAAMBAAEAAAEBAMvWkD8cuUkABcLmMR4Jn0teYDZmjugUscpMPDQ0MZU8hfIf/Y1SAjZxa7Y0ukRPxMOMDS0zYjQj8whJRSFMhL5t+9wVo1fFfR0SlxQNVP/yUG6LB7BvfC/+Um3BKFVujLkcIk2RPwzK6rou49WWrx7VMPbseDg/a8Mz8NiQqmyPpoqZ4jxazgc2LkvjXz+ljk1KpstuINqWIRymGKcFafYAp2FnVE9dl+3oiKpimC5xQGzxPLLzS0BOODEDsXecSxQrEuwX2nR6/Heyyc8VSwUk0PqO3GjiNGs66NU+j+LP17i49CXqp3OdHVwYSGvIQ1MjeF/G3iJB/N5OJG6/iy8AAAEPAAAAB3NzaC1yc2EAAAEAitfqxJCWZYMgM0gBJn83zm3kJc7h2qTnkPZU3b6VslpZcbC9x4dXznJm/312AGcIwxUpOdv8vj67G1XtfMKJb/Uu/6IJHyoVoz8bpL9aPttLoqgsx2fq7U3xid1HIPFHBcVDUghSaZhI3o27UizBULunJUEh/op0w2oXqK8PxuBhfjlLjwdOMLLh20mjqT5QQ7QDitD0z5cNbwpxbj+1It7kKVOl5JbMijogLSL6GOHqx0uATKMRdZKPElIh2fvt/L66nEePAIO10YesP7bZNB2Ab6/UyRhbl3oGP7O0Rj476WYApNx2OplOfP9yKL906fpTxRiPAB+LeYBLqL3z7A==
'
tag=KARBON
cluster_uuid=1454263b-3fd1-44b7-72f8-1c04b3d562b6

save_cert=false

if [ -z "$cluster_uuid" ]; then
    private_key_file=/tmp/${tag}_user
else
    private_key_file=/tmp/${tag}_user_${cluster_uuid}
fi

rm -f $private_key_file
printf "%b" "$private_key" > $private_key_file
chmod 0400 $private_key_file

if [ -z "$cluster_uuid" ]; then
    cert_file=/tmp/${tag}_user-cert.pub
else
    cert_file=/tmp/${tag}_user_${cluster_uuid}-cert.pub
fi

rm -f $cert_file
printf "%b" "$user_cert" > $cert_file
chmod 0400 $cert_file
ips=[]
ips=("10.33.201.163" "10.33.201.169" "10.33.201.113" "10.33.201.141" "10.33.201.131")
#Looping
for ip in "${ips[@]}"
do
	echo "Trying to copy ca file to $ip"
	scp -i $private_key_file ent-ca.pem "nutanix@$ip":/home/nutanix/ca.pem 
	ssh -i $private_key_file "nutanix@$ip" 'sudo cp /home/nutanix/ca.pem /etc/pki/ca-trust/source/anchors/'
	echo "Updating CA cache on $ip"
	ssh -i $private_key_file "nutanix@$ip" 'sudo update-ca-trust'
	echo "Restarting docker service on $ip"
	ssh -i $private_key_file "nutanix@$ip" 'sudo /bin/systemctl restart docker.service'
done
echo "Cleaning up..."
rm -f $private_key_file
rm -f $cert_file
echo "Bye!."