# MarkdownStitcher

MarkdownStitcher is a console program for combining multiple Markdown files together into one file. You can get the files from your local machine or directly from the web. Any files downloaded from the web will automatically be deleted from your machine.

Sometimes there's a ton of Markdown files that I'm trying to read and it gets overwhelming. This allows me to stitch together the various files and have VoiceOver speak it so I can read along and help me process the information. I figured that this may help others who are in the same position as I am.

## Installation

1. Clone the repository:

```zsh
git clone https://github.com/MasterJ93/markdownstitcher.git
```

2. Then navigate to the package:

```zsh
cd path/to/MarkdownStitcher
```

3. After that, build the executable:

```zsh
swift build -c release
```

You can also move the executable to your PATH if you'd like:'

```zsh
cp .build/release/markdownstitcher /usr/local/bin/markdownstitcher
```

## Usage

### Command-Line Mode

```zsh
markdownstitcher <source1> <source2> ... --output <output_path>
```

Example:

```zsh
markdownstitcher file1.md file2.md https://example.com/file.md --output stitched_output.md
```

### Guided Mode

If you'd like a more guided way of doing this, you can use it by just typing `markdownstitcher`:

```zsh
markdownstitcher
```

Follow the instructions to add files, manage the list, and output the resulting file.

Commands in Guided Mode:
- **File Paths or URLs**: The file paths and URLs that will be added to the list.
- `--view`: View the files added so far.
- `--clear`: Clear the list of added files.
- `--output <output_path>`: Stitch files and save the output.
- `--help`: Display the help message.
- `quit`: Exit the program.

Example:

```zsh
$ markdownstitcher

Type the file path or URL of the Markdown file(s) and press Return.
Commands:
- "--output <output_path>": Stitch the files and save the output.
- "--view": View the files you've added so far.
- "--clear": Clear all added files.
- "--help": Show this help message.
- "quit": Exit the program.

$ file1.md
Files added.

$ https://example.com/file.md
Files added.

$ --view
Files added so far:
- file1.md
- https://example.com/file.md

$ --output stitched_output.md
Stitching Markdown files...

Starting download: https://example.com/file.md
File size: 45 KB
Download completed: /var/folders/.../F409A1AC-7DF6-4C7E-8DA8-75C0E40E89F7-file.md

Output written to stitched_output.md
```

## License

This project is licensed under the MIT License. Please see the LICENSE file for details.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to improve the tool.
