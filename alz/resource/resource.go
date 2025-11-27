package resource

import (
	"fmt"
	"log"
	"os"

	"github.com/theakshai/alz/utils"
)


func CommandCenter() {
	args := os.Args[1:]
	centerCommand := args[0]
	resources := args[1:]

	switch centerCommand {
	case "add":
		fmt.Println("Hello from add")
		Add(resources)
	case "remove":
		Remove()
	}

}


func Add(resources []string) error {
    if err := utils.CloneModulesRepo(); err != nil {
        return err
    }

    path, err := utils.RepoPath()
    if err != nil {
        return err
    }

    for _, resource := range resources {

        sparseCmd := fmt.Sprintf( "git -C %s sparse-checkout set azure/Modules/%s", path, resource)

        if err := utils.CommandExecution(sparseCmd); err != nil {
            return fmt.Errorf("sparse-checkout failed for %s: %w", resource, err)
        }

        restoreCmd := fmt.Sprintf( "git -C %s restore --source=HEAD -- azure/Modules/%s", path, resource)

        if err := utils.CommandExecution(restoreCmd); err != nil {
            return fmt.Errorf("restore failed for %s: %w", resource, err)
        }

				currDir, err := os.Getwd() 
				if err != nil {
					return err
				}

				moveCmd := fmt.Sprintf("mv  %s/azure/Modules/%s %s", path, resource, currDir)
				fmt.Println(moveCmd)

				if err := utils.CommandExecution(moveCmd); err != nil {
					return fmt.Errorf("Moving the module failed failed for %s: %w", resource, err)
				}
    }

    return nil
}

func Remove() {
	log.Println("This is from get service")
}
