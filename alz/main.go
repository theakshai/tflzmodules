package main

import (
	"log"
	"os"

	"github.com/theakshai/alz/utils"
	"github.com/theakshai/alz/resource"
)

func main() {
	log_err:=	utils.ConfigureLog()
	if log_err != nil {
		log.Fatal("Error in configuring the Log System", log_err)
		os.Exit(1)
	}

	resource.CommandCenter()


}
