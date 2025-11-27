package utils

import (
	"log"
	"os"
	"path/filepath"
	"time"
)

func ConfigureLog() error {

	logDir, err := initLogDir()
	if err != nil {
		return err
	}

	logFile := time.Now().Format("20060102_150405") + ".txt"
	logFileAbsolutePath := filepath.Join(logDir, logFile)

	file, err := os.OpenFile(
		logFileAbsolutePath,
		os.O_APPEND|os.O_CREATE|os.O_WRONLY,
		0666,
	)
	if err != nil {
		return err
	}

	log.SetOutput(file)
	return nil   
}

func initLogDir() (string, error) {
	home, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}

	logDir := filepath.Join(home, ".alz")

	if err := os.MkdirAll(logDir, os.ModePerm); err != nil {
		return "", err
	}

	return logDir, nil
}
