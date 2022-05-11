TAG := $$(git log -1 --pretty=format:%h)
ECR_URI := 615496323698.dkr.ecr.ap-northeast-1.amazonaws.com
NAME_SERVER := practice03
NAME_PROXY := practice03-proxy

LOCAL_IMG_COMMIT_SERVER := ${NAME_SERVER}:${TAG}
LOCAL_IMG_COMMIT_PROXY := ${NAME_PROXY}:${TAG}

ECR_ENDPOINT_SERVER := ${ECR_URI}/${NAME_SERVER}
ECR_ENDPOINT_PROXY := ${ECR_URI}/${NAME_PROXY}

ECR_IMG_COMMIT_SERVER := ${ECR_ENDPOINT_SERVER}:${TAG}
ECR_IMG_LATEST_SERVER := ${ECR_ENDPOINT_SERVER}:latest
ECR_IMG_COMMIT_PROXY := ${ECR_ENDPOINT_PROXY}:${TAG}
ECR_IMG_LATEST_PROXY := ${NAME_PROXY}:latest

build:
	@#docker build -f Dockerfile -t ${LOCAL_IMG_COMMIT_SERVER} .
	@docker buildx build --platform=linux/amd64 -f Dockerfile -t ${LOCAL_IMG_COMMIT_SERVER} .
	@docker buildx build --platform=linux/amd64 -f _proxy.Dockerfile -t ${LOCAL_IMG_COMMIT_SERVER} .

	@docker tag ${LOCAL_IMG_COMMIT_SERVER} ${ECR_IMG_COMMIT_SERVER}
	@docker tag ${LOCAL_IMG_COMMIT_SERVER} ${ECR_IMG_LATEST_SERVER}

	@docker tag ${LOCAL_IMG_COMMIT_PROXY} ${ECR_IMG_COMMIT_PROXY}
	@docker tag ${LOCAL_IMG_COMMIT_PROXY} ${ECR_IMG_LATEST_PROXY}

push:
	@aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ${ECR_URI}
	@docker push ${ECR_IMG_COMMIT_SERVER}
	@docker push ${ECR_IMG_LATEST_SERVER}
	@docker push ${ECR_IMG_COMMIT_PROXY}
	@docker push ${ECR_IMG_LATEST_PROXY}