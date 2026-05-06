// +build ignore

package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	_ "modernc.org/sqlite" // Pure Go SQLite driver (No CGO)
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: go run generate_schema.go <path_to_sqlite_db>")
		return
	}

	dbPath := os.Args[1]
	db, err := sql.Open("sqlite", dbPath)
	if err != nil {
		log.Fatalf("Failed to open database: %v", err)
	}
	defer db.Close()

	var dotBuilder strings.Builder
	dotBuilder.WriteString("digraph G {\n")
	dotBuilder.WriteString("  rankdir=LR;\n")
	dotBuilder.WriteString("  node [shape=record, fontname=\"Fira Code\", fontsize=10];\n")

	// 1. Fetch Tables
	tables, err := db.Query("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'")
	if err != nil {
		log.Fatal(err)
	}
	defer tables.Close()

	for tables.Next() {
		var tableName string
		tables.Scan(&tableName)

		// 2. Fetch Columns for each table
		cols, _ := db.Query(fmt.Sprintf("PRAGMA table_info(%s)", tableName))
		var colDefs []string
		for cols.Next() {
			var cid int
			var name, ctype string
			var notnull, pk int
			var dflt interface{}
			cols.Scan(&cid, &name, &ctype, &notnull, &dflt, &pk)
			
			pkMark := ""
			if pk > 0 { pkMark = " [PK]" }
			colDefs = append(colDefs, fmt.Sprintf("%s (%s)%s\\l", name, ctype, pkMark))
		}
		cols.Close()

		// Build table node
		dotBuilder.WriteString(fmt.Sprintf("  %s [label=\"{ %s | %s }\"];\n", 
			tableName, tableName, strings.Join(colDefs, " ")))

		// 3. Fetch Foreign Keys for relationships
		fks, _ := db.Query(fmt.Sprintf("PRAGMA foreign_key_list(%s)", tableName))
		for fks.Next() {
			var id, seq int
			var targetTable, from, to, onUpdate, onDelete, match string
			fks.Scan(&id, &seq, &targetTable, &from, &to, &onUpdate, &onDelete, &match)
			dotBuilder.WriteString(fmt.Sprintf("  %s -> %s [label=\"%s\"];\n", tableName, targetTable, from))
		}
		fks.Close()
	}
	dotBuilder.WriteString("}\n")

	// 4. Render to PNG via system 'dot'
	outputPng := strings.TrimSuffix(dbPath, filepath.Ext(dbPath)) + ".png"
	cmd := exec.Command("dot", "-Tpng", "-o", outputPng)
	cmd.Stdin = strings.NewReader(dotBuilder.String())
	
	if err := cmd.Run(); err != nil {
		log.Fatalf("Graphviz execution failed (ensure 'graphviz' is installed): %v", err)
	}

	fmt.Printf("✔ Generated ERD: %s\n", outputPng)
}
