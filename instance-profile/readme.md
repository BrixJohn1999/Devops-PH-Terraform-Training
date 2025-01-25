# CREATE

`docker run --rm -it -p 4566:4566 -p 4571:4571 localstack/localstack`

`aws --endpoint-url=http://localhost:4566 s3api create-bucket --bucket my-bucket --region us-east-1`

`aws --endpoint-url=http://localhost:4566 s3api list-buckets`

`aws --endpoint-url=http://localhost:4566 iam create-role --role-name MyExampleRole --assume-role-policy-document file://trust-policy.json`
