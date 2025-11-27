package main

import (
	"fmt"
	"log"
	"os"

	"github.com/theakshai/alz/resource"
	"github.com/theakshai/alz/utils"
)

func main() {
	log_err:=	utils.ConfigureLog()
	if log_err != nil {
		log.Fatal("Error in configuring the Log System", log_err)
		os.Exit(1)
	}

	err := resource.CommandCenter()
	if err!=nil{
		fmt.Println(err)
		log.Fatal("error in control plane, refer the logs in ~/.alz/", err)
	}


}
