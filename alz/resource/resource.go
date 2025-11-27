package resource

import (
	"fmt"
	"log"
	"os"

	"github.com/theakshai/alz/utils"
)


func CommandCenter() error {
	args := os.Args[1:]
	centerCommand := args[0]
	resources := args[1:]

	switch centerCommand {
	case "add":
		return Add(resources)
	case "remove":
		return Remove()
	}

	return nil
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

				category , err := GetCategory(resource)
				if err != nil {
					return err
				}

				c_path, c_err := utils.MakeDir(category)
				fmt.Println("The path is the",c_path)
				fmt.Println(c_err)
				if c_err!=nil{
					return c_err
				}

        sparseCmd := fmt.Sprintf( "git -C %s sparse-checkout set azure/Modules/%s/%s", path, category,resource)

        if err := utils.CommandExecution(sparseCmd); err != nil {
            return fmt.Errorf("sparse-checkout failed for %s: %w", resource, err)
        }

        restoreCmd := fmt.Sprintf( "git -C %s restore --source=HEAD -- azure/Modules/%s/%s", path, category, resource)

        if err := utils.CommandExecution(restoreCmd); err != nil {
            return fmt.Errorf("restore failed for %s: %w", resource, err)
        }


				moveCmd := fmt.Sprintf("mv  %s/azure/Modules/%s/%s %s", path, category, resource, c_path)
				fmt.Println(moveCmd)

				if err := utils.CommandExecution(moveCmd); err != nil {
					fmt.Println("hello")
					return fmt.Errorf("Moving the module failed failed for %s: %w", resource, err)
				}
    }

    return nil
}

func Remove() error {
	log.Println("This is from get service")
	return nil
}
