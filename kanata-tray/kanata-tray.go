package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"net"
	"os"
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
	current     string
)

func main() {
	// 加载 PNG 图标
	var err error
	defaultIcon, err = os.ReadFile("/home/gcy/.local/share/kanata-tray/default.png")
	if err != nil || len(defaultIcon) == 0 {
		panic("failed to load default.png")
	}

	emacsIcon, err = os.ReadFile("/home/gcy/.local/share/kanata-tray/emacs.png")
	if err != nil || len(emacsIcon) == 0 {
		panic("failed to load emacs.png")
	}

	// 启动托盘
	systray.Run(onReady, onExit)
}

func onReady() {
	current = "default"
	systray.SetIcon(defaultIcon)
	systray.SetTitle("Layer")
	systray.SetTooltip("Layer: default")

	// 连接 Kanata
	go connectKanata()
}

func onExit() {}

func connectKanata() {
	for {
		// 建立 TCP 客户端连接
		conn, err := net.Dial("tcp", "localhost:5829")
		if err != nil {
			fmt.Println("Failed to connect Kanata, retrying in 1s:", err)
			// 等一秒再重连
			// 避免程序退出
			// 你可以调成 longer if needed
			select {
			case <-time.After(1e9):
				continue
			}
		}

		fmt.Println("Connected to Kanata on 5829")
		handleConnection(conn)
		conn.Close()
		fmt.Println("Disconnected, retrying...")
	}
}

func handleConnection(conn net.Conn) {
	scanner := bufio.NewScanner(conn)
	for scanner.Scan() {
		line := scanner.Text()
		if line == "" {
			continue
		}

		var msg Message
		if err := json.Unmarshal([]byte(line), &msg); err != nil {
			fmt.Println("JSON parse error:", err)
			continue
		}

		switch msg.LayerChange.New {
		case "emacs":
			if current != "emacs" {
				current = "emacs"
				systray.SetIcon(emacsIcon)
				systray.SetTooltip("Layer: emacs")
				fmt.Println("→ emacs")
			}
		case "default":
			if current != "default" {
				current = "default"
				systray.SetIcon(defaultIcon)
				systray.SetTooltip("Layer: default")
				fmt.Println("→ default")
			}
		}
	}
}
