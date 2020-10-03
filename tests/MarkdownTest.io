// TEST.md: https://github.com/mxstbr/markdown-test-file
Markdown

MarkdownTest := UnitTest clone do(
    testConverter := method(
        testsPath := Directory currentWorkingDirectory
        input := File with(testsPath .. "/tests/TEST.md") contents
        expected := File with(testsPath .. "/tests/OUTPUT.html") contents
        converted := Markdown toHtml(input) .. "\n"

        assertEquals(converted, expected)
    )

    testSequenceMethod := method(
        testsPath := Directory currentWorkingDirectory
        input := File with(testsPath .. "/tests/TEST.md") contents
        expected := File with(testsPath .. "/tests/OUTPUT.html") contents
        converted := input markdownToHtml .. "\n"

        assertEquals(converted, expected)
    )
)
