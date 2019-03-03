# RFIDEncoderiOS
RFIDEncoder lib and framework for iOS, includes Converter.

TPM - 3/3/19

Refactored EPCEncoder into RFIDEncoder and included all the sub encoders (EPCEncoder, TCINEncoder, and TIAIEncoder), as well as the converter, in the umbrella header.

   - EPCEncoder - encodes UPCs in GS1 compliant EPC encodings
   - TCINEncoder - encodes retail TCINs in non GS1 compliant RFID tags for Target internal use only
   - TIAIEncoder - encodes non retail TIAIs in non GS1 compliant RFID tags for Target internal use only

To include these, you now need to use the following construct:

    #import <RFIDEncoder/EPCEncoder.h>
    #import <RFIDEncoder/TCINEncoder.h>
    #import <RFIDEncoder/TIAIEncoder.h>
    #import <RFIDEncoder/Converter.h>

Or for them all:

    #import <RFIDEncoder.h>


IMPORTANT NOTE: When you add this framework to another project, make sure you include it in:
    Project Target --> General --> Embedded Binaries
        -- OR --
    Build Phases --> Embed Frameworks


TPM - 3/2/19

### PROJECT SETUP NOTES

I created this as a clean Cocoa Touch Framework with the latest version of XCode, which skipped most of the notes below.  However, I still did the following:
   - To build a fat framework that includes the older armv7, armv7s, i386, as well as X86_64 and arm64, you need to set an iOS Deployment Target before v10
       - I chose a target of 8.3
   - Under RFIDEncoder Target --> Build Settings (All):
         - Architectures: Click $(ARCHS_STANDARD) and select other
         - Add the following:
            -$(ARCHS_STANDARD)
            - armv7
            - armv7s
            - arm64
            - i386
            - x86_64
        - Build Active Architecture Only - set to NO
        - Dead Code Stripping - set to NO
        - Strip Debug Symbols During Copy - set to NO
        - Strip Style - Set to "Non-Global Symbols"
    - Under RFIDEncoder Target --> Build Phases:
        - Add New Run Script Phase: Copy Framework to Local Build Directory
        - Paste the following in the /bin/sh script:
        
            \# copy the framework to the build subdirectory
            set -e
        
            echo "Copying Framework to Local build directory"
        
            export FRAMEWORK_LOCN="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework"
        
            rm -rf build/*
            cp -a ${FRAMEWORK_LOCN} build/.
        

### BUILD INSTRUCTIONS: FRAMEWORK TARGET ONLY

Follow these instructions when building the framework to the project build directory:
   - Connect an iPhone and select it as the build target (not a simulator)
   - Select RFIDEncoder.framework and build it: cmd-b
   - Right click on the framework and select: show in finder.
       - Note that the path now goes through Debug-iphoneos (Arm-64)
       - If you compile with a simulator selected, you'll see the path goes through Debug-iphonesimulator (X86...)


### UNIVERSAL FRAMEWORK SETUP NOTES

I decided to create a fat framework, based not on the original wenderlich tutorial, but the following:

https://medium.com/allatoneplace/writing-custom-universal-framework-in-xcode-9-and-ios-11-7a63a2ce024a

This includes support for Swift modules (which I skip), but it was the starting point for what I did.  Follow these instructions to setup a universal fat framework target:

Steps:
- Under the project Targets, click add
    - Under Choose a template for your new target: select Cross-platform
    - Select: Aggregate
    - Hit Next
    - Product Name: RFIDEncoderUniversal
    - Select: Finish
- Add a Scheme: Product --> Scheme --> New Scheme
    - Name it RFIDEncoderUniversal
- Switch to the new Scheme: Product --> Scheme --> RFIDEncoderUniversal
- Select the RFIDEncoderUniversal Target in the project navigator
- Under RFIDEncoderUniversal --> Build Settings (All):
    - Architectures: Click $(ARCHS_STANDARD) and select other
    - Add the following:
        -$(ARCHS_STANDARD)
        - armv7
        - armv7s
        - arm64
        - i386
        - x86_64
    - Build Active Architecture Only - set to NO
    - Dead Code Stripping - set to NO
    - Strip Debug Symbols During Copy - set to NO
    - Strip Style - Set to "Non-Global Symbols"
- Under RFIDEncoderUniversal --> Build Phases:
    - Add New Run Script Phase: Build Universal Fat Framework
    - Paste the following in the /bin/sh script:
    
            set -e
            echo "Building Universal Framework"
            
            # Step 1. Create a universal build directory
            UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal
            UNIVERSAL_TARGET=${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}
            mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"
            
            # Step 2. Build both iphonesimulator and iphoneos targets
            xcodebuild -target "${PROJECT_NAME}" -configuration ${CONFIGURATION} -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}/iphonesimulator" BUILD_ROOT="${BUILD_ROOT}" build
            xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}/iphoneos" BUILD_ROOT="${BUILD_ROOT}" build
            
            # Step 3. Copy the framework structure (from iphoneos build) to the universal folder (including headers)
            cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"
            rm -r "${UNIVERSAL_TARGET}"
            
            # Skip Step 4. Copy Swift modules from iphonesimulator build (if it exists) to the copied framework directory
            #BUILD_PRODUCTS="${SYMROOT}/../../../../Products"
            #cp -R "${BUILD_PRODUCTS}/Debug-iphonesimulator/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule/." "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule"
            
            # Step 5. Create universal binary file using lipo and place the combined executable in the copied framework directory
            lipo -create -output "${UNIVERSAL_TARGET}" "${BUILD_DIR}/Debug-iphonesimulator/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework/${PROJECT_NAME}"
            
            # Step 6. Convenience step to copy the framework to the project's directory
            cp -R "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework" "${PROJECT_DIR}/build-universal"
            
            # Step 7. Convenience step to open the project's directory in Finder
            open "${PROJECT_DIR}/build-universal"
            
            # Step 8. Check it with the lipo command for architectures
            xcrun lipo -info ${PROJECT_DIR}/build-universal/${PROJECT_NAME}.framework/${PROJECT_NAME}

### BUILD INSTRUCTIONS: UNIVERSAL FRAMEWORK TARGET

Do the following to build the universal fat framework:
   - Change to the scheme: Product --> Scheme --> RFIDEncoderUniversal
   - Build it: cmd-b
   - The universal fat framework will be in the project build-universal directory
    
Embed this framework in other projects to make sure all targets are available.

The rest of the notes below are from the old EPCEncoder, and are left here for reference (but weren't used).  Everything you need should be above.



TPM 11/1/15

Note: the first version of this project leveraged this great tutorial to create a framework:

http://www.raywenderlich.com/65964/create-a-framework-for-ios
https://www.raywenderlich.com/65964/create-a-framework-for-ios

TPM - 11/2/15

I got the framework and the static library to work.  I opted to use the framework version because it packed
all targets.  See the RFID apps: ValiTag, RapiTag, PosiTag, and TagIt...

libEPCEncoder.a was an intermediate step of the above tutorial, so I just dumped them all into the build
directory.  The completed framework is there as well.  Note, you need to build the Framework target in XCode
to get all this.  If you just build EPCEncoder, you won't get the framework or the lib in the build directory.

TPM - 11/18/15

With the release of XCode 7 for iOS 9, you have to choose your platform.  Before you could use the same
framework for both iOS and OSX.  No longer.  I've split this into two now, one framework for iOS and another
for OSX.

TPM - 11/18/16

Wow, literally one year later :)

So with XCode 8 for iOS 10, I'm getting a couple of ditto errors at the end of the framework build script,
but the directories it's complaining about are there, and the framework is complete (header and .m files 
copied, as is the library with all the proper sym links created to the latest version).

So, just build the EPCEncoder target, then right click on the libEPCEncoder.a Product in the left nav pane
under Products and select Show in Finder.

This takes you to the directory where the EPCEncoder.framework is also located (check the build date).
Open one of your dependent projects (ValiTag, RapiTag, etc) and delete the old framework.  Now drag and drop
the new framework into that project and viola, you are good to go!

Now,as I looked at this more, I noticed the "build" subdirectory in the project contained a framework that was
out of date. So I deleted it, ran the build again, XCode complained that I needed to specify a Signing entity
for the EPCEncoderTests (I added timmilne), and then I was able to select Product -> Scheme -> Framework and
build the framework.  Now it shows up in the local build subdirectory of the project, and you can copy it from
here to the dependent projects.

Note, I came across the wenderlich tutorial again (it really is good), as well as another that shows how to
create a Cocoa Pod that would better manage dependencies:

https://www.raywenderlich.com/65964/create-a-framework-for-ios
https://www.raywenderlich.com/126365/ios-frameworks-tutorial

Also note: as I was reviewing the first tutorial above, I noted that the fat build for the framework only
includes 5 frameworks:

arm7: Used in the oldest iOS 7-supporting devices
arm7s: As used in iPhone 5 and 5C
arm64: For the 64-bit ARM processor in iPhone 5S
i386: For the 32-bit simulator
x86_64: Used in 64-bit simulator

So, at some point you may need to update this for new architectures.

TPM - 11/20/16

Compiling for the iPhone 6, 7 and 7 plus was throwing an error that the EPCEncoder was missing the Arm64
architecture (as I suspected).

So I found this:

http://stackoverflow.com/questions/26552855/xcode-6-1-missing-required-architecture-x86-64-in-file

There is a setting it recommends:
Framework -> Build Settings -> Architecture -> Build Active Architecture Only
(set to No for framework and EPCEncoder)

Recompile the framework and library, and then copy it over to TagIt and it now works.  You can check that
the right architectures are there by right clicking on libEPCEncoder.a in the left nav pane, selecting
Show in Finder, then figuring out where it is (or the one in the local project's build directory) and 
running: lipo - info libEPCEncoder.a, and it should show you the architectures (armv7 and arm64)')

Now, if you want to make changes to the build script, scroll down to one of the comments in the link above:

<Note: I'm not using this script, but it does show how to compile with all targets>

Many use the build scripts found either here:

   http://www.raywenderlich.com/41377/creating-a-static-library-in-ios-tutorial

or here:

   https://gist.github.com/sponno/7228256

for their run script in their target.

I was pulling my hair out trying to add x86_64, i386, armv7s, armv7, and arm64 to the Architectures section,
only to find lipo -info targetname.a never returning these architectures after a successful build.

In my case, I had to modify the target runscript, specifically step 1 from the gist link, to manually include
the architectures using -arch.

Step 1. Build Device and Simulator versions
xcodebuild -target ${PROJECT_NAME} ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}"
BUILD_ROOT="${BUILD_ROOT}" xcodebuild -target ${PROJECT_NAME} -configuration ${CONFIGURATION} -sdk iphonesimulator -arch x86_64 -arch i386 -arch armv7 -arch armv7s -arch arm64 BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"


TPM here again - I think what's happening is the build settings is ARCHS_STANDARD, and eventually that
includes everything.  By setting that, and then setting build active architecture only to no you get all
the standard ones, eventually.  So I may not need to worry about this, just rebuild this on occasion.'

