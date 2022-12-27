

CWD := $(shell pwd)
DIST := ${CWD}/dist
DIST_JS := ${DIST}/js
DIST_ANDROID := ${DIST}/android
DIST_IOS := ${DIST}/ios
.PHONY:  test dist wasm deploy android ios

test: 
	echo "not supported"

android: 
	rm -rf ${DIST_ANDROID}
	go install gioui.org/cmd/gogio@latest
	gogio -target android ${CWD}/cmd
	# mkdir -p ${DIST_ANDROID}
	# mv ${CWD}/cmd/index.html ${DIST_ANDROID}/index.html 
	# mv ${CWD}/cmd/main.wasm ${DIST_ANDROID}/main.wasm 
	# mv ${CWD}/cmd/wasm.js ${DIST_ANDROID}/wasm.js

ios: 
	rm -rf ${DIST_ANDROID}
	go install gioui.org/cmd/gogio@latest
	gogio -target ios -appid "tmp1234" ${CWD}/cmd
	# mkdir -p ${DIST_ANDROID}
	# mv ${CWD}/cmd/index.html ${DIST_ANDROID}/index.html 
	# mv ${CWD}/cmd/main.wasm ${DIST_ANDROID}/main.wasm 
	# mv ${CWD}/cmd/wasm.js ${DIST_ANDROID}/wasm.js

js: 
	rm -rf ${DIST_JS}
	go install gioui.org/cmd/gogio@latest
	gogio -target js ${CWD}/cmd
	mkdir -p ${DIST_JS}
	mv ${CWD}/cmd/index.html ${DIST_JS}/index.html 
	mv ${CWD}/cmd/main.wasm ${DIST_JS}/main.wasm 
	mv ${CWD}/cmd/wasm.js ${DIST_JS}/wasm.js

dist: 
	rm -rf ${CWD}/dist
	go install gioui.org/cmd/gogio@latest
	echo ${CWD}
	gogio -target js ${CWD}/cmd
	mkdir  ${CWD}/dist
	mv ${CWD}/cmd/index.html ${CWD}/dist/index.html 
	mv ${CWD}/cmd/main.wasm ${CWD}/dist/main.wasm 
	mv ${CWD}/cmd/wasm.js ${CWD}/dist/wasm.js

wasm: js
	go install github.com/shurcooL/goexec@latest
	go get github.com/shurcooL/go-goon
	goexec 'http.ListenAndServe(":8080", http.FileServer(http.Dir("${DIST_JS}")))'

deploy-web: js
	-rm -rf tmp
	git clone https://github.com/quinelab/quinelab.github.io.git tmp
	-rm tmp/*
	-cp ${DIST_JS}/* tmp
	cd tmp; git add .; git commit -m "deploy"; git push
	-rm -rf tmp

run: 
	go run cmd/main.go