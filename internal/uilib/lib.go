package uilib

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

func Name() string {
	return "Hello World!!"
}

func testHttp() string {
	resp, err := http.Get("https://jsonplaceholder.typicode.com/posts")
	if err != nil {
		fmt.Println(err)
	}
	//We Read the response body on the line below.
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln(err)
	}
	//Convert the body to type string
	sb := string(body)
	fmt.Println(sb)
	return sb
}
