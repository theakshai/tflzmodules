package utils

import (
	"errors"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
)



func homeDir() (string, error){
	home, err := os.UserHomeDir()
	return home, err
}

func RepoPath() (string, error)  {
	home, err := homeDir()
	if err != nil {
		return "", err 
	}
	return filepath.Join(home, ".alz", ".tflzmodules"), err
	
}

func CommandExecution(command string) error{
	//command = "git clone --filter=blob:none --sparse https://github.com/theakshai/tflzmodules.git .abc"
	cmd := exec.Command("sh", "-c", command)
	out, err := cmd.CombinedOutput()
	if err != nil {
		return errors.New(string(out))
	}
	return nil
}

func moduleRepoExists(path string) (bool, error) {

	info, err := os.Stat(path)

	if err == nil {
		return info.IsDir(), nil
	}

	if os.IsNotExist(err) {
		return false, nil
	}
	return false, err
}

func CloneModulesRepo() error {
	log.Println("Checking for tflzmodules repo..")
	path, err := RepoPath()
	if err != nil {
		return err
	}
	exists, err := moduleRepoExists(path)

	if err != nil{
		return err 
	}

	if !exists{
	log.Println("Cloning tflzmodules repo..")
	command := fmt.Sprintf("git clone --filter=blob:none --sparse https://github.com/theakshai/tflzmodules.git %s", path)
	fmt.Println(command)
	err := CommandExecution(command)
	if err != nil {
		return err
	}
}
	return nil
}


