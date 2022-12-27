.PHONY: build serve 

build: 
	cargo build

serve: 
	trunk serve --open

deploy: 
	-rm -rf tmp
	git clone https://github.com/quinelab/quinelab.github.io.git tmp
	-rm tmp/*
	-cp dist/* tmp
	cd tmp; git add .; git commit -m "deploy"; git push
	-rm -rf tmp
