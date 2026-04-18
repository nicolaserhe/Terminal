package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"net"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/getlantern/systray"
)

type Message struct {
	LayerChange struct {
		New string `json:"new"`
	} `json:"LayerChange"`
}

var (
	defaultIcon []byte
	emacsIcon   []byte

	current   = ""
	layerChan = make(chan string, 16)
)

func mustReadIcon(name string) []byte {
	home, err := os.UserHomeDir()
	if err != nil {
		panic(err)
	}

	path := filepath.Join(home, ".local/share/kanata-tray", name)
	data, err := os.ReadFile(path)
	if err != nil || len(data) == 0 {
		panic("failed to load icon: " + path)
	}
	return data
}

func main() {
	defaultIcon = mustReadIcon("default.png")
	emacsIcon = mustReadIcon("emacs.png")

	systray.Run(onReady, onExit)
}

func onReady() {
	current = "default"

	systray.SetIcon(defaultIcon)
	systray.SetTooltip("Layer: default")

	// UI 更新 loop（主线程）
	go func() {
		for layer := range layerChan {
			updateUI(layer)
		}
	}()

	// 网络线程
	go connectLoop()
}

func onExit() {}

func updateUI(layer string) {
	if layer == "" || layer == current {
		return
	}

	current = layer

	switch layer {
	case "emacs":
		systray.SetIcon(emacsIcon)
	default:
		systray.SetIcon(defaultIcon)
	}

	systray.SetTooltip("Layer: " + layer)
	fmt.Println("→", layer)
}

func connectLoop() {
	for {
		conn, err := net.DialTimeout("tcp", "127.0.0.1:5829", 3*time.Second)
		if err != nil {
			fmt.Println("[kanata] connect failed:", err)
			time.Sleep(2 * time.Second)
			continue
		}

		fmt.Println("[kanata] connected")

		handleConn(conn)

		conn.Close()
		fmt.Println("[kanata] disconnected, retrying...")
		time.Sleep(time.Second)
	}
}

func handleConn(conn net.Conn) {
	reader := bufio.NewReader(conn)

	for {
		// 防止卡死
		_ = conn.SetReadDeadline(time.Now().Add(30 * time.Second))

		line, err := reader.ReadString('\n')
		if err != nil {
			fmt.Println("[kanata] read error:", err)
			return
		}

		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}

		var msg Message
		if err := json.Unmarshal([]byte(line), &msg); err != nil {
			fmt.Println("[kanata] json error:", err)
			continue
		}

		layer := msg.LayerChange.New
		if layer == "" {
			continue
		}

		select {
		case layerChan <- layer:
		default:
			// channel 满了就丢（避免阻塞）
		}
	}
}
