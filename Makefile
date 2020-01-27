role_name = aws-lambda-ex
function_name = $(role_name)-function
layer_name = $(function_name)-layer

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

install-dependencies:
	npm install

copy-dependencies-tmp:
	mkdir nodejs
	cp -r node_modules nodejs

create-layer-package: install-dependencies copy-dependencies-tmp
	zip -r dependencies.zip nodejs
	rm -rf nodejs

create-layer-dependencies:
	aws lambda publish-layer-version --layer-name $(layer_name) \
--description "My layer test" --license-info "MIT" \
--zip-file fileb://dependencies.zip --compatible-runtimes nodejs12.x

configure-layer: account-identity
	@read -p "Copy and past your nunber account: " accountId; \
	read -p "what's the version: " version; \
	aws lambda update-function-configuration --function-name $(function_name) \
--layers arn:aws:lambda:us-east-2:$$accountId:layer:$(layer_name):$$version
