package resource

import (
	"fmt"
)
var resourceTable = map[string]string{
	"KeyVault" : "Security",
	"StorageAccount" : "Storage",
}

func GetCategory(resource string) (string, error)  {
	category, ok := resourceTable[resource]
	if ok {
		return category, nil 
	}
	return "", fmt.Errorf("Unknown resource type")
	
}

