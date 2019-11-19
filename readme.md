java test task for digital lab


instruction:
	modify input file "test_input" to test
	build docker container with following command:

```
sudo docker build -t java_test .

sudo docker run java_test

```

output will be displayed in the console

to upload to eks using terraform:

set your aws credentials in ~/.aws/credentials
set your aws config in ~/.aws/config

~ you have to create keypair in aws to set it in the next commands ~

run the following commands:

cd terraform/
terraform init
terraform apply

copy config from apply output to ~/.kube/config and run:

kubectl run test --image=java_test
