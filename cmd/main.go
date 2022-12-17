package main

import "quinelab/web/internal/app"

func main() {
	webApp := app.NewApp()
	webApp.Start()
}
