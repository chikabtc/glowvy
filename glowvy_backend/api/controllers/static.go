package controllers

import "dimodo_backend/views"

func NewStatic() *Static {
	return &Static{
		Home: views.NewView(
			"static/home"),
		// Contact: views.NewView(
		// 	"static/contact"),
		// Faq: views.NewView(
		// 	"static/faq"),
	}
}

type Static struct {
	Home *views.View
	// Contact *views.View
	// Faq     *views.View
}
