AddonBuilder clone do(

    srcDir := Directory with(Directory currentWorkingDirectory .. "/source/discount")

    downloadDiscount := method(
        uri := "https://github.com/Orc/discount.git"
        if(srcDir exists, srcDir remove; srcDir create, srcDir create)
        packageDownloader := Eerie PackageDownloader detect(uri, srcDir path)
        packageDownloader download
        appendHeaderSearchPath(srcDir path asIoPath)
    ) 

    downloadDiscount

    compileDiscountIfNeeded := method(
        if((platform != "windows") and(platform != "mingw"),
            Eerie sh("cd #{srcDir path} && ./configure.sh --shared && make" interpolate)
        )
    )

    compileDiscountIfNeeded

    hasLib := libSearchPaths detect(path, Directory with(path) files detect(name containsSeq("libmarkdown")))
    if(hasLib == nil,
        writeln("No libmarkdown installed — attempting to compile and install")

        // Install
        if((platform == "windows") or (platform == "mingw"),
            appendLibSearchPath(Path with(Directory currentWorkingDirectory, "deps/w64/lib") asIoPath)
            appendHeaderSearchPath(Path with(Directory currentWorkingDirectory, "/deps/w64/include") asIoPath)
            ,
            Eerie sh("cd #{srcDir path} && make install" interpolate)
        )
    )

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
