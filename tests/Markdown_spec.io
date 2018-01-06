// TEST.md: https://github.com/mxstbr/markdown-test-file
Markdown

describe("Markdown", 
    it("Should convert markdown string to HTML.",
        testsPath := Directory currentWorkingDirectory .. "/tests/"
        input := File with(testsPath .. "TEST.md") contents
        expected := File with(testsPath .. "OUTPUT.html") contents
        converted := Markdown toHTML(input)
		converted println
        expected size println
        converted size println

        expect(converted) toBe(expected)
    )
)
