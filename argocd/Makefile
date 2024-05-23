build:
	@echo ">> Building image with version ${VERSION} ..."
	docker build -t vertisan/argocd:${VERSION} .

release: build
	@echo ">> Releasing ArgoCD custom image with version ${VERSION} ..."
	docker push vertisan/argocd:${VERSION}
