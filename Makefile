RELEASE := helm-kibana-security
# NAME_SPACE := app-brilla-dev

install:
	helm upgrade --wait --timeout=$(TIMEOUT) --install --values values.yaml $(RELEASE) ../../

test: secrets install goss

purge:
	kubectl delete secret app-brilla-kibana-secret  -n $(NAME_SPACE) || true

secrets:
	encryptionkey=$$(docker run --rm busybox:1.31.1 /bin/sh -c "< /dev/urandom tr -dc _A-Za-z0-9 | head -c50") && \
	kubectl create secret generic app-brilla-kibana-secret --from-literal=encryptionkey=$$encryptionkey -n $(NAME_SPACE)
