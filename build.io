AddonBuilder clone do(

    srcDir := Directory with(Directory currentWorkingDirectory .. "/source/discount")

    hasLib := libSearchPaths detect(path, Directory with(path) files detect(name containsSeq("libmarkdown")))
    if(hasLib == nil,
        writeln("No libmarkdown installed — attempting to compile and install")

        // Download
        uri := "https://github.com/Orc/discount.git"
        if(srcDir exists, srcDir remove; srcDir create, srcDir create)
        packageDownloader := Eerie PackageDownloader detect(uri, srcDir path)
        packageDownloader download

        // Compile
        if((platform == "windows") or (platform == "mingw"),
            // compile for windows
            ,
            Eerie sh("cd #{srcDir path} && ./configure.sh --shared --pkg-config && make && make install" interpolate)
        )
    )

    dependsOnLib("libmarkdown")
    dependsOnHeader("mkdio.h")

    clean := method(
        resend
        if((platform == "windows") or (platform == "mingw"),
            // compile for windows
            ,
            System system("cd #{srcDir path} && make clean" interpolate)
        )
    )
)
