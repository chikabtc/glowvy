package api

import (
	"fmt"
	"net/http"

	"github.com/bugsnag/bugsnag-go"
)

func (a *API) InitializeRoutes() {
	userC := a.cs.userC
	addressC := a.cs.addressC
	cartC := a.cs.cartC
	productC := a.cs.productC

	//auth
	a.r.HandleFunc("/api/account/signup", userC.SignUp).Methods("POST")
	a.r.HandleFunc("/api/account/signin", userC.SignIn).Methods("POST")
	a.r.HandleFunc("/api/password/forgot", userC.ForgotPassword).Methods("POST")
	a.r.HandleFunc("/api/password/checkpin", userC.CheckPinPassword).Methods("POST")
	a.r.HandleFunc("/api/password/reset", userC.ResetPassword).Methods("POST")

	//oauth2
	a.r.HandleFunc("/oauth2", userC.HandleMain)
	// a.r.HandleFunc("/oauth2/facebook/login", userC.HandleFacebookLogin)
	a.r.HandleFunc("/oauth2/facebook/login/{access_token}", userC.HandleAccessTokenFacebook).Methods("POST")
	a.r.HandleFunc("/oauth2/facebook/callback", userC.HandleFacebookCallback)
	a.r.HandleFunc("/oauth2/google/login", userC.HandleGoogleLogin)
	a.r.HandleFunc("/oauth2/google/callback", userC.HandleGoogleCallback)
	a.r.HandleFunc("/oauth2/google/login/{access_token}", userC.HandleAccessTokenGoogle).Methods("POST")

	a.r.HandleFunc("/email/subject", userC.SubjectEmail).Methods("POST")

	//			Address					//
	a.r.HandleFunc("/api/address/get", addressC.GetAddess).Methods("GET")
	a.r.HandleFunc("/api/address/update", addressC.UpdateAddress).Methods("POST")
	a.r.HandleFunc("/api/districts/id={id:[0-9]+}", addressC.DistrictsByID).Methods("GET")
	a.r.HandleFunc("/api/wards/id={id:[0-9]+}", addressC.WardsByID).Methods("GET")
	a.r.HandleFunc("/api/provinces/all", addressC.AllProvinces).Methods("GET")

	//			Product
	a.r.HandleFunc("/api/products/categories={id:[0-9]+}", productC.ProductsByCategoryId).Methods("GET")
	a.r.HandleFunc("/api/products/tag={tag:[a-z]+}", productC.ProductsByTags).Methods("GET")
	// a.r.HandleFunc("/api/products//related/id={id:[0-9]+}", productC.RelatedProducts).Methods("GET")
	a.r.HandleFunc("/api/products/shop={id:[0-9]+}", productC.ProductsByShopId).Methods("GET")
	a.r.HandleFunc("/api/products/id={id:[0-9]+}/sr={sr:[a-z]+}", productC.ProductDetailById).Methods("GET")
	a.r.HandleFunc("/api/products/review/id={id:[0-9]+}/sr={sr:[a-z]+}", productC.ProductReviewsById).Methods("GET")

	a.r.HandleFunc("/api/private/products/id={id:[0-9]+}/sr={sr:[a-z]+}", productC.CreateProductById).Methods("GET")
	// a.r.HandleFunc("/api/product/updatethumbnails", productC.UpdateThumbnailImages).Methods("GET")

	//			Category
	a.r.HandleFunc("/api/categories/all", productC.AllCategories).Methods("GET")

	//			Cart
	a.r.HandleFunc("/api/cart/new", cartC.CreateCartItem).Methods("POST")
	a.r.HandleFunc("/api/cart/all", cartC.AllCartItems).Methods("GET")

	a.r.HandleFunc("/api/cart/update", cartC.UpdateCartItem).Methods("POST")
	a.r.HandleFunc("/api/cart/delete", cartC.DeleteCartItem).Methods("POST")
	a.r.HandleFunc("/api/order/new", cartC.CreateOrder).Methods("POST")
	a.r.HandleFunc("/api/order/all", cartC.OrderHistoryByUserID).Methods("GET")

	// a.r.HandleFunc("/api/cart/no", cartC.CreateCartItem).Methods("POST")
	// var err = errors.New("this is an test error")
	// sentry.CaptureException(err)

	http.ListenAndServe(fmt.Sprintf(":%d", a.cfg.Port),
		bugsnag.Handler(a.r))
}
