package app

import (
	"log"
	"os"
	"time"

	gioApp "gioui.org/app"
	"gioui.org/font/gofont"
	"gioui.org/io/system"
	"gioui.org/layout"
	"gioui.org/op"
	"gioui.org/unit"
	"gioui.org/widget"
	"gioui.org/widget/material"
)

type C = layout.Context
type D = layout.Dimensions

var progress float32

// is the egg boiling?
var boiling bool

// Define the progress variables, a channel and a variable
var progressIncrementer chan float32

type app struct {
	height float32
	width  float32
	window *gioApp.Window
}

func NewApp(title string, width, height float32) *app {
	// create new window
	window := gioApp.NewWindow(
		gioApp.Title(title),
		gioApp.Size(unit.Dp(width), unit.Dp(height)),
	)
	return &app{
		height: height,
		width:  width,
		window: window,
	}
}

func (a *app) Start() {
	// Setup a separate channel to provide ticks to increment progress
	progressIncrementer = make(chan float32)
	go func() {
		for {
			time.Sleep(time.Second / 25)
			progressIncrementer <- 0.004
		}
	}()
	go func() {
		if err := a.draw(); err != nil {
			log.Fatal(err)
		}
		os.Exit(0)
	}()
	gioApp.Main()
}

func (a *app) draw() error {
	// ops are the operations from the UI
	var ops op.Ops

	// startButton is a clickable widget
	var startButton widget.Clickable

	// th defines the material design style
	th := material.NewTheme(gofont.Collection())

	// listen for events in the window.
	for {
		select {
		case e := <-a.window.Events():
			// detect what type of event
			switch e := e.(type) {

			// this is sent when the application should re-render.
			case system.FrameEvent:
				gtx := layout.NewContext(&ops, e)
				// Let's try out the flexbox layout concept
				if startButton.Clicked() {
					boiling = !boiling
				}

				// Let's try out the flexbox layout concept
				layout.Flex{
					// Vertical alignment, from top to bottom
					Axis: layout.Vertical,
					// Empty space is left at the start, i.e. at the top
					Spacing: layout.SpaceStart,
				}.Layout(gtx,
					layout.Rigid(
						func(gtx C) D {
							bar := material.ProgressBar(th, progress) // Here progress is used
							return bar.Layout(gtx)
						},
					),
					layout.Rigid(
						func(gtx C) D {
							// ONE: First define margins around the button using layout.Inset ...
							margins := layout.Inset{
								Top:    unit.Dp(25),
								Bottom: unit.Dp(25),
								Right:  unit.Dp(35),
								Left:   unit.Dp(35),
							}
							// TWO: ... then we lay out those margins ...
							return margins.Layout(gtx,
								// THREE: ... and finally within the margins, we define and lay out the button
								func(gtx C) D {
									var text string
									if !boiling {
										text = "Start"
									} else {
										text = "Stop"
									}
									btn := material.Button(th, &startButton, text)
									return btn.Layout(gtx)
								},
							)
						},
					),
				)
				e.Frame(gtx.Ops)
				// this is sent when the application is closed.
			case system.DestroyEvent:
				return e.Err

			}
		case p := <-progressIncrementer:
			if boiling && progress < 1 {
				progress += p
				a.window.Invalidate()
			}
		}

	}

}
