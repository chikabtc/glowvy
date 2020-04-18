package cli

import (
	"fmt"
	"os"
	"os/exec"

	"github.com/bugsnag/bugsnag-go"
)

var flagvar int

func must(err error) {
	if err != nil {
		bugsnag.Notify(err)
		fmt.Printf("err: %s\n", err)
		panic(err)
	}
}

func execute() {
	cmd := exec.Command("go", "build", ".")
	cmd.Env = os.Environ()
	cmd.Env = append(cmd.Env, "GOOS=linux", "GOARCH=amd64")
	out, err := cmd.CombinedOutput()
	must(err)
	fmt.Printf("output of ls:\n%s\n", string(out))
}

func main() {
	// if runtime.GOOS == "windows" {
	// 	fmt.Println("Can't Execute this on a windows machine")
	// } else {
	execute()
	// }
}
