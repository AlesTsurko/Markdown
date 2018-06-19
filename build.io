AddonBuilder clone do(

    srcDir := Directory with(Directory currentWorkingDirectory .. "/source/discount")

    downloadDiscount := method(
        uri := "https://github.com/Orc/discount.git"
        if(srcDir exists, srcDir remove; srcDir create, srcDir create)
        packageDownloader := Eerie PackageDownloader detect(uri, srcDir path)
        packageDownloader download
        appendHeaderSearchPath(Path with(Directory currentWorkingDirectory, "/source/discount") asIoPath)
        appendLibSearchPath(Path with(Directory currentWorkingDirectory, "/source/discount") asIoPath)
    ) 

    downloadDiscount

    compileDiscountIfNeeded := method(
        if((platform != "windows") and(platform != "mingw"),
            Eerie sh("cd #{srcDir path} && ./configure.sh --shared && make" interpolate)
        )
    )

    compileDiscountIfNeeded

    if((platform == "windows") or (platform == "mingw"),
        appendLibSearchPath(Path with(Directory currentWorkingDirectory, "deps/w64/lib") asIoPath)
        appendHeaderSearchPath(Path with(Directory currentWorkingDirectory, "/deps/w64/include") asIoPath)
    )

    dependsOnLib("markdown")
    dependsOnHeader("mkdio.h")

    clean := method(
        resend
        if((platform == "windows") or (platform == "mingw"),
            "no clean up command for windows platform" println
            ,
            System system("cd #{srcDir path} && make clean" interpolate)
        )
    )
)
