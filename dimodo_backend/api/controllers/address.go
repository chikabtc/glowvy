package controllers

import (
	"database/sql"
	"dimodo_backend/models"

	"dimodo_backend/utils/jwt"
	resp "dimodo_backend/utils/respond"

	"dimodo_backend/utils"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/bugsnag/bugsnag-go"
	"github.com/gorilla/mux"
)

type Address struct {
	as models.AddressService
}

func NewAddress(as models.AddressService) *Address {
	return &Address{
		as: as,
	}
}

func (a *Address) GetAddess(w http.ResponseWriter, r *http.Request) {
	auth := jwt.Payload(r)
	print("authId: ", auth.Id)
	address, err := a.as.GetAddess(auth.Id)
	if err != nil {
		bugsnag.Notify(err)
		switch err {
		case sql.ErrNoRows:
			msgError := fmt.Sprintf("Address not found. Error: %s", err.Error())
			resp.Json(w, r, http.StatusNotFound, resp.WithError(msgError))
		default:
			resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		}
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(address))
}

func (a *Address) UpdateAddress(w http.ResponseWriter, r *http.Request) {
	auth := jwt.Payload(r)
	utils.PrintJson(auth)
	var address models.Address
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&address); err != nil {
		msgError := fmt.Sprintf("Invalid request payload. Error: %s", err.Error())
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	defer r.Body.Close()

	address.Id = auth.Id
	if err := a.as.UpdateAddress(&address); err != nil {
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(address))
}

func (a *Address) DistrictsByID(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id, err := strconv.Atoi(params["id"])
	if err != nil {
		bugsnag.Notify(err)
		msgError := fmt.Sprintf("Invalid actions Id. Error: %s", err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	print("id received", id)
	districts, err := a.as.ListDistrictsByID(id)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(districts))
}

func (a *Address) WardsByID(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id, err := strconv.Atoi(params["id"])
	if err != nil {
		bugsnag.Notify(err)
		msgError := fmt.Sprintf("Invalid actions Id. Error: %s", err)
		resp.Json(w, r, http.StatusBadRequest, resp.WithError(msgError))
		return
	}
	wards, err := a.as.ListWardsByID(id)
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(wards))

}
func (a *Address) AllProvinces(w http.ResponseWriter, r *http.Request) {
	provinces, err := a.as.AllProvinces()
	if err != nil {
		bugsnag.Notify(err)
		resp.Json(w, r, http.StatusInternalServerError, resp.WithError(err.Error()))
		return
	}
	resp.Json(w, r, http.StatusOK, resp.WithSuccess(provinces))
}
