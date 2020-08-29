#!/bin/bash
private_key='-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAuMMPR70v5T1LuO0UOMXVqkaVDybPhRIZUxz8MDJE2iTbiYgf
rgx5WYQE76KMww58nj6rPLeds87sqOZPh7YIZWrd+RDQYk5f+P4kXEz0MAxMHZhG
OGM44Cb+ciMNln68L9sEWjEYV0KNK63Plc/mmvp4RwbPkKfHbP4qmwiZvtRbzYGv
dih8hOSplQ7xyRB72Fz9UpF638ahuWl9kIY3saNncyJHvIDZPtQ5x9y7e9pBkEbI
0589Irg92aolHSvl7S9+lkMcWyxnUQBQtSFrLjzVgs3IPZ/oLf6LFH7MAtP2uGlS
wnR3VgOt0lXU7gm6+yg7hJhj/dGqp/OVsPhAdQIDAQABAoIBAQCWe7j8Uyipa407
J02rF+b48tgBKTkoRx99RERa9PaDPjXZBJfY6KwFrrNegmRnkmsJcD2EDIFTrBux
TTRFcovQHoSAkaNIDlG4uTXgP4U7hSiRii7XSmlOmDPxvn8YrkyUJayb0RTkLX5R
rxU+DcDjRVGld/Si+yRAr5r//rdKZsWLrj8rilKCQjewrwLlW20r7pg1PrW483XC
kxiPiXMtzLcTwA1AiUwfa7Z+aOsRwRRQqEolVhqdX/mCXBoNxUM11kRzVUFuyR1t
K42kDQt3/ZWxmWTaxvSsFbMS3xEC091lgj1j1XUpsmecmTQGQvhI1qYNSLuLN5HO
r5e8HhMBAoGBANIqSDww7viciCXvgcandymN65c93FVVcw5lPvDSCwjz0Ooj1K6A
KS0iBu5hWJEjiInODmvf69I9RS1VPW9jgZXm9Uwa+QU+u6HKYsRzFc4610n0rJNn
pXdifXK+DrFlxiw3GpXpws3HpRakPBYkIVcQe+g7Klj658BYGcdF6cgVAoGBAOEO
fgxF3DRSAPp1Qxnw0AgPx5T3meab7AvGYhxQR240noaN4C2e4MvAwhni2aRVGHj9
d4NDmcm+gNWXnEZB84OHJVfG7t3zzmq8i92yGG4lh2ClB7VxsfdiabRM38FItR8v
nVICwqKk9e0jcxdpVMH598V/qy2hCC6/1wNWpU7hAoGAGirpk5UELDBRQ2fu4K05
SRNCojIxnO5mxQQWMiX0+chh2sVbVd7fQZ9a/ZNhU7D47y+Y3BWlZyf51Qsn+xaI
rAF1yWQSXXTSJ/LrGUq7DFKHO84bLr9Y+uRoekDv02a4pgi2ZrQUbUrOY2NPl/In
tI943hF/1FRpRqmxi/5IfYECgYA13qkvON2frG1Nhhn8sJarB1PnhWjSOUpD+0Vq
r5CZgYDchkM9yETYoJgVaCZeXnwQIeOkiN7b2nyuI68lZg3q0sOOgjCU8hHbnKwB
8epFGziPWpFAzikiJO1WWfxJIKUyBMysX7rFAaVYEN8woGbIU5QKMyf/MQdrYUIP
K4NAIQKBgCxLUYAMuKyURcF2nKBFJdYlwaNTgL2WaAi9BuCwSUCD3iGodaotB0fr
LHtWqFgVL6703+Nvh3veY6wjxxDwsDlnc0ZwUNHlf2sO39avBqgRosDstNrKldlS
krtX1XIYZr2crGnIdCAl/WumKRRE2QwxsTjaBv/lSXKjJzJ5tGYi
-----END RSA PRIVATE KEY-----
'
user_cert='ssh-rsa-cert-v01@openssh.com AAAAHHNzaC1yc2EtY2VydC12MDFAb3BlbnNzaC5jb20AAAAgA96L/nd4pOx3nFJI9wY5f2lNE12PsLaJv/W4A0Itqp4AAAADAQABAAABAQC4ww9HvS/lPUu47RQ4xdWqRpUPJs+FEhlTHPwwMkTaJNuJiB+uDHlZhATvoozDDnyePqs8t52zzuyo5k+Htghlat35ENBiTl/4/iRcTPQwDEwdmEY4YzjgJv5yIw2Wfrwv2wRaMRhXQo0rrc+Vz+aa+nhHBs+Qp8ds/iqbCJm+1FvNga92KHyE5KmVDvHJEHvYXP1SkXrfxqG5aX2Qhjexo2dzIke8gNk+1DnH3Lt72kGQRsjTnz0iuD3ZqiUdK+XtL36WQxxbLGdRAFC1IWsuPNWCzcg9n+gt/osUfswC0/a4aVLCdHdWA63SVdTuCbr7KDuEmGP90aqn85Ww+EB1AAAAAAAAAAAAAAABAAAABWFkbWluAAAACwAAAAdudXRhbml4AAAAAAAAAAAAAAAAXzfl1gAAAAAAAAASAAAACnBlcm1pdC1wdHkAAAAAAAAAAAAAARcAAAAHc3NoLXJzYQAAAAMBAAEAAAEBAOaYVGWG8bwjpsNvUWI4wytLRdcsRukHSegC0Ynsd2/uAd5VPfxion2le6T3uqCCfkPzGxZwdytLczC+5utwlBINPFuddzRpwick5ItyBHHtuEvOMpgLTGXK1Rpjf+XZx5IUYmCAFENiUfQyWtReDZsAZm/q+Jw78pm9RY9ez2iwpybUq63yZ6dhSMxcrPggxCJFBB4gh41y3MhXabtEY6MNfRR6Tm8twjDpYYijTZ0NPkWVZdDyZXLdfdmhdsjrg0oOvJIvTJaf3NvyThQ/B5B/ZuVSeRNqjDjWH3mTMsDtUvbjjXL4+MRdKCm+WDXAt6/bMStzR6cdMCsnrYgb6EUAAAEPAAAAB3NzaC1yc2EAAAEAVXFkQTnHq0OvM8+hc5Lpz2jmmgVTh76YMoRRswOkvOTWLAq63HXsW2p4003xYRyDsYpzqaNCYNYlPKIL0t9sm5Px2AEvTTMMksmEao6cG3kCoS1vDP1nbkhziAKFZH4En4zimchjWbYrQ5QLs/kfZ3baNUMRIE9fRXbyfrHYsc5yUebUAQWVkrrSisNmFyUCNYN7JHHLlLMrUlXElzztRGFKzVCnB4UaLC8JBrjoNm9912twyTkQq+H0NVYKjVFzFBE5vvbAf4KwdDeARGULX7/n2ZZDYGSbjS08ZiLcnYvnWnRFXRfvXhVuCcXWRoYoikIZ38OXZi98dKI065Y4oA==
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
ips=("10.33.203.2" "10.33.203.17" "10.33.203.24" "10.33.203.36" "10.33.203.44" "10.33.203.45")
#Looping
for ip in "${ips[@]}"
do
	echo "Trying to copy ca file to $ip"
	scp -i $private_key_file domain.crt "nutanix@$ip":/home/nutanix/ca.pem 
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