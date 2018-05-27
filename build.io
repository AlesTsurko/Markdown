AddonBuilder clone do(

    srcDir := Directory with(Directory currentWorkingDirectory .. "/source/discount")

    hasLib := libSearchPaths detect(path, Directory with(path) files detect(name containsSeq("libmarkdown")))
    if(hasLib == nil,
        writeln("No libmarkdown installed — attempting to compile and install")

        // Compile
        if((platform == "windows") or (platform == "mingw"),
            // compile for windows
            appendLibSearchPath(Path with(Directory currentWorkingDirectory, "deps/w64/lib") asOSPath)
            appendHeaderSearchPath(Path with(Directory currentWorkingDirectory, "/deps/w64/include") asOSPath)
            ,
            // Download
            uri := "https://github.com/Orc/discount.git"
            if(srcDir exists, srcDir remove; srcDir create, srcDir create)
            packageDownloader := Eerie PackageDownloader detect(uri, srcDir path)
            packageDownloader download

            Eerie sh("cd #{srcDir path} && ./configure.sh --shared --pkg-config && make && make install" interpolate)
        )
    )

    dependsOnLib("libmarkdown")
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
