package api

import (
	"fmt"
	"net/http"

	"github.com/bugsnag/bugsnag-go"
)

func (a *API) InitializeRoutes() {
	userC := a.Cs.UserC
	addressC := a.Cs.AddressC
	cartC := a.Cs.CartC
	productC := a.Cs.ProductC

	//auth
	a.R.HandleFunc("/api/account/signup", userC.SignUp).Methods("POST")
	a.R.HandleFunc("/api/account/signin", userC.SignIn).Methods("POST")
	a.R.HandleFunc("/api/password/forgot", userC.ForgotPassword).Methods("POST")
	a.R.HandleFunc("/api/password/checkpin", userC.CheckPinPassword).Methods("POST")
	a.R.HandleFunc("/api/password/reset", userC.ResetPassword).Methods("POST")

	//oauth2
	a.R.HandleFunc("/oauth2", userC.HandleMain)
	// a.r.HandleFunc("/oauth2/facebook/login", userC.HandleFacebookLogin)
	a.R.HandleFunc("/oauth2/facebook/login/{access_token}", userC.HandleAccessTokenFacebook).Methods("POST")
	a.R.HandleFunc("/oauth2/facebook/callback", userC.HandleFacebookCallback)
	a.R.HandleFunc("/oauth2/google/login", userC.HandleGoogleLogin)
	a.R.HandleFunc("/oauth2/google/callback", userC.HandleGoogleCallback)
	a.R.HandleFunc("/oauth2/google/login/{access_token}", userC.HandleAccessTokenGoogle).Methods("POST")

	a.R.HandleFunc("/email/subject", userC.SubjectEmail).Methods("POST")

	//			Address					//
	a.R.HandleFunc("/api/address/create", addressC.CreateAddress).Methods("POST")
	a.R.HandleFunc("/api/address/get", addressC.GetAddess).Methods("GET")
	a.R.HandleFunc("/api/address/delete", addressC.DeleteAddress).Methods("POST")
	a.R.HandleFunc("/api/address/update", addressC.UpdateAddress).Methods("POST")
	a.R.HandleFunc("/api/districts/id={id:[0-9]+}", addressC.DistrictsByID).Methods("GET")
	a.R.HandleFunc("/api/wards/id={id:[0-9]+}", addressC.WardsByID).Methods("GET")
	a.R.HandleFunc("/api/provinces/all", addressC.AllProvinces).Methods("GET")

	//			Product
	a.R.HandleFunc("/api/products/categories={id:[0-9]+}", productC.ProductsByCategoryId).Methods("GET")
	a.R.HandleFunc("/api/products/tag={tag:[0-9]+}", productC.ProductsByTags).Methods("GET")
	// a.r.HandleFunc("/api/products//related/id={id:[0-9]+}", productC.RelatedProducts).Methods("GET")
	a.R.HandleFunc("/api/products/shop={id:[0-9]+}", productC.ProductsByShopId).Methods("GET")
	a.R.HandleFunc("/api/products/id={id:[0-9]+}/sr={sr:[a-z]+}", productC.ProductDetailById).Methods("GET")
	a.R.HandleFunc("/api/products/review/id={id:[0-9]+}/sr={sr:[a-z]+}", productC.ProductReviewsById).Methods("GET")

	a.R.HandleFunc("/api/private/products/id={id:[0-9]+}/sr={sr:[a-z]+}", productC.CreateProductById).Methods("GET")
	// a.r.HandleFunc("/api/product/updatethumbnails", productC.UpdateThumbnailImages).Methods("GET")
	a.R.HandleFunc("/api/product/update_prices", productC.UpdateProductPrices).Methods("GET")
	a.R.HandleFunc("/api/product/update_price/id={id:[0-9]+}", productC.UpdateProductPrice).Methods("POST")

	//			Category
	a.R.HandleFunc("/api/categories/all", productC.AllCategories).Methods("GET")
	a.R.HandleFunc("/api/categories/parentId={parentId:[0-9]+}", productC.GetSubCategories).Methods("GET")

	//			Cart
	a.R.HandleFunc("/api/cart/new", cartC.CreateCartItem).Methods("POST")
	a.R.HandleFunc("/api/cart/all", cartC.AllCartItems).Methods("GET")
	a.R.HandleFunc("/api/cart/coupons/all", cartC.AvailableCoupons).Methods("GET")

	a.R.HandleFunc("/api/cart/update", cartC.UpdateCartItem).Methods("POST")
	a.R.HandleFunc("/api/cart/delete", cartC.DeleteCartItem).Methods("POST")
	a.R.HandleFunc("/api/order/new", cartC.CreateOrder).Methods("POST")
	a.R.HandleFunc("/api/order/detail/id={id:[0-9]+}", cartC.OrderDetailByOrderID).Methods("GET")
	a.R.HandleFunc("/api/order/all", cartC.OrderHistoryByUserID).Methods("GET")

	// a.r.HandleFunc("/api/cart/no", cartC.CreateCartItem).Methods("POST")
	// var err = errors.New("this is an test error")
	// sentry.CaptureException(err)

	http.ListenAndServe(fmt.Sprintf(":%d", a.Cfg.Port),
		bugsnag.Handler(a.R))
}
