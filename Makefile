.PHONY: build serve 

build: 
	trunk build

serve: 
	trunk serve --open

deploy: build 
	-rm -rf tmp
	git clone https://github.com/inqizit-public/yew-template.git tmp
	# -rm tmp/*
	# -cp dist/* tmp
	cd tmp; git checkout gh-pages; rm *; cp ../dist/* .; git add .; git commit -m "deploy"; git push
	-rm -rf tmp
