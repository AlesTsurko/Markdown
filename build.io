AddonBuilder clone do(

    srcDir := Directory with(Directory currentWorkingDirectory .. "/source/discount")

    compileDiscountIfNeeded := method(
        if((platform == "windows") or(platform == "mingw"),
            appendLibSearchPath(Path with(Directory currentWorkingDirectory, "deps/w64/lib") asIoPath)
            appendHeaderSearchPath(Path with(Directory currentWorkingDirectory, "/deps/w64/include") asIoPath)
            ,
            prefix := Directory currentWorkingDirectory .. "/_build"
            Eerie sh("cd #{srcDir path} && CC='cc -fPIC' ./configure.sh --prefix=#{prefix} && make && make install" interpolate)
            appendHeaderSearchPath(Path with(Directory currentWorkingDirectory, "_build/include") asIoPath)
            appendLibSearchPath(Path with(Directory currentWorkingDirectory, "_build/lib") asIoPath)
        )
    )

    compileDiscountIfNeeded

    dependsOnLib("markdown")
    dependsOnHeader("mkdio.h")

    clean := method(
        resend
        if((platform == "windows") or (platform == "mingw"),
            "there is no clean command for windows platform" println
            ,
            System system("cd #{srcDir path} && make clean" interpolate)
        )
    )
)
