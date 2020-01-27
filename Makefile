role_name = aws-lambda-ex

init:
	@echo "My first function - AWS Lambda"

create-role:
	aws iam create-role --role-name $(role_name) --assume-role-policy-document file://trust-policy.json
