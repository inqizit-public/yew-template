

CWD := $(shell pwd)
test: 
	echo "not supported"
dist: 
	go install gioui.org/cmd/gogio@latest
	echo ${CWD}
	gogio -target js ${CWD}/cmd dist

wasm: 
	go install github.com/shurcooL/goexec@latest
	goexec 'http.ListenAndServe(":8080", http.FileServer(http.Dir("cmd")))'
run: 
	go run cmd/main.go