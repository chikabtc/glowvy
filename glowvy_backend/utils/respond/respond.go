package resp

import (
	"encoding/json"
	"net/http"
)

type respond struct {
	Success bool
	Error   string                 `json:"error,omitempty"`
	Data    map[string]interface{} `json:"data,omitempty"`
	code    int
	status  string
	method  string
}

func WithError(payload interface{}) map[string]interface{} {
	return Packing("Error", payload, false)
}

func WithSuccess(payload interface{}) map[string]interface{} {
	return Packing("Data", payload, true)
}
func Packing(NamePayload string, payload interface{}, success bool) map[string]interface{} {
	resp := make(map[string]interface{})
	resp["Success"] = success
	resp[NamePayload] = payload
	return resp
}
func Json(w http.ResponseWriter, r *http.Request, code int, resp map[string]interface{}) {
	resp["Code"] = code
	resp["Status"] = http.StatusText(code)
	resp["Method"] = r.Method
	respond, _ := json.Marshal(resp)
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	w.Write(respond)
}
