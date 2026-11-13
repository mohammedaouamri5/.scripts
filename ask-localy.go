package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"

	"github.com/charmbracelet/glamour"
	"github.com/charmbracelet/lipgloss"
)

const (
	model        = "gemma4:e2b"
	ollamaURL    = "http://localhost:11434/api/chat"
	systemPrompt = "Context: User is a backend engineer on Arch Linux (Hyprland/Niri). " +
		"Hardware: RTX 3060 (12GB VRAM). Tooling: Go, Neovim, Ollama.\n" +
		"Rules:\n1. NO filler.\n2. Arch-specific commands.\n3. Code blocks for commands.\n" +
		"4. Be terse.\n5. High technical competence assumed."
)

var (
	panelStyle = lipgloss.NewStyle().
			Border(lipgloss.RoundedBorder()).
			BorderForeground(lipgloss.Color("13")).
			Padding(1, 2)
	titleStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("14")).
			Bold(true)
	streamStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("245"))
)

type Message struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

type ChatRequest struct {
	Model    string    `json:"model"`
	Messages []Message `json:"messages"`
	Stream   bool      `json:"stream"`
}

type StreamResponse struct {
	Message Message `json:"message"`
	Done    bool    `json:"done"`
}

func fetchStreaming(userInput string) (string, error) {
	reqBody, _ := json.Marshal(ChatRequest{
		Model:  model,
		Stream: true,
		Messages: []Message{
			{Role: "system", Content: systemPrompt},
			{Role: "user", Content: userInput},
		},
	})

	resp, err := http.Post(ollamaURL, "application/json", bytes.NewReader(reqBody))
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	var fullText strings.Builder
	var lineCount int

	scanner := bufio.NewScanner(resp.Body)
	for scanner.Scan() {
		line := scanner.Text()
		if line == "" {
			continue
		}

		var chunk StreamResponse
		if err := json.Unmarshal([]byte(line), &chunk); err != nil {
			continue
		}

		token := chunk.Message.Content
		if token != "" {
			fullText.WriteString(token)
			// Print token inline, dimmed
			fmt.Print(streamStyle.Render(token))

			// Count newlines to know how many lines we've printed
			lineCount += strings.Count(token, "\n")
		}

		if chunk.Done {
			break
		}
	}

	if err := scanner.Err(); err != nil && err != io.EOF {
		return fullText.String(), err
	}

	// Move cursor to start of streaming output and clear it
	// Move up lineCount lines, then clear from cursor to end of screen
	if lineCount > 0 {
		fmt.Printf("\033[%dA", lineCount)
	}
	fmt.Print("\033[J") // clear from cursor to end of screen

	return fullText.String(), nil
}

func main() {
	var userInput string
	stat, _ := os.Stdin.Stat()
	if (stat.Mode() & os.ModeCharDevice) == 0 {
		data, _ := io.ReadAll(os.Stdin)
		userInput = strings.TrimSpace(string(data))
	} else if len(os.Args) > 1 {
		userInput = strings.Join(os.Args[1:], " ")
	}
	if userInput == "" {
		os.Exit(0)
	}

	fmt.Println() // breathing room before stream starts

	fullText, err := fetchStreaming(userInput)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	r, _ := glamour.NewTermRenderer(
		glamour.WithStandardStyle("dark"),
		glamour.WithWordWrap(75),
	)
	out, _ := r.Render(fullText)

	fmt.Println(panelStyle.Render(
		titleStyle.Render("  GAMMA ") + "\n" + strings.TrimSpace(out),
	))
}
