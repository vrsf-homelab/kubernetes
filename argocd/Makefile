build:
	@echo ">> Building image with version ${VERSION} ..."
	@docker build -t vertisan/argocd:${VERSION} .

release: build
	@echo ">> Releasing ArgoCD custom image with version ${VERSION} ..."
	@docker push vertisan/argocd:${VERSION}
	@echo ">> Saving version ..."
	@echo ${VERSION} > VERSION

update-values: release
	@echo ">> Updating image version in Kustomize values ..."
	@sed -i '' "s/tag: .*/tag: $$VERSION/" ../manifests/argocd/argocd/values.yaml
