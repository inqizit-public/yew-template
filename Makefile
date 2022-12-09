

CWD := $(shell pwd)

.PHONY:  test dist wasm deploy 

test: 
	echo "not supported"

dist: 
	rm -rf ${CWD}/dist
	go install gioui.org/cmd/gogio@latest
	echo ${CWD}
	gogio -target js ${CWD}/cmd
	mkdir ${CWD}/dist
	mv ${CWD}/cmd/index.html ${CWD}/dist/index.html 
	mv ${CWD}/cmd/main.wasm ${CWD}/dist/main.wasm 
	mv ${CWD}/cmd/wasm.js ${CWD}/dist/wasm.js

wasm: dist
	go install github.com/shurcooL/goexec@latest
	go get github.com/shurcooL/go-goon
	goexec 'http.ListenAndServe(":8080", http.FileServer(http.Dir("dist")))'

deploy: dist
	-rm -rf tmp
	git clone https://github.com/quinelab/quinelab.github.io.git tmp
	-rm tmp/*
	-cp dist/* tmp
	cd tmp; git add .; git commit -m "deploy"; git push
	-rm -rf tmp

run: 
	go run cmd/main.go