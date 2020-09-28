AddonBuilder clone do(

    srcDir := Directory with(Directory currentWorkingDirectory .. "/source/discount")

    compileDiscountIfNeeded := method(
        if((platform == "windows") or(platform == "mingw"),
            appendLibSearchPath(Path with(Directory currentWorkingDirectory, "deps/w64/lib") asIoPath)
            appendHeaderSearchPath(Path with(Directory currentWorkingDirectory, "/deps/w64/include") asIoPath)
            ,
            Eerie sh("cd #{srcDir path} && CC='cc -fPIC' ./configure.sh && make" interpolate)
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
