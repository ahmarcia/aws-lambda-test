role_name = aws-lambda-ex
function_name = $(role_name)-function

init:
	@echo "My first function - AWS Lambda"

create-role:
	aws iam create-role --role-name $(role_name) --assume-role-policy-document file://trust-policy.json

create-package:
	zip function.zip index.js

account-identity:
	aws sts get-caller-identity

create-function: account-identity
	@read -p "Copy and past your number account: " accountId; \
	aws lambda create-function --function-name $(function_name) \
--zip-file fileb://function.zip --handler index.handler --runtime nodejs12.x \
--role arn:aws:iam::$$accountId:role/$(role_name)

update-function: create-package account-identity
	@read -p "Copy and past your number account: " accountId; \
	aws lambda update-function-code --function-name $(function_name) \
--zip-file fileb://function.zip

invoke-function:
	aws lambda invoke --function-name $(function_name) \
--payload '{ "key": "value" }' response.json
	@echo "Response: \n"
	@cat response.json
	@echo "\n"
