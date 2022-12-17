package main

import "quinelab/web/internal/app"

func main() {
	webApp := app.NewApp("Timer", 400, 600)
	webApp.Start()
}
