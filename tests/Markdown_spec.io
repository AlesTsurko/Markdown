// TEST.md: https://github.com/mxstbr/markdown-test-file
Markdown

describe("Markdown", 
    it("Should convert markdown string to HTML.",
        testsPath := Directory currentWorkingDirectory .. "/tests/"
        input := File with(testsPath .. "TEST.md") contents
        expected := File with(testsPath .. "OUTPUT.html") contents
        converted := Markdown toHTML(input) .. "\n"

        expect(converted) toBe(expected)
    )
)

describe("Sequence",
    it("Should return HTML string when markdownToHTML called on it.",
        testsPath := Directory currentWorkingDirectory .. "/tests/"
        input := File with(testsPath .. "TEST.md") contents
        expected := File with(testsPath .. "OUTPUT.html") contents
        converted := input markdownToHTML .. "\n"

        expect(converted) toBe(expected)
    )
)
